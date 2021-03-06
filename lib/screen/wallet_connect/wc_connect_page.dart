//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/common/network_config_injector.dart';
import 'package:autonomy_flutter/database/entity/persona.dart';
import 'package:autonomy_flutter/main.dart';
import 'package:autonomy_flutter/model/network.dart';
import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/screen/bloc/accounts/accounts_bloc.dart';
import 'package:autonomy_flutter/screen/bloc/persona/persona_bloc.dart';
import 'package:autonomy_flutter/screen/connection/persona_connections_page.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_page.dart';
import 'package:autonomy_flutter/service/account_service.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/service/ethereum_service.dart';
import 'package:autonomy_flutter/service/navigation_service.dart';
import 'package:autonomy_flutter/service/tezos_beacon_service.dart';
import 'package:autonomy_flutter/service/tezos_service.dart';
import 'package:autonomy_flutter/service/wallet_connect_service.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:autonomy_flutter/util/log.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/tezos_beacon_channel.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:autonomy_flutter/view/au_filled_button.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet_connect/models/wc_peer_meta.dart';

/*
 Because WalletConnect & TezosBeacon are using same logic:
 - select persona 
 - suggest to generate persona
 => use this page for both WalletConnect & TezosBeacon connect
*/
class WCConnectPage extends StatefulWidget {
  static const String tag = AppRouter.wcConnectPage;

  final WCConnectPageArgs? wcConnectArgs;
  final BeaconRequest? beaconRequest;

  const WCConnectPage(
      {Key? key, required this.wcConnectArgs, required this.beaconRequest})
      : super(key: key);

  @override
  State<WCConnectPage> createState() => _WCConnectPageState();
}

class _WCConnectPageState extends State<WCConnectPage>
    with RouteAware, WidgetsBindingObserver {
  Persona? selectedPersona;
  List<Persona>? personas;
  bool generatedPersona = false;

  @override
  void initState() {
    super.initState();
    context.read<PersonaBloc>().add(GetListPersonaEvent());
    injector<NavigationService>().setIsWCConnectInShow(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    context.read<PersonaBloc>().add(GetListPersonaEvent());
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    injector<NavigationService>().setIsWCConnectInShow(false);
  }

  void _reject() {
    final wcConnectArgs = widget.wcConnectArgs;
    final beaconRequest = widget.beaconRequest;
    if (wcConnectArgs != null) {
      injector<WalletConnectService>().rejectSession(wcConnectArgs.peerMeta);
    }

    if (beaconRequest != null) {
      injector<TezosBeaconService>()
          .permissionResponse(null, beaconRequest.id, null, null);
    }

    Navigator.of(context).pop();
  }

  Future _approve() async {
    if (selectedPersona == null) return;

    final wcConnectArgs = widget.wcConnectArgs;
    final beaconRequest = widget.beaconRequest;

    late String payloadAddress;
    late CryptoType payloadType;

    if (wcConnectArgs != null) {
      final address = await injector<NetworkConfigInjector>()
          .I<EthereumService>()
          .getETHAddress(selectedPersona!.wallet());

      final chainId =
          injector<ConfigurationService>().getNetwork() == Network.MAINNET
              ? 1
              : 4;

      final approvedAddresses = [address];
      log.info(
          "[WCConnectPage] approve WCConnect with addreses ${approvedAddresses}");
      await injector<WalletConnectService>().approveSession(
          selectedPersona!.uuid,
          wcConnectArgs.peerMeta,
          approvedAddresses,
          chainId);

      payloadAddress = address;
      payloadType = CryptoType.ETH;

      if (wcConnectArgs.peerMeta.url.contains("feralfile")) {
        _navigateWhenConnectFeralFile();
        return;
      }
    }

    if (beaconRequest != null) {
      final tezosWallet = await selectedPersona!.wallet().getTezosWallet();
      final publicKey = await injector<NetworkConfigInjector>()
          .I<TezosService>()
          .getPublicKey(tezosWallet);
      await injector<TezosBeaconService>().permissionResponse(
        selectedPersona!.uuid,
        beaconRequest.id,
        publicKey,
        tezosWallet.address,
      );
      payloadAddress = tezosWallet.address;
      payloadType = CryptoType.XTZ;
    }

    final payload = PersonaConnectionsPayload(
      personaUUID: selectedPersona!.uuid,
      address: payloadAddress,
      type: payloadType,
    );

    if (memoryValues.scopedPersona != null) {
      // from persona details flow
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(
          AppRouter.personaConnectionsPage,
          arguments: payload);
    }
  }

  void _navigateWhenConnectFeralFile() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackAppBar(
        context,
        onBack: () => _reject(),
      ),
      body: Container(
        margin: pageEdgeInsetsWithSubmitButton,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Connect",
            style: appTextTheme.headline1,
          ),
          SizedBox(height: 24.0),
          _appInfo(),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...grantPermissions
                    .map(
                      (permission) =>
                          Text("• $permission", style: appTextTheme.bodyText1),
                    )
                    .toList(),
              ],
            ),
          ),
          SizedBox(height: 40),
          BlocConsumer<PersonaBloc, PersonaState>(listener: (context, state) {
            var statePersonas = state.personas;
            if (statePersonas == null) return;

            final scopedPersonaUUID = memoryValues.scopedPersona;
            if (scopedPersonaUUID != null) {
              final scopedPersona = statePersonas
                  .firstWhere((element) => element.uuid == scopedPersonaUUID);
              statePersonas = [scopedPersona];
            }

            if (statePersonas.length == 1) {
              setState(() {
                selectedPersona = statePersonas?.first;
              });
            }

            setState(() {
              personas = statePersonas;
            });
          }, builder: (context, state) {
            final statePersonas = personas;
            if (statePersonas == null) return SizedBox();

            if (statePersonas.isEmpty) {
              return Expanded(child: _suggestToCreatePersona());
            } else {
              return Expanded(child: _selectPersonaWidget(statePersonas));
            }
          }),
        ]),
      ),
    );
  }

  Widget _appInfo() {
    if (widget.wcConnectArgs != null) {
      return _wcAppInfo(widget.wcConnectArgs!.peerMeta);
    }

    if (widget.beaconRequest != null) {
      return _tbAppInfo(widget.beaconRequest!);
    }

    return SizedBox();
  }

  Widget _wcAppInfo(WCPeerMeta peerMeta) {
    return Column(
      children: [
        Row(
          children: [
            if (peerMeta.icons.isNotEmpty) ...[
              CachedNetworkImage(
                imageUrl: peerMeta.icons.first,
                width: 64.0,
                height: 64.0,
                errorWidget: (context, url, error) => Container(
                    width: 64,
                    height: 64,
                    child: Image.asset(
                        "assets/images/walletconnect-alternative.png")),
              ),
            ] else ...[
              Container(
                  width: 64,
                  height: 64,
                  child: Image.asset(
                      "assets/images/walletconnect-alternative.png")),
            ],
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(peerMeta.name, style: appTextTheme.headline4),
                  Text(
                    "requests permission to:",
                    style: appTextTheme.bodyText1,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _tbAppInfo(BeaconRequest request) {
    return Column(
      children: [
        Row(
          children: [
            request.icon != null
                ? CachedNetworkImage(
                    imageUrl: request.icon!,
                    width: 64.0,
                    height: 64.0,
                    errorWidget: (context, url, error) => SvgPicture.asset(
                      "assets/images/tezos_social_icon.svg",
                      width: 64.0,
                      height: 64.0,
                    ),
                  )
                : SvgPicture.asset(
                    "assets/images/tezos_social_icon.svg",
                    width: 64.0,
                    height: 64.0,
                  ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request.appName ?? "", style: appTextTheme.headline4),
                  Text(
                    "requests permission to:",
                    style: appTextTheme.bodyText1,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _selectPersonaWidget(List<Persona> personas) {
    bool hasRadio = personas.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select an account to grant access:",
          style: appTextTheme.headline4,
        ),
        SizedBox(height: 16.0),
        Expanded(
          child: ListView(
            children: <Widget>[
              ...personas
                  .map((persona) => Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Container(
                                    width: 24,
                                    height: 24,
                                    child: Image.asset(
                                        "assets/images/autonomyIcon.png")),
                                SizedBox(width: 16.0),
                                Text(persona.name,
                                    style: appTextTheme.headline4)
                              ],
                            ),
                            contentPadding: EdgeInsets.zero,
                            trailing: (hasRadio
                                ? Transform.scale(
                                    scale: 1.2,
                                    child: Radio(
                                      activeColor: Colors.black,
                                      value: persona,
                                      groupValue: selectedPersona,
                                      onChanged: (Persona? value) {
                                        setState(() {
                                          selectedPersona = value;
                                        });
                                      },
                                    ),
                                  )
                                : null),
                          ),
                          Divider(height: 16.0),
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: AuFilledButton(
                text: "Connect".toUpperCase(),
                onPress: () => _approve(),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _suggestToCreatePersona() {
    return BlocConsumer<PersonaBloc, PersonaState>(
      listener: (context, state) {
        switch (state.createAccountState) {
          case ActionState.done:
            UIHelper.hideInfoDialog(context);
            UIHelper.showGeneratedPersonaDialog(context, onContinue: () {
              UIHelper.hideInfoDialog(context);
              final createdPersona = state.persona;
              if (createdPersona != null) {
                Navigator.of(context).pushNamed(AppRouter.namePersonaPage,
                    arguments: createdPersona.uuid);
              }
            });
            break;

          default:
            break;
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            // Expanded(
            Expanded(
              child: Column(
                children: [
                  Text(
                      'This service requires a full Autonomy account to connect to the dapp.',
                      style: appTextTheme.bodyText1),
                  SizedBox(height: 24),
                  Text('Would you like to generate a full Autonomy account?',
                      style: appTextTheme.bodyText1
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 24),
                  Text(
                      'The newly generated account would also get an address for each of the chains that we support.',
                      style: appTextTheme.bodyText1),
                ],
              ),
            ),
            // ),
            Row(
              children: [
                Expanded(
                  child: AuFilledButton(
                    text: "Generate".toUpperCase(),
                    onPress: () {
                      context.read<PersonaBloc>().add(CreatePersonaEvent());
                    },
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}

class WCConnectPageArgs {
  final int id;
  final WCPeerMeta peerMeta;

  WCConnectPageArgs(this.id, this.peerMeta);
}
