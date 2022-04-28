import 'package:autonomy_flutter/model/network.dart';
import 'package:autonomy_flutter/util/constants.dart';

class AppConfig {
  static const String ffAuthorizationPrefix =
      "FERAL FILE AUTHORIZATION\n\nTimestamp: ";
  static const String openSeaApiKey = "";
  static const AppConfigNetwork testNetworkConfig = AppConfigNetwork(
    "https://rinkeby.infura.io/v3/20aba74f4e8642b88808ff4df18c10ff",
    "https://hangzhounet.smartpy.io",
    "https://api.test.bitmark.com",
    "https://indexer.test.autonomy.io",
    "https://feralfile1.dev.bitmark.com",
    "https://connect.test.autonomy.io",
    "wss://connect.test.autonomy.io/ws",
  );
  static const AppConfigNetwork mainNetworkConfig = AppConfigNetwork(
    "https://mainnet.infura.io/v3/ab0e0fe9710b412ca73bb044713a3523",
    "https://rpc.tzbeta.net",
    "https://api.bitmark.com",
    "https://indexer.autonomy.io",
    "https://feralfile.com",
    "https://connect.autonomy.io",
    "wss://connect.autonomy.io/ws",
  );

  static String networkedWebsocketURL(Network network) {
    switch (network) {
      case Network.MAINNET:
        return mainNetworkConfig.websocketUrl;
      case Network.TESTNET:
        return testNetworkConfig.websocketUrl;
    }
  }

  static String networkedExtensionSupportURL(Network network) {
    switch (network) {
      case Network.MAINNET:
        return mainNetworkConfig.extensionSupportUrl;
      case Network.TESTNET:
        return testNetworkConfig.extensionSupportUrl;
    }
  }

  static Future<String> get autonomyAuthURL async {
    return await isAppCenterBuild()
        ? 'https://accounts.test.autonomy.io'
        : 'https://accounts.autonomy.io';
  }

  static Future<String> get customerSupportURL async {
    return await isAppCenterBuild()
        ? 'https://support.test.autonomy.io'
        : 'https://support.autonomy.io';
  }
}

class AppConfigNetwork {
  final String web3RpcUrl;
  final String tezosNodeClientUrl;
  final String bitmarkApiUrl;
  final String indexerApiUrl;
  final String feralFileApiUrl;
  final String extensionSupportUrl;
  final String websocketUrl;

  const AppConfigNetwork(
      this.web3RpcUrl,
      this.tezosNodeClientUrl,
      this.bitmarkApiUrl,
      this.indexerApiUrl,
      this.feralFileApiUrl,
      this.extensionSupportUrl,
      this.websocketUrl);
}
