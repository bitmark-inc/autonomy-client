//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/util/constants.dart';
import 'package:libauk_dart/libauk_dart.dart';

abstract class WalletDetailEvent {}

class WalletDetailBalanceEvent extends WalletDetailEvent {
  CryptoType type;
  String address;

  WalletDetailBalanceEvent(this.type, this.address);
}

class WalletDetailState {
  String address = "";
  String balance = "";
  String balanceInUSD = "";

  WalletDetailState({
    this.address = "",
    this.balance = "",
    this.balanceInUSD = "",
  });

  WalletDetailState copyWith({
    String? address,
    String? balance,
    String? balanceInUSD,
  }) {
    return WalletDetailState(
      address: address ?? this.address,
      balance: balance ?? this.balance,
      balanceInUSD: balanceInUSD ?? this.balanceInUSD,
    );
  }
}
