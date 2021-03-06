//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/au_bloc.dart';
import 'package:autonomy_flutter/common/network_config_injector.dart';
import 'package:autonomy_flutter/database/app_database.dart';
import 'package:autonomy_flutter/database/cloud_database.dart';
import 'package:autonomy_flutter/database/dao/asset_token_dao.dart';
import 'package:autonomy_flutter/database/dao/provenance_dao.dart';
import 'package:autonomy_flutter/database/entity/connection.dart';
import 'package:autonomy_flutter/gateway/indexer_api.dart';
import 'package:autonomy_flutter/main.dart';
import 'package:autonomy_flutter/screen/home/home_state.dart';
import 'package:autonomy_flutter/service/account_service.dart';
import 'package:autonomy_flutter/service/feed_service.dart';
import 'package:autonomy_flutter/service/tezos_beacon_service.dart';
import 'package:autonomy_flutter/service/tokens_service.dart';
import 'package:autonomy_flutter/service/wallet_connect_service.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:autonomy_flutter/util/log.dart';

class HomeBloc extends AuBloc<HomeEvent, HomeState> {
  TokensService _tokensService;
  WalletConnectService _walletConnectService;
  TezosBeaconService _tezosBeaconService;
  NetworkConfigInjector _networkConfigInjector;
  CloudDatabase _cloudDB;
  FeedService _feedService;
  AccountService _accountService;

  AssetTokenDao get _assetTokenDao =>
      _networkConfigInjector.I<AppDatabase>().assetDao;
  ProvenanceDao get _provenanceDao =>
      _networkConfigInjector.I<AppDatabase>().provenanceDao;
  IndexerApi get _indexerApi => _networkConfigInjector.I<IndexerApi>();

  List<String> _hiddenOwners = [];

  Future<List<String>> fetchManuallyTokens() async {
    final tokenIndexerIDs = (await _cloudDB.connectionDao.getConnectionsByType(
            ConnectionType.manuallyIndexerTokenID.rawValue))
        .map((e) => e.key)
        .toList();
    if (tokenIndexerIDs.isEmpty) return [];

    final manuallyAssets =
        (await _indexerApi.getNftTokens({"ids": tokenIndexerIDs}));
    await _tokensService.insertAssetsWithProvenance(manuallyAssets);
    return tokenIndexerIDs;
  }

  HomeBloc(
    this._tokensService,
    this._walletConnectService,
    this._tezosBeaconService,
    this._networkConfigInjector,
    this._cloudDB,
    this._feedService,
    this._accountService,
  ) : super(HomeState()) {
    on<HomeConnectWCEvent>((event, emit) {
      log.info('[HomeConnectWCEvent] connect ${event.uri}');
      _walletConnectService.connect(event.uri);
    });

    on<HomeConnectTZEvent>((event, emit) {
      log.info('[HomeConnectTZEvent] addPeer ${event.uri}');
      _tezosBeaconService.addPeer(event.uri);
    });

    on<SubRefreshTokensEvent>((event, emit) async {
      if (!memoryValues.inGalleryView) return;
      final assetTokens =
          await _assetTokenDao.findAllAssetTokensWhereNot(_hiddenOwners);
      emit(state.copyWith(tokens: assetTokens, fetchTokenState: event.state));
      log.info('[SubRefreshTokensEvent] load ${assetTokens.length} tokens');
    });

    on<RefreshTokensEvent>((event, emit) async {
      log.info("[HomeBloc] RefreshTokensEvent start");

      try {
        List<String> allAccountNumbers =
            await _accountService.getAllAddresses();

        //Clear and refresh all assets if no contractAddress & tokenId
        final tokens = await _assetTokenDao.findAllAssetTokens();
        if (tokens.every((element) =>
            element.contractAddress == null && element.tokenId == null)) {
          await _assetTokenDao.removeAll();
        }

        await _assetTokenDao.deleteAssetsNotBelongs(allAccountNumbers);

        _hiddenOwners = await _accountService.getHiddenAddresses();

        add(SubRefreshTokensEvent(ActionState.notRequested));

        final latestAssets = await _tokensService.fetchLatestAssets(
            allAccountNumbers, INDEXER_TOKENS_MAXIMUM);
        await _tokensService.insertAssetsWithProvenance(latestAssets);

        log.info("[HomeBloc] fetch ${latestAssets.length} latest NFTs");

        if (latestAssets.length < INDEXER_TOKENS_MAXIMUM) {
          // Delete obsoleted assets
          if (latestAssets.isNotEmpty) {
            final tokenIDs = latestAssets.map((e) => e.id).toList();
            await _assetTokenDao.deleteAssetsNotIn(tokenIDs);
            await _provenanceDao.deleteProvenanceNotBelongs(tokenIDs);
          } else {
            await _assetTokenDao.removeAll();
            await _provenanceDao.removeAll();
          }

          await fetchManuallyTokens();

          add(SubRefreshTokensEvent(ActionState.done));
          _feedService.refreshFollowings();
        } else {
          final debutTokenIDs = await fetchManuallyTokens();
          add(SubRefreshTokensEvent(ActionState.loading));
          log.info("[HomeBloc][start] _tokensService.refreshTokensInIsolate");

          final stream = await _tokensService.refreshTokensInIsolate(
              allAccountNumbers, debutTokenIDs);
          stream.listen((event) async {
            log.info("[Stream.refreshTokensInIsolate] getEvent");
            add(SubRefreshTokensEvent(ActionState.loading));
          }, onDone: () async {
            log.info("[Stream.refreshTokensInIsolate] getEvent Done");
            add(SubRefreshTokensEvent(ActionState.done));
            _feedService.refreshFollowings();
          });
        }
      } catch (exception) {
        if ((state.tokens ?? []).isEmpty) {
          rethrow;
        } else {
          Sentry.captureException(exception);
        }
      }
    });

    on<ReindexIndexerEvent>((event, emit) async {
      try {
        final addresses = await _accountService.getShowedAddresses();

        for (final address in addresses) {
          if (address.startsWith("tz")) {
            _indexerApi.requestIndex({"owner": address, "blockchain": "tezos"});
          } else if (address.startsWith("0x")) {
            _indexerApi.requestIndex({"owner": address});
          }
        }
      } catch (exception) {
        log.info("[HomeBloc] error when request index");
        Sentry.captureException(exception);
      }
    });
  }
}
