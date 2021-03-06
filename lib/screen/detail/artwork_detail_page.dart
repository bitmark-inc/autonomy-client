//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'dart:collection';

import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/common/network_config_injector.dart';
import 'package:autonomy_flutter/database/app_database.dart';
import 'package:autonomy_flutter/database/entity/asset_token.dart';
import 'package:autonomy_flutter/model/provenance.dart';
import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/screen/bloc/accounts/accounts_bloc.dart';
import 'package:autonomy_flutter/screen/bloc/identity/identity_bloc.dart';
import 'package:autonomy_flutter/screen/detail/artwork_detail_bloc.dart';
import 'package:autonomy_flutter/screen/detail/artwork_detail_state.dart';
import 'package:autonomy_flutter/screen/settings/crypto/send_artwork/send_artwork_page.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/service/settings_data_service.dart';
import 'package:autonomy_flutter/util/string_ext.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/theme_manager.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:autonomy_flutter/view/artwork_common_widget.dart';
import 'package:autonomy_flutter/view/au_outlined_button.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:path/path.dart' as p;

class ArtworkDetailPage extends StatefulWidget {
  final ArtworkDetailPayload payload;

  const ArtworkDetailPage({Key? key, required this.payload}) : super(key: key);

  @override
  State<ArtworkDetailPage> createState() => _ArtworkDetailPageState();
}

class _ArtworkDetailPageState extends State<ArtworkDetailPage> {
  late ScrollController _scrollController;
  bool _showArtwortReportProblemContainer = true;
  HashSet<String> _accountNumberHash = HashSet.identity();
  AssetToken? currentAsset;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();

    context.read<ArtworkDetailBloc>().add(ArtworkDetailGetInfoEvent(
        widget.payload.ids[widget.payload.currentIndex]));
    context.read<AccountsBloc>().add(FetchAllAddressesEvent());
  }

  _scrollListener() {
    /*
    So we see it like that when we are at the top of the page. 
    When we start scrolling down it disappears and we see it again attached at the bottom of the page.
    And if we scroll all the way up again, we would display again it attached down the screen
    https://www.figma.com/file/Ze71GH9ZmZlJwtPjeHYZpc?node-id=51:5175#159199971
    */
    if (_scrollController.offset > 80) {
      setState(() {
        _showArtwortReportProblemContainer = false;
      });
    } else {
      setState(() {
        _showArtwortReportProblemContainer = true;
      });
    }

    if (_scrollController.position.pixels + 100 >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _showArtwortReportProblemContainer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    return Stack(
      fit: StackFit.loose,
      children: [
        Scaffold(
          appBar: getBackAppBar(context,
              onBack: () => Navigator.of(context).pop(),
              action: () {
                if (currentAsset == null) return;
                _showArtworkOptionsDialog(currentAsset!);
              }),
          body: BlocConsumer<ArtworkDetailBloc, ArtworkDetailState>(
              listener: (context, state) {
            final identitiesList =
                state.provenances.map((e) => e.owner).toList();
            if (state.asset?.artistName != null &&
                state.asset!.artistName!.length > 20) {
              identitiesList.add(state.asset!.artistName!);
            }
            setState(() {
              currentAsset = state.asset;
            });

            context.read<IdentityBloc>().add(GetIdentityEvent(identitiesList));
          }, builder: (context, state) {
            if (state.asset != null) {
              final identityState = context.watch<IdentityBloc>().state;
              final asset = state.asset!;

              final artistName =
                  asset.artistName?.toIdentityOrMask(identityState.identityMap);

              var subTitle = "";
              if (artistName != null && artistName.isNotEmpty) {
                subTitle = "by $artistName";
              }
              subTitle += getEditionSubTitle(asset);

              return Container(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          asset.title,
                          style: appTextTheme.headline1,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      if (subTitle.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            subTitle,
                            style: appTextTheme.headline3,
                          ),
                        ),
                      ],
                      SizedBox(height: 16.0),
                      GestureDetector(
                        child: tokenThumbnailWidget(context, asset),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      debugInfoWidget(currentAsset),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 165,
                              height: 48,
                              child: AuOutlinedButton(
                                text: "VIEW ARTWORK",
                                onPress: () => Navigator.of(context).pop(),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Text(
                              unescape.convert(asset.desc ?? ""),
                              style: appTextTheme.bodyText1,
                            ),
                            artworkDetailsRightSection(context, asset),
                            artworkDetailsValueSection(
                                context, asset, state.assetPrice),
                            SizedBox(height: 40.0),
                            artworkDetailsMetadataSection(
                                context, asset, artistName),
                            state.provenances.isNotEmpty
                                ? _provenanceView(context, state.provenances)
                                : SizedBox(),
                            SizedBox(height: 80.0),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          }),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: reportNFTProblemContainer(
              currentAsset, _showArtwortReportProblemContainer),
        ),
      ],
    );
  }

  Widget _provenanceView(BuildContext context, List<Provenance> provenances) {
    return BlocBuilder<IdentityBloc, IdentityState>(
      builder: (context, identityState) =>
          BlocBuilder<AccountsBloc, AccountsState>(
              builder: (context, accountsState) {
        final event = accountsState.event;
        if (event != null && event is FetchAllAddressesSuccessEvent) {
          _accountNumberHash = HashSet.of(event.addresses);
        }

        return artworkDetailsProvenanceSectionNotEmpty(context, provenances,
            _accountNumberHash, identityState.identityMap);
      }),
    );
  }

  Future _showArtworkOptionsDialog(AssetToken asset) async {
    final theme = AuThemeManager.get(AppTheme.sheetTheme);

    Widget optionRow({required String title, Function()? onTap}) {
      return InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.headline4),
              Icon(Icons.navigate_next, color: Colors.white),
            ],
          ),
        ),
        onTap: onTap,
      );
    }

    final ownerWallet = await asset.getOwnerWallet();

    UIHelper.showDialog(
      context,
      "Options",
      Container(
        child: Column(
          children: [
            optionRow(
              title: asset.isHidden() ? 'Unhide artwork' : 'Hide artwork',
              onTap: () async {
                final appDatabase =
                    injector<NetworkConfigInjector>().I<AppDatabase>();
                if (asset.isHidden()) {
                  asset.hidden = null;
                } else {
                  asset.hidden = 1;
                }
                await appDatabase.assetDao.updateAsset(asset);
                await injector<ConfigurationService>()
                    .updateTempStorageHiddenTokenIDs(
                        [asset.id], asset.hidden == 1);
                injector<SettingsDataService>().backup();

                Navigator.of(context).pop();
                UIHelper.showHideArtworkResultDialog(context, asset.isHidden(),
                    onOK: () {
                  Navigator.of(context).popUntil((route) =>
                      route.settings.name == AppRouter.homePage ||
                      route.settings.name == AppRouter.homePageNoTransition);
                });
              },
            ),
            if (ownerWallet != null) ...[
              Divider(
                color: Colors.white,
                height: 1,
                thickness: 1,
              ),
              optionRow(
                title: "Send artwork",
                onTap: () async {
                  Navigator.of(context).popAndPushNamed(
                      AppRouter.sendArtworkPage,
                      arguments: SendArtworkPayload(asset, ownerWallet));
                },
              ),
            ],
            const SizedBox(
              height: 18,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "CANCEL",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: "IBMPlexMono"),
              ),
            ),
          ],
        ),
      ),
      isDismissible: true,
    );
  }
}

class ArtworkDetailPayload {
  final List<String> ids;
  final int currentIndex;

  ArtworkDetailPayload(this.ids, this.currentIndex);

  ArtworkDetailPayload copyWith({
    List<String>? ids,
    int? currentIndex,
  }) {
    return ArtworkDetailPayload(
      ids ?? this.ids,
      currentIndex ?? this.currentIndex,
    );
  }
}
