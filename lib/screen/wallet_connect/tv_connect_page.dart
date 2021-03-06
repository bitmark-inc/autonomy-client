//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/main.dart';
import 'package:autonomy_flutter/model/network.dart';
import 'package:autonomy_flutter/screen/bloc/persona/persona_bloc.dart';
import 'package:autonomy_flutter/screen/wallet_connect/wc_connect_page.dart';
import 'package:autonomy_flutter/service/account_service.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/service/navigation_service.dart';
import 'package:autonomy_flutter/service/wallet_connect_service.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/theme_manager.dart';
import 'package:autonomy_flutter/view/au_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class TVConnectPage extends StatefulWidget {
  final WCConnectPageArgs wcConnectArgs;

  const TVConnectPage({Key? key, required this.wcConnectArgs})
      : super(key: key);

  @override
  State<TVConnectPage> createState() => _TVConnectPageState();
}

class _TVConnectPageState extends State<TVConnectPage>
    with RouteAware, WidgetsBindingObserver {
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
    injector<WalletConnectService>().rejectSession(wcConnectArgs.peerMeta);

    Navigator.of(context).pop();
  }

  Future _approve() async {
    final authorizedKeypair =
        await injector<AccountService>().authorizeToViewer();

    final chainId =
        injector<ConfigurationService>().getNetwork() == Network.MAINNET
            ? 1
            : 4;

    await injector<WalletConnectService>().approveSession(Uuid().v4(),
        widget.wcConnectArgs.peerMeta, [authorizedKeypair], chainId);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AuThemeManager.get(AppTheme.sheetTheme);
    final appTextTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0.0,
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _reject(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 18, 8),
                child: Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/nav-arrow-left.svg',
                          color: Colors.white,
                        ),
                        SizedBox(width: 7),
                        Text(
                          "BACK",
                          style: appTextTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: pageEdgeInsetsWithSubmitButton,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Connect to Autonomy Viewer",
            style: appTextTheme.headline1,
          ),
          SizedBox(height: 24),
          Text(
              "Instantly set up your personal NFT art gallery on TVs and projectors anywhere you go.",
              style: appTextTheme.bodyText1),
          Divider(
            height: 64,
            color: Colors.white,
          ),
          Text("Autonomy Viewer is requesting to: ",
              style: appTextTheme.bodyText1),
          SizedBox(height: 8),
          Text("• View your Autonomy NFT collections",
              style: appTextTheme.bodyText1),
          Expanded(child: SizedBox()),
          Row(
            children: [
              Expanded(
                child: AuFilledButton(
                  text: "Authorize".toUpperCase(),
                  onPress: () => _approve(),
                  color: theme.primaryColor,
                  textStyle: TextStyle(
                      color: theme.backgroundColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: "IBMPlexMono"),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
