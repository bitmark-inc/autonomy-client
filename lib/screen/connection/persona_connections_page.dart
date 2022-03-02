import 'package:autonomy_flutter/main.dart';
import 'package:autonomy_flutter/screen/bloc/connections/connections_bloc.dart';
import 'package:autonomy_flutter/screen/scan_qr/scan_qr_page.dart';
import 'package:autonomy_flutter/util/string_ext.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:autonomy_flutter/view/tappable_forward_row.dart';
import 'package:flutter/material.dart';

import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/screen/settings/crypto/wallet_detail/wallet_detail_page.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/view/back_appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';

class PersonaConnectionsPage extends StatefulWidget {
  final PersonaConnectionsPayload payload;
  const PersonaConnectionsPage({Key? key, required this.payload})
      : super(key: key);

  @override
  State<PersonaConnectionsPage> createState() => _PersonaConnectionsPageState();
}

class _PersonaConnectionsPageState extends State<PersonaConnectionsPage>
    with RouteAware, WidgetsBindingObserver {
  final addressStyle = appTextTheme.bodyText2?.copyWith(color: Colors.black);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    _callFetchConnections();
    memoryValues =
        memoryValues.copyWith(scopedPersona: widget.payload.personaUUID);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _callFetchConnections();
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    memoryValues.scopedPersona = null;
  }

  void _callFetchConnections() {
    final personUUID = widget.payload.personaUUID;

    switch (widget.payload.type) {
      case CryptoType.ETH:
        context.read<ConnectionsBloc>().add(GetETHConnectionsEvent(personUUID));
        break;
      case CryptoType.XTZ:
        context.read<ConnectionsBloc>().add(GetXTZConnectionsEvent(personUUID));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getBackAppBar(
        context,
        title: widget.payload.address.mask(4),
        onBack: () {
          Navigator.of(context).pop();
        },
      ),
      body: Container(
        margin:
            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _addressSection(),
                    SizedBox(height: 40),
                    _connectionsSection(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _addressSection() {
    var typeText = "";
    switch (widget.payload.type) {
      case CryptoType.ETH:
        typeText = "Ethereum";
        break;
      case CryptoType.XTZ:
        typeText = "Tezos";
        break;
    }

    var address = widget.payload.address;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: appTextTheme.headline1,
        ),
        SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(typeText, style: appTextTheme.headline4),
                TextButton(
                  onPressed: () => Share.share("$typeText address: $address"),
                  child: Text(
                    "Share",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "AtlasGrotesk",
                        fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(alignment: Alignment.centerRight),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    address,
                    style: addressStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _connectionsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Connections",
        style: appTextTheme.headline1,
      ),
      SizedBox(height: 24),
      BlocBuilder<ConnectionsBloc, ConnectionsState>(builder: (context, state) {
        final connectionItems = state.connectionItems;
        if (connectionItems == null) return SizedBox();

        if (connectionItems.isEmpty) {
          return _emptyConnectionsWidget();
        } else {
          return Column(
            children: [
              ...connectionItems
                  .map((connectionItem) => Column(
                        children: [
                          _connectionItemWidget(connectionItem),
                          addDivider(),
                        ],
                      ))
                  .toList(),
            ],
          );
        }
      }),
    ]);
  }

  Widget _emptyConnectionsWidget() {
    return Column(children: [
      TappableForwardRow(
          leftWidget: Row(children: [
            SvgPicture.asset("assets/images/iconQr.svg"),
            SizedBox(width: 17.5),
            Text('Add connection', style: appTextTheme.headline4),
          ]),
          bottomWidget: Text(
              "Connect this address to an external dapp or platform.",
              style: appTextTheme.bodyText1),
          onTap: () {
            late ScannerItem scanItem;

            switch (widget.payload.type) {
              case CryptoType.ETH:
                scanItem = ScannerItem.WALLET_CONNECT;
                break;
              case CryptoType.XTZ:
                scanItem = ScannerItem.BEACON_CONNECT;
                break;
            }

            Navigator.of(context)
                .pushNamed(AppRouter.scanQRPage, arguments: scanItem);
          }),
    ]);
  }

  Widget _connectionItemWidget(ConnectionItem connectionItem) {
    final connection = connectionItem.representative;

    return TappableForwardRow(
        leftWidget: Row(children: [
          UIHelper.buildConnectionAppWidget(connection, 24),
          SizedBox(width: 16),
          Text(connection.appName, style: appTextTheme.headline4),
        ]),
        onTap: () => Navigator.of(context).pushNamed(
            AppRouter.connectionDetailsPage,
            arguments: connectionItem));
  }
}

class PersonaConnectionsPayload {
  final String personaUUID;
  final String address;
  final CryptoType type;

  PersonaConnectionsPayload({
    required this.personaUUID,
    required this.address,
    required this.type,
  });
}
