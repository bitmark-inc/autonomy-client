import 'dart:math';

import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_page.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_state.dart';
import 'package:autonomy_flutter/service/currency_service.dart';
import 'package:autonomy_flutter/service/ethereum_service.dart';
import 'package:autonomy_flutter/service/tezos_service.dart';
import 'package:autonomy_flutter/util/eth_amount_formatter.dart';
import 'package:autonomy_flutter/util/xtz_amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletDetailBloc extends Bloc<WalletDetailEvent, WalletDetailState> {
  EthereumService _ethereumService;
  TezosService _tezosService;
  CurrencyService _currencyService;

  WalletDetailBloc(
      this._ethereumService, this._tezosService, this._currencyService)
      : super(WalletDetailState()) {
    on<WalletDetailBalanceEvent>((event, emit) async {
      final exchangeRate = await _currencyService.getExchangeRates();

      switch (event.type) {
        case CryptoType.ETH:
          final address = await _ethereumService.getETHAddress();
          final balance = await _ethereumService.getBalance(address);

          state.address = address;
          state.balance =
              "${EthAmountFormatter(balance.getInWei).format().characters.take(7)} ETH";
          state.balanceInUSD = (balance.getInWei.toDouble() / pow(10, 18) / double.parse(exchangeRate.eth)).toStringAsFixed(2) + " USD";
          break;
        case CryptoType.XTZ:
          final address = await _tezosService.getTezosAddress();
          final balance = await _tezosService.getBalance(address);

          state.address = address;
          state.balance = "${XtzAmountFormatter(balance).format()} XTZ";
          state.balanceInUSD = (balance / pow(10, 6) / double.parse(exchangeRate.xtz)).toStringAsFixed(2) + " USD";

          break;
      }

      emit(state);
    });
  }
}