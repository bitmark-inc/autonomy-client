//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/database/entity/connection.dart';
import 'package:autonomy_flutter/model/currency_exchange.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:libauk_dart/libauk_dart.dart';

abstract class SendCryptoEvent {}

class GetBalanceEvent extends SendCryptoEvent {
  String address;

  GetBalanceEvent(this.address);
}

class AmountChangedEvent extends SendCryptoEvent {
  final String amount;

  AmountChangedEvent(this.amount);
}

class AddressChangedEvent extends SendCryptoEvent {
  final String address;

  AddressChangedEvent(this.address);
}

class CurrencyTypeChangedEvent extends SendCryptoEvent {
  final bool isCrypto;

  CurrencyTypeChangedEvent(this.isCrypto);
}

class EstimateFeeEvent extends SendCryptoEvent {
  final String address;
  final BigInt amount;

  EstimateFeeEvent(this.address, this.amount);
}

class SendCryptoState {
  WalletStorage? wallet;
  Connection? connection;

  bool isScanQR;
  bool isCrypto;

  bool isAddressError;
  bool isAmountError;

  bool isValid;

  String? address;
  BigInt? amount;
  BigInt? fee;
  BigInt? maxAllow;
  BigInt? balance;

  CurrencyExchangeRate exchangeRate;

  SendCryptoState(
      {this.wallet,
      this.connection,
      this.isScanQR = true,
      this.isCrypto = true,
      this.isAddressError = false,
      this.isAmountError = false,
      this.isValid = false,
      this.address,
      this.amount,
      this.fee,
      this.maxAllow,
      this.balance,
      this.exchangeRate = const CurrencyExchangeRate(eth: "1.0", xtz: "1.0")});

  SendCryptoState clone() => SendCryptoState(
        wallet: wallet,
        connection: connection,
        isScanQR: isScanQR,
        isCrypto: isCrypto,
        isAddressError: isAddressError,
        isAmountError: isAmountError,
        isValid: isValid,
        address: address,
        amount: amount,
        fee: fee,
        maxAllow: maxAllow,
        balance: balance,
        exchangeRate: exchangeRate,
      );
}
