//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/database/entity/persona.dart';
import 'package:autonomy_flutter/model/network.dart';
import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/screen/bloc/ethereum/ethereum_bloc.dart';
import 'package:autonomy_flutter/screen/bloc/tezos/tezos_bloc.dart';
import 'package:autonomy_flutter/screen/connection/persona_connections_page.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_page.dart';
import 'package:autonomy_flutter/service/account_service.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/util/biometrics_util.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:autonomy_flutter/util/eth_amount_formatter.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/xtz_utils.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:autonomy_flutter/view/tappable_forward_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';

class PersonaDetailsPage extends StatefulWidget {
  final Persona persona;

  const PersonaDetailsPage({Key? key, required this.persona}) : super(key: key);

  @override
  State<PersonaDetailsPage> createState() => _PersonaDetailsPageState();
}

class _PersonaDetailsPageState extends State<PersonaDetailsPage> {
  bool isHideGalleryEnabled = false;

  @override
  void initState() {
    super.initState();

    context
        .read<EthereumBloc>()
        .add(GetEthereumAddressEvent(widget.persona.uuid));

    context.read<TezosBloc>().add(GetTezosAddressEvent(widget.persona.uuid));

    context
        .read<EthereumBloc>()
        .add(GetEthereumBalanceWithUUIDEvent(widget.persona.uuid));

    context
        .read<TezosBloc>()
        .add(GetTezosBalanceWithUUIDEvent(widget.persona.uuid));

    isHideGalleryEnabled = injector<AccountService>()
        .isPersonaHiddenInGallery(widget.persona.uuid);
  }

  final addressStyle = appTextTheme.bodyText2?.copyWith(color: Colors.black);
  final balanceStyle = appTextTheme.bodyText2?.copyWith(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final network = injector<ConfigurationService>().getNetwork();
    final uuid = widget.persona.uuid;

    return Scaffold(
      appBar: getBackAppBar(
        context,
        title: widget.persona.name,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Container(
        margin: pageEdgeInsets,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _addressesSection(uuid),
              SizedBox(height: 40),
              _cryptoSection(uuid, network),
              SizedBox(height: 40),
              _preferencesSection(),
              SizedBox(height: 40),
              _backupSection(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressesSection(String uuid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Addresses",
          style: appTextTheme.headline1,
        ),
        SizedBox(height: 24),
        FutureBuilder<String>(
            future: Persona.newPersona(uuid: uuid).wallet().getBitmarkAddress(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _addressRow(
                  address: snapshot.data ?? "",
                  type: CryptoType.BITMARK,
                );
              } else {
                return SizedBox();
              }
            }),
        addDivider(),
        BlocBuilder<EthereumBloc, EthereumState>(builder: (context, state) {
          return _addressRow(
            address: state.personaAddresses?[uuid] ?? "",
            type: CryptoType.ETH,
          );
        }),
        addDivider(),
        BlocBuilder<TezosBloc, TezosState>(builder: (context, state) {
          return _addressRow(
            address: state.personaAddresses?[uuid] ?? "",
            type: CryptoType.XTZ,
          );
        }),
      ],
    );
  }

  Widget _addressRow({required String address, required CryptoType type}) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(type.source, style: appTextTheme.headline4),
              SvgPicture.asset('assets/images/iconForward.svg'),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  address,
                  style: addressStyle,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        final payload = PersonaConnectionsPayload(
          personaUUID: widget.persona.uuid,
          address: address,
          type: type,
        );
        Navigator.of(context)
            .pushNamed(AppRouter.personaConnectionsPage, arguments: payload);
      },
    );
  }

  Widget _cryptoSection(String uuid, Network network) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Crypto",
          style: appTextTheme.headline1,
        ),
        SizedBox(
          height: 8,
        ),
        Column(
          children: [
            BlocBuilder<EthereumBloc, EthereumState>(
              builder: (context, state) {
                final ethAddress = state.personaAddresses?[uuid];
                final ethBalance = state.ethBalances[network]?[ethAddress];
                final cryptoType = CryptoType.ETH;

                return TappableForwardRow(
                    leftWidget: Text(cryptoType.fullCode,
                        style: appTextTheme.headline4),
                    rightWidget: Text(
                        ethBalance == null
                            ? "-- ETH"
                            : "${EthAmountFormatter(ethBalance.getInWei).format()} ETH",
                        style: balanceStyle),
                    onTap: () => Navigator.of(context).pushNamed(
                          AppRouter.walletDetailsPage,
                          arguments: WalletDetailsPayload(
                              type: CryptoType.ETH,
                              wallet: widget.persona.wallet()),
                        ));
              },
            ),
            addOnlyDivider(),
            BlocBuilder<TezosBloc, TezosState>(
              builder: (context, state) {
                final tezosAddress = state.personaAddresses?[uuid];
                final xtzBalance = state.balances[network]?[tezosAddress];
                final cryptoType = CryptoType.XTZ;

                return TappableForwardRow(
                    leftWidget: Text(cryptoType.fullCode,
                        style: appTextTheme.headline4),
                    rightWidget: Text(
                        xtzBalance == null
                            ? "-- XTZ"
                            : "${XtzAmountFormatter(xtzBalance).format()} XTZ",
                        style: balanceStyle),
                    onTap: () => Navigator.of(context).pushNamed(
                          AppRouter.walletDetailsPage,
                          arguments: WalletDetailsPayload(
                              type: CryptoType.XTZ,
                              wallet: widget.persona.wallet()),
                        ));
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _preferencesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Preferences",
        style: appTextTheme.headline1,
      ),
      SizedBox(
        height: 14,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Hide from collection', style: appTextTheme.headline4),
              CupertinoSwitch(
                value: isHideGalleryEnabled,
                onChanged: (value) async {
                  await injector<AccountService>()
                      .setHidePersonaInGallery(widget.persona.uuid, value);
                  setState(() {
                    isHideGalleryEnabled = value;
                  });
                },
                activeColor: Colors.black,
              )
            ],
          ),
          SizedBox(height: 14),
          Text(
            "Do not show this account's NFTs in the collection view.",
            style: appTextTheme.bodyText1,
          ),
        ],
      ),
      SizedBox(height: 12),
    ]);
  }

  Widget _backupSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Backup",
        style: appTextTheme.headline1,
      ),
      SizedBox(
        height: 8,
      ),
      TappableForwardRow(
          leftWidget: Text(
            'Recovery phrase',
            style: appTextTheme.headline4,
          ),
          onTap: () async {
            final configurationService = injector<ConfigurationService>();

            if (configurationService.isDevicePasscodeEnabled() &&
                await authenticateIsAvailable()) {
              final localAuth = LocalAuthentication();
              final didAuthenticate = await localAuth.authenticate(
                  localizedReason: 'Authentication for "Autonomy"');
              if (!didAuthenticate) {
                return;
              }
            }

            final words = await widget.persona.wallet().exportMnemonicWords();

            Navigator.of(context).pushNamed(AppRouter.recoveryPhrasePage,
                arguments: words.split(" "));
          }),
    ]);
  }
}
