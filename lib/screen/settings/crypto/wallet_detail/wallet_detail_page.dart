//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'dart:async';

import 'package:autonomy_flutter/database/entity/connection.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/tezos_transaction_list_view.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:autonomy_flutter/util/log.dart';
import 'package:autonomy_flutter/util/wallet_storage_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libauk_dart/libauk_dart.dart';
import 'package:autonomy_flutter/screen/settings/crypto/receive_page.dart';
import 'package:autonomy_flutter/screen/settings/crypto/send/send_crypto_page.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/tezos_transaction_list_view.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_bloc.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_state.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:autonomy_flutter/view/au_outlined_button.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libauk_dart/libauk_dart.dart';

class WalletDetailPage extends StatefulWidget {
  final WalletDetailsPayload payload;

  const WalletDetailPage({Key? key, required this.payload}) : super(key: key);

  @override
  State<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends State<WalletDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    late String? address;
    if (widget.payload.wallet != null) {
      switch (widget.payload.type) {
        case CryptoType.ETH:
          final ethUnFormatted = await widget.payload.wallet!.getETHAddress();
          address = ethUnFormatted.getETHEip55Address();
          break;
        case CryptoType.XTZ:
          final wallet = await widget.payload.wallet!.getTezosWallet();
          address = wallet.address;
          break;
        default:
          address = null;
      }
    } else {
      final data = widget.payload.connection!.ledgerConnection;
      if (data == null) {
        address = widget.payload.connection!.accountNumber;
      } else {
        switch (widget.payload.type) {
          case CryptoType.ETH:
            address = data.ethereumAddress.firstOrNull;
            break;
          case CryptoType.XTZ:
            address = data.tezosAddress.firstOrNull;
            break;
          default:
            address = null;
        }
      }
    }

    if (address != null)
      context
          .read<WalletDetailBloc>()
          .add(WalletDetailBalanceEvent(widget.payload.type, address));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackAppBar(
        context,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: BlocConsumer<WalletDetailBloc, WalletDetailState>(
          listener: (context, state) async {},
          builder: (context, state) {
            return Container(
              margin: EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.balance.isNotEmpty
                              ? state.balance
                              : "-- ${widget.payload.type == CryptoType.ETH ? "ETH" : "XTZ"}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: "IBMPlexMono"),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          state.balanceInUSD.isNotEmpty
                              ? state.balanceInUSD
                              : "-- USD",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              fontFamily: "IBMPlexMono"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: widget.payload.type == CryptoType.XTZ
                        ? TezosTXListView(address: state.address)
                        : Container(),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AuOutlinedButton(
                          text: "Send",
                          onPress: () {
                            Navigator.of(context).pushNamed(SendCryptoPage.tag,
                                arguments: SendData(
                                    widget.payload.wallet,
                                    widget.payload.connection,
                                    widget.payload.type,
                                    null));
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: AuOutlinedButton(
                          text: "Receive",
                          onPress: () {
                            if (state.address.isNotEmpty) {
                              Navigator.of(context).pushNamed(ReceivePage.tag,
                                  arguments: WalletPayload(
                                      widget.payload.type, state.address));
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}

class WalletDetailsPayload {
  final CryptoType type;
  final WalletStorage? wallet;
  final Connection? connection;

  WalletDetailsPayload({
    required this.type,
    this.wallet,
    this.connection,
  });
}
