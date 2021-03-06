//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:wallet_connect/models/wc_peer_meta.dart';
import 'package:web3dart/web3dart.dart';

abstract class WCSendTransactionEvent {}

class WCSendTransactionEstimateEvent extends WCSendTransactionEvent {
  final EthereumAddress address;
  final EtherAmount amount;
  final String data;
  final String uuid;

  WCSendTransactionEstimateEvent(this.address, this.amount, this.data, this.uuid);
}

class WCSendTransactionSendEvent extends WCSendTransactionEvent {
  final WCPeerMeta peerMeta;
  final int requestId;
  final EthereumAddress to;
  final BigInt value;
  final BigInt? gas;
  final String? data;
  final String uuid;

  WCSendTransactionSendEvent(this.peerMeta, this.requestId, this.to, this.value, this.gas, this.data, this.uuid);
}

class WCSendTransactionRejectEvent extends WCSendTransactionEvent {
  final WCPeerMeta peerMeta;
  final int requestId;

  WCSendTransactionRejectEvent(this.peerMeta, this.requestId);
}

class WCSendTransactionState {
  BigInt? fee;
  bool isSending = false;
}