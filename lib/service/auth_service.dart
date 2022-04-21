import 'dart:io';

import 'package:autonomy_flutter/gateway/iap_api.dart';
import 'package:autonomy_flutter/model/jwt.dart';
import 'package:autonomy_flutter/service/account_service.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';

class AuthService {
  final IAPApi _authApi;
  final AccountService _accountService;
  final ConfigurationService _configurationService;
  JWT? _jwt;

  AuthService(this._authApi, this._accountService, this._configurationService);

  Future<JWT> getAuthToken({String? receiptData}) async {
    if (_jwt != null && _jwt!.isValid()) {
      return _jwt!;
    }

    final account = await this._accountService.getDefaultAccount();

    final message = DateTime.now().millisecondsSinceEpoch.toString();
    final accountDID = await account.getAccountDID();
    final signature = await account.getAccountDIDSignature(message);

    Map<String, dynamic> payload = {
      "requester": accountDID,
      "timestamp": message,
      "signature": signature,
    };

    // the receipt data can be set by passing the parameter,
    // or query through the configuration service
    late String? savedReceiptData;
    if (receiptData != null) {
      savedReceiptData = receiptData;
    } else {
      savedReceiptData = _configurationService.getIAPReceipt();
    }

    // add the receipt data if available
    if (savedReceiptData != null) {
      final platform;
      if (Platform.isIOS) {
        platform = 'apple';
      } else {
        platform = 'google';
      }
      payload.addAll({
        "receipt": {'platform': platform, 'receipt_data': receiptData}
      });
    }

    var newJwt = await _authApi.auth(payload);

    _jwt = newJwt;

    // Save the receipt data if the jwt is valid
    if (receiptData != null) {
      _configurationService.setIAPReceipt(receiptData);
    }

    return newJwt;
  }
}
