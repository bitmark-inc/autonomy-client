import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_page.dart';
import 'package:autonomy_flutter/view/au_filled_button.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class ReceivePage extends StatelessWidget {
  static const String tag = 'receive';

  final WalletPayload payload;

  const ReceivePage({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackAppBar(
        context,
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Receive ${payload.type == CryptoType.ETH ? "ETH" : "XTZ"}",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
            ),
            SizedBox(height: 96),
            Center(
              child: QrImage(
                data: payload.address,
                size: 200.0,
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              color: Color(0x44EDEDED),
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deposit address",
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: "AtlasGrotesk"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      payload.address,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontFamily: "IBMPlexMono"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(
                  child: AuFilledButton(
                    text: "Share",
                    onPress: () {
                      Share.share(payload.address);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WalletPayload {
  final CryptoType type;
  final String address;

  WalletPayload(this.type, this.address);
}