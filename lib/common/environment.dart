//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/model/network.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static const String openSeaApiKey = "";

  static String networkedWebsocketURL(Network network) {
    return network == Network.MAINNET
        ? Environment.connectWebsocketMainnetURL
        : Environment.connectWebsocketTestnetURL;
  }

  static String networkedExtensionSupportURL(Network network) {
    return network == Network.MAINNET
        ? Environment.extensionSupportMainnetURL
        : Environment.extensionSupportTestnetURL;
  }

  static String networkedFeralFileWebsiteURL(Network network) {
    return network == Network.MAINNET
        ? Environment.feralFileAPIMainnetURL
        : Environment.feralFileAPITestnetURL;
  }

  static String get indexerMainnetURL =>
      dotenv.env['INDEXER_MAINNET_API_URL'] ?? '';
  static String get indexerTestnetURL =>
      dotenv.env['INDEXER_TESTNET_API_URL'] ?? '';

  static String get web3RpcMainnetURL =>
      dotenv.env['WEB3_RPC_MAINNET_URL'] ?? '';
  static String get web3RpcTestnetURL =>
      dotenv.env['WEB3_RPC_TESTNET_URL'] ?? '';

  static String get tezosNodeClientMainnetURL =>
      dotenv.env['TEZOS_NODE_CLIENT_MAINNET_URL'] ?? '';
  static String get tezosNodeClientTestnetURL =>
      dotenv.env['TEZOS_NODE_CLIENT_TESTNET_URL'] ?? '';

  static String get bitmarkAPIMainnetURL =>
      dotenv.env['BITMARK_API_MAINNET_URL'] ?? '';
  static String get bitmarkAPITestnetURL =>
      dotenv.env['BITMARK_API_TESTNET_URL'] ?? '';
  static String get feralFileAPIMainnetURL =>
      dotenv.env['FERAL_FILE_API_MAINNET_URL'] ?? '';
  static String get feralFileAPITestnetURL =>
      dotenv.env['FERAL_FILE_API_TESTNET_URL'] ?? '';

  static String get extensionSupportMainnetURL =>
      dotenv.env['EXTENSION_SUPPORT_MAINNET_URL'] ?? '';
  static String get extensionSupportTestnetURL =>
      dotenv.env['EXTENSION_SUPPORT_TESTNET_URL'] ?? '';
  static String get connectWebsocketMainnetURL =>
      dotenv.env['CONNECT_WEBSOCKET_MAINNET_URL'] ?? '';
  static String get connectWebsocketTestnetURL =>
      dotenv.env['CONNECT_WEBSOCKET_TESTNET_URL'] ?? '';

  static String get autonomyAuthURL => dotenv.env['AUTONOMY_AUTH_URL'] ?? '';
  static String get feedURL => dotenv.env['FEED_URL'] ?? '';
  static String get customerSupportURL =>
      dotenv.env['CUSTOMER_SUPPORT_URL'] ?? '';
  static String get currencyExchangeURL =>
      dotenv.env['CURRENCY_EXCHANGE_URL'] ?? '';
  static String get pubdocURL => dotenv.env['AUTONOMY_PUBDOC_URL'] ?? '';
  static String get sentryDSN => dotenv.env['SENTRY_DSN'] ?? '';
  static String get onesignalAppID => dotenv.env['ONESIGNAL_APP_ID'] ?? '';
  static String get awsIdentityPoolId =>
      dotenv.env['AWS_IDENTITY_POOL_ID'] ?? '';
}

class Secret {
  static String get ffAuthorizationPrefix =>
      dotenv.env['FERAL_FILE_AUTHORIZATION_PREFIX'] ?? '';
}
