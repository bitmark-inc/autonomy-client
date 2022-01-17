import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/common/network_config_injector.dart';
import 'package:autonomy_flutter/model/network.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/service/ethereum_service.dart';
import 'package:autonomy_flutter/service/wallet_connect_service.dart';
import 'package:autonomy_flutter/view/au_filled_button.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:wallet_connect/models/wc_peer_meta.dart';

class WCConnectPage extends StatelessWidget {
  static const String tag = 'wc_connect';

  final WCConnectPageArgs args;

  const WCConnectPage({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networkInjector = injector<NetworkConfigInjector>();
    return Scaffold(
      appBar: getBackAppBar(
        context,
        onBack: () {
          injector<WalletConnectService>().rejectSession(args.peerMeta);
          Navigator.of(context).pop();
        },
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              "Connect",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 40.0),
            Row(
              children: [
                Image.network(
                  args.peerMeta.icons.first,
                  width: 64.0,
                  height: 64.0,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(args.peerMeta.name,
                          style: Theme.of(context).textTheme.headline5),
                      Text(
                        "requests permission to:",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              "• View your persona’s balance and activity",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 4.0),
            Text(
              "• Request approval for transactions",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(
                  child: AuFilledButton(
                    text: "Authorize".toUpperCase(),
                    onPress: () async {
                      final address =
                          await networkInjector.I<EthereumService>().getETHAddress();
                      final chainId = injector<ConfigurationService>().getNetwork() == Network.MAINNET ? 1 : 4;
                      injector<WalletConnectService>()
                          .approveSession(args.peerMeta, [address], chainId);
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WCConnectPageArgs {
  final int id;
  final WCPeerMeta peerMeta;

  WCConnectPageArgs(this.id, this.peerMeta);
}
