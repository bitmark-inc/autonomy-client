//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:autonomy_flutter/view/tappable_forward_row.dart';
import 'package:flutter/material.dart';

class AccessMethodPage extends StatelessWidget {
  final String walletApp;
  const AccessMethodPage({Key? key, required this.walletApp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackAppBar(
        context,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Container(
        margin: pageEdgeInsets,
        child: Column(children: [
          Expanded(
              child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Access method",
                style: appTextTheme.headline1,
              ),
              addTitleSpace(),
              _linkAccount(context),
              addDivider(),
              _importAccount(context),
            ]),
          ))
        ]),
      ),
    );
  }

  Widget _linkAccount(BuildContext context) {
    return TappableForwardRowWithContent(
        leftWidget: Text('Link', style: appTextTheme.headline4),
        bottomWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View your NFTs without Autonomy accessing your private keys in ${walletApp.split('.').last}.',
              style: appTextTheme.bodyText1,
            ),
            if (walletApp == 'WalletApp.MetaMask') ...[
              SizedBox(height: 15),
              Text(
                'Autonomy currently only links to wallets on the Ethereum Mainnet. Other networks like Polygon are not yet supported.',
                style: bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColorTheme.secondaryDimGrey,
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          switch (walletApp) {
            case 'WalletApp.MetaMask':
              Navigator.of(context).pushNamed(AppRouter.linkAppOptionPage);
              break;

            case 'WalletApp.Kukai':
              Navigator.of(context).pushNamed(AppRouter.linkTezosKukaiPage);
              break;

            case 'WalletApp.Temple':
              Navigator.of(context).pushNamed(AppRouter.linkTezosTemplePage);
              break;

            default:
              return;
          }
        });
  }

  Widget _importAccount(BuildContext context) {
    return TappableForwardRowWithContent(
      leftWidget: Text('Import', style: appTextTheme.headline4),
      bottomWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'View and control your NFTs, sign authorizations, and connect to other platforms with Autonomy.',
              style: appTextTheme.bodyText1),
          SizedBox(height: 16),
          learnMoreAboutAutonomySecurityWidget(context),
        ],
      ),
      onTap: () => Navigator.of(context).pushNamed(AppRouter.importAccountPage),
    );
  }
}
