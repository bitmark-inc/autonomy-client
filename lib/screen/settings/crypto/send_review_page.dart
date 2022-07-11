//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/common/network_config_injector.dart';
import 'package:autonomy_flutter/database/entity/connection.dart';
import 'package:autonomy_flutter/screen/settings/crypto/send/send_crypto_page.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/service/ethereum_service.dart';
import 'package:autonomy_flutter/service/ledger_hardware/ledger_hardware_service.dart';
import 'package:autonomy_flutter/service/ledger_hardware/ledger_hardware_transport.dart';
import 'package:autonomy_flutter/service/tezos_service.dart';
import 'package:autonomy_flutter/util/biometrics_util.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:autonomy_flutter/util/eth_amount_formatter.dart';
import 'package:autonomy_flutter/util/log.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:autonomy_flutter/util/xtz_utils.dart';
import 'package:autonomy_flutter/view/au_filled_button.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tezart/tezart.dart';
import 'package:web3dart/credentials.dart';

class SendReviewPage extends StatefulWidget {
  static const String tag = 'send_review';

  final SendCryptoPayload payload;

  const SendReviewPage({Key? key, required this.payload}) : super(key: key);

  @override
  State<SendReviewPage> createState() => _SendReviewPageState();
}

class _SendReviewPageState extends State<SendReviewPage> {
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final total = widget.payload.amount + widget.payload.fee;

    return Scaffold(
      appBar: getBackAppBar(
        context,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Confirmation",
                  style: appTextTheme.headline1,
                ),
                SizedBox(height: 40.0),
                Text(
                  "To",
                  style: appTextTheme.headline4,
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.payload.address,
                  style: appTextTheme.bodyText2,
                ),
                Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Send",
                      style: appTextTheme.headline4,
                    ),
                    Text(
                      widget.payload.type == CryptoType.ETH
                          ? "${EthAmountFormatter(widget.payload.amount).format()} ETH (${widget.payload.exchangeRate.ethToUsd(widget.payload.amount)} USD)"
                          : "${XtzAmountFormatter(widget.payload.amount.toInt()).format()} XTZ (${widget.payload.exchangeRate.xtzToUsd(widget.payload.amount.toInt())} USD)",
                      style: appTextTheme.bodyText2,
                    ),
                  ],
                ),
                Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gas fee",
                      style: appTextTheme.headline4,
                    ),
                    Text(
                      widget.payload.type == CryptoType.ETH
                          ? "${EthAmountFormatter(widget.payload.fee).format()} ETH (${widget.payload.exchangeRate.ethToUsd(widget.payload.fee)} USD)"
                          : "${XtzAmountFormatter(widget.payload.fee.toInt()).format()} XTZ (${widget.payload.exchangeRate.xtzToUsd(widget.payload.fee.toInt())} USD)",
                      style: appTextTheme.bodyText2,
                    ),
                  ],
                ),
                Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: appTextTheme.headline4,
                    ),
                    Text(
                      widget.payload.type == CryptoType.ETH
                          ? "${EthAmountFormatter(total).format()} ETH (${widget.payload.exchangeRate.ethToUsd(total)} USD)"
                          : "${XtzAmountFormatter(total.toInt()).format()} XTZ (${widget.payload.exchangeRate.xtzToUsd(total.toInt())} USD)",
                      style: appTextTheme.headline4,
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                Row(
                  children: [
                    Expanded(
                      child: AuFilledButton(
                        text: "Send",
                        onPress: _isSending
                            ? null
                            : () async {
                                setState(() {
                                  _isSending = true;
                                });

                                final configurationService =
                                    injector<ConfigurationService>();

                                if (configurationService
                                        .isDevicePasscodeEnabled() &&
                                    await authenticateIsAvailable()) {
                                  final localAuth = LocalAuthentication();
                                  final didAuthenticate =
                                      await localAuth.authenticate(
                                          localizedReason:
                                              'Authentication for "Autonomy"');
                                  if (!didAuthenticate) {
                                    setState(() {
                                      _isSending = false;
                                    });
                                    return;
                                  }
                                }

                                await _signAndSend();

                                setState(() {
                                  _isSending = false;
                                });
                              },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          _isSending ? Center(child: CupertinoActivityIndicator()) : SizedBox(),
        ],
      ),
    );
  }

  Future _signAndSend() async {
    final networkInjector = injector<NetworkConfigInjector>();

    switch (widget.payload.type) {
      case CryptoType.ETH:
        late String txHash;
        if (widget.payload.wallet != null) {
          final address = EthereumAddress.fromHex(widget.payload.address);
          txHash = await networkInjector.I<EthereumService>().sendTransaction(
              widget.payload.wallet!,
              address,
              widget.payload.amount,
              null,
              null);
        }

        Navigator.of(context).pop(txHash);
        break;
      case CryptoType.XTZ:
        late String? sig;
        if (widget.payload.wallet != null) {
          final tezosWallet = await widget.payload.wallet!.getTezosWallet();
          sig = await networkInjector.I<TezosService>().sendTransaction(
              tezosWallet,
              widget.payload.address,
              widget.payload.amount.toInt());
        } else if (widget.payload.connection != null &&
            widget.payload.connection!.connectionType ==
                ConnectionType.ledger.rawValue) {
          final ledgerConnection = widget.payload.connection?.ledgerConnection;
          if (ledgerConnection != null) {
            sig = await _signTezosWithLedger(networkInjector);
          }
        }

        Navigator.of(context).pop(sig);
        break;
      case CryptoType.BITMARK:
        // TODO: Handle this case.
        break;
    }
  }

  Future<String?> _signTezosWithLedger(
      NetworkConfigInjector networkInjector) async {
    final ledgerConnection = widget.payload.connection?.ledgerConnection;
    if (ledgerConnection == null) {
      return null;
    }

    UIHelper.showInfoDialog(
        context, ledgerConnection.ledgerName, "Connecting...",
        isDismissible: true);
    // Perform ledger connection
    final device = await injector<LedgerHardwareService>().connectWithUUID(
        ledgerConnection.ledgerName, ledgerConnection.ledgerUUID);

    final operationList = await networkInjector
        .I<TezosService>()
        .buildTransactions(
            null, widget.payload.address, widget.payload.amount.toInt());
    final txHex = operationList.result.forgedOperation;
    if (txHex == null) {
      log.warning("Nothing to sign");
      return null;
    }

    final sig = await LedgerCommand.signTezosOperation(
        device, "44'/1729'/0'/0'", txHex);
    operationList.result.signature =
        Signature.fromHex(data: sig, keystore: Keystore.random());
    return sig;
  }
}
