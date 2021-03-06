//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/database/entity/connection.dart';
import 'package:autonomy_flutter/screen/bloc/accounts/accounts_bloc.dart';
import 'package:autonomy_flutter/screen/global_receive/receive_detail_page.dart';
import 'package:autonomy_flutter/util/string_ext.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/view/tappable_forward_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget accountWithConnectionItem(
    BuildContext context, CategorizedAccounts categorizedAccounts) {
  switch (categorizedAccounts.className) {
    case 'Persona':
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: 24,
              height: 24,
              child: Image.asset("assets/images/autonomyIcon.png")),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(categorizedAccounts.category,
                    overflow: TextOverflow.ellipsis,
                    style: appTextTheme.headline4),
                SizedBox(height: 8),
                ...categorizedAccounts.accounts
                    .map((a) => Container(
                        child: _blockchainAddressView(a,
                            onTap: () => Navigator.of(context).pushNamed(
                                GlobalReceiveDetailPage.tag,
                                arguments: a))))
                    .toList(),
              ],
            ),
          ),
        ],
      );
    case 'Connection':
      final connection = categorizedAccounts.accounts.first.connections?.first;
      if (connection == null) return SizedBox();

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topCenter, child: _appLogo(connection)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          connection.name.isNotEmpty
                              ? connection.name
                              : "Unnamed",
                          overflow: TextOverflow.ellipsis,
                          style: appTextTheme.headline4),
                      _linkedBox(),
                    ]),
                SizedBox(height: 8),
                ...categorizedAccounts.accounts
                    .map((a) => Container(
                        child: _blockchainAddressView(a,
                            onTap: () => Navigator.of(context).pushNamed(
                                GlobalReceiveDetailPage.tag,
                                arguments: a))))
                    .toList(),
              ],
            ),
          ),
        ],
      );

    default:
      return SizedBox();
  }
}

Widget accountItem(BuildContext context, Account account,
    {Function()? onPersonaTap, Function()? onConnectionTap}) {
  final persona = account.persona;
  if (persona != null) {
    return TappableForwardRow(
        leftWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            accountLogo(account),
            SizedBox(width: 16),
            Text(
                account.name.isNotEmpty
                    ? account.name.maskIfNeeded()
                    : account.accountNumber.mask(4),
                style: appTextTheme.headline4),
          ],
        ),
        onTap: onPersonaTap);
  }

  final connection = account.connections?.first;
  if (connection != null) {
    return TappableForwardRow(
        leftWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            accountLogo(account),
            SizedBox(width: 16),
            Text(
                connection.name.isNotEmpty
                    ? connection.name.maskIfNeeded()
                    : connection.accountNumber.mask(4),
                style: appTextTheme.headline4),
          ],
        ),
        rightWidget: _linkedBox(),
        onTap: onConnectionTap);
  }

  return SizedBox();
}

Widget _blockchainAddressView(Account account, {Function()? onTap}) {
  return TappableForwardRow(
    padding: EdgeInsets.symmetric(vertical: 7),
    leftWidget: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _blockchainLogo(account.blockchain),
        SizedBox(width: 8),
        Text(
          _blockchainName(account.blockchain),
          style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: "AtlasGrotesk"),
        ),
        SizedBox(width: 8),
        Text(
          account.accountNumber.mask(4),
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "IBMPlexMono"),
        ),
      ],
    ),
    onTap: onTap,
  );
}

Widget _blockchainLogo(String? blockchain) {
  switch (blockchain) {
    case "Bitmark":
      return SvgPicture.asset('assets/images/iconBitmark.svg');
    case "Ethereum":
    case "walletConnect":
    case "walletBrowserConnect":
      return SvgPicture.asset('assets/images/iconEth.svg');
    case "Tezos":
    case "walletBeacon":
      return SvgPicture.asset('assets/images/iconXtz.svg');
    default:
      return SizedBox();
  }
}

String _blockchainName(String? blockchain) {
  switch (blockchain) {
    case "Bitmark":
      return "BITMARK";
    case "Ethereum":
    case "walletConnect":
      return "ETHEREUM";
    case "Tezos":
    case "walletBeacon":
      return "TEZOS";
    default:
      return "";
  }
}

Widget accountLogo(Account account) {
  if (account.persona != null) {
    return Container(
        width: 24,
        height: 24,
        child: Image.asset("assets/images/autonomyIcon.png"));
  }

  final connection = account.connections?.first;
  if (connection != null) {
    return _appLogo(connection);
  }

  return SizedBox(
    width: 24,
  );
}

Widget _appLogo(Connection connection) {
  switch (connection.connectionType) {
    case 'feralFileToken':
    case 'feralFileWeb3':
      return SvgPicture.asset("assets/images/feralfileAppIcon.svg");

    case 'ledger':
      return SvgPicture.asset("assets/images/iconLedger.svg");

    case 'walletConnect':
      final walletName =
          connection.wcConnectedSession?.sessionStore.remotePeerMeta.name;

      switch (walletName) {
        case "MetaMask":
          return Image.asset("assets/images/metamask-alternative.png");
        case "Trust Wallet":
          return Image.asset("assets/images/trust-alternative.png");
        default:
          return Image.asset("assets/images/walletconnect-alternative.png");
      }

    case 'walletBeacon':
      final walletName = connection.walletBeaconConnection?.peer.name;
      switch (walletName) {
        case "Kukai Wallet":
          return Image.asset("assets/images/kukai_wallet.png");
        case "Temple - Tezos Wallet":
        case "Temple - Tezos Wallet (ex. Thanos)":
          return Image.asset("assets/images/temple_wallet.png");
        default:
          return Image.asset("assets/images/tezos_wallet.png");
      }

    case 'walletBrowserConnect':
      final walletName = connection.data;
      switch (walletName) {
        case "MetaMask":
          return Image.asset("assets/images/metamask-alternative.png");
        default:
          return SizedBox(
            width: 24,
          );
      }

    default:
      return SizedBox(
        width: 24,
      );
  }
}

Widget _linkedBox() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    decoration:
        BoxDecoration(border: Border.all(color: Color(0xFF6D6B6B), width: 1)),
    child: Text(
      "LINKED",
      style: TextStyle(
          color: Color(0xFF6D6B6B), fontSize: 12, fontFamily: "IBMPlexMono"),
    ),
  );
}
