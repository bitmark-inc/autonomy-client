import 'dart:convert';

import 'package:autonomy_flutter/model/connection_supports.dart';
import 'package:autonomy_flutter/model/ff_account.dart';
import 'package:autonomy_flutter/model/tezos_connection.dart';
import 'package:autonomy_flutter/service/wallet_connect_dapp_service/wc_connected_session.dart';
import 'package:floor/floor.dart';

enum ConnectionType {
  walletConnect, // Autonomy connect to Wallet
  dappConnect, // Autonomy connect to Dapp
  beaconP2PPeer,
  walletBeacon,
  feralFileToken,
  feralFileWeb3,
}

extension RawValue on ConnectionType {
  String get rawValue => this.toString().split('.').last;
}

@entity
class Connection {
  @primaryKey
  String key;
  String name;
  String data; // jsonData
  String connectionType;
  String accountNumber;
  DateTime createdAt;

  /* Data
  enum ConnectionType {
    walletConnect, => WCConnectedSession
    dappConnect, => WalletConnectConnection
    beaconP2PPeer, => BeaconConnectConnection
    walletBeacon, => TezosConnection
    feralFileToken, => FeralFileConnection
    feralFileWeb3, => FeralFileWeb3Connection
  }
  */

  Connection({
    required this.key,
    required this.name,
    required this.data,
    required this.connectionType,
    required this.accountNumber,
    required this.createdAt,
  });

  factory Connection.fromFFToken(
      String token, String source, FFAccount ffAccount) {
    final ffConnection =
        FeralFileConnection(source: source, ffAccount: ffAccount);

    return Connection(
      key: token,
      name: ffAccount.alias,
      data: json.encode(ffConnection),
      connectionType: ConnectionType.feralFileToken.rawValue,
      accountNumber: ffAccount.accountNumber,
      createdAt: DateTime.now(),
    );
  }

  factory Connection.fromETHWallet(WCConnectedSession connectedSession) {
    return Connection(
      key: connectedSession.accounts.first,
      name: "",
      data: json.encode(connectedSession),
      connectionType: ConnectionType.walletConnect.rawValue,
      accountNumber: connectedSession.accounts.first,
      createdAt: DateTime.now(),
    );
  }

  factory Connection.fromFFWeb3(
      String topic, String source, String personaAddress, FFAccount ffAccount) {
    final ffWeb3Connection = FeralFileWeb3Connection(
        personaAddress: personaAddress, source: source, ffAccount: ffAccount);

    return Connection(
      key: topic,
      name: ffAccount.alias,
      data: json.encode(ffWeb3Connection),
      connectionType: ConnectionType.feralFileWeb3.rawValue,
      accountNumber: ffAccount.accountNumber,
      createdAt: DateTime.now(),
    );
  }

  Connection copyFFWith(FFAccount ffAccount) {
    final ffConnection = this.ffConnection;
    final ffWeb3Connection = this.ffWeb3Connection;

    if (ffConnection != null) {
      final newFFConnection = FeralFileConnection(
          source: ffConnection.source, ffAccount: ffAccount);

      return this
          .copyWith(name: ffAccount.alias, data: json.encode(newFFConnection));
    } else if (ffWeb3Connection != null) {
      final newFFWeb3Connection = FeralFileWeb3Connection(
          personaAddress: ffWeb3Connection.personaAddress,
          source: ffWeb3Connection.source,
          ffAccount: ffAccount);

      return this.copyWith(
          name: ffAccount.alias, data: json.encode(newFFWeb3Connection));
    } else {
      throw Exception("incorrectDataFlow");
    }
  }

  Connection copyWith({
    String? key,
    String? name,
    String? data,
    String? connectionType,
    String? accountNumber,
    DateTime? createdAt,
  }) {
    return Connection(
      key: key ?? this.key,
      name: name ?? this.name,
      data: data ?? this.data,
      connectionType: connectionType ?? this.connectionType,
      accountNumber: accountNumber ?? this.accountNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  FeralFileConnection? get ffConnection {
    if (connectionType != ConnectionType.feralFileToken.rawValue) return null;

    final jsonData = json.decode(this.data);
    return FeralFileConnection.fromJson(jsonData);
  }

  FeralFileWeb3Connection? get ffWeb3Connection {
    if (connectionType != ConnectionType.feralFileWeb3.rawValue) return null;

    final jsonData = json.decode(this.data);
    return FeralFileWeb3Connection.fromJson(jsonData);
  }

  WalletConnectConnection? get wcConnection {
    if (connectionType != ConnectionType.dappConnect.rawValue) return null;

    final jsonData = json.decode(this.data);
    return WalletConnectConnection.fromJson(jsonData);
  }

  TezosConnection? get walletBeaconConnection {
    if (connectionType != ConnectionType.walletBeacon.rawValue) return null;

    final jsonData = json.decode(this.data);
    return TezosConnection.fromJson(jsonData);
  }

  BeaconConnectConnection? get beaconConnectConnection {
    if (connectionType != ConnectionType.beaconP2PPeer.rawValue) return null;

    final jsonData = json.decode(this.data);
    return BeaconConnectConnection.fromJson(jsonData);
  }

  WCConnectedSession? get wcConnectedSession {
    if (connectionType != ConnectionType.walletConnect.rawValue) return null;

    final jsonData = json.decode(this.data);
    return WCConnectedSession.fromJson(jsonData);
  }
}