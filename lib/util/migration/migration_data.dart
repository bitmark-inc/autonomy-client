import 'package:json_annotation/json_annotation.dart';
import 'package:autonomy_flutter/model/ff_account.dart';
import 'package:autonomy_flutter/model/tezos_connection.dart';
import 'package:autonomy_flutter/service/wallet_connect_dapp_service/wc_connected_session.dart';

part 'migration_data.g.dart';

@JsonSerializable()
class MigrationData {
  List<MigrationPersona> personas;
  List<MigrationFFTokenConnection> ffTokenConnections;
  List<MigrationFFWeb3Connection> ffWeb3Connections;
  List<MigrationWalletBeaconConnection> walletBeaconConnections;
  List<MigrationWalletConnectConnection> walletConnectConnections;

  MigrationData({
    required this.personas,
    required this.ffTokenConnections,
    required this.ffWeb3Connections,
    required this.walletBeaconConnections,
    required this.walletConnectConnections,
  });

  factory MigrationData.fromJson(Map<String, dynamic> json) =>
      _$MigrationDataFromJson(json);

  Map<String, dynamic> toJson() => _$MigrationDataToJson(this);
}

@JsonSerializable()
class MigrationPersona {
  String uuid;
  DateTime createdAt;

  MigrationPersona({
    required this.uuid,
    required this.createdAt,
  });

  factory MigrationPersona.fromJson(Map<String, dynamic> json) =>
      _$MigrationPersonaFromJson(json);

  Map<String, dynamic> toJson() => _$MigrationPersonaToJson(this);
}

@JsonSerializable()
class MigrationFFTokenConnection {
  String token;
  String source;
  FFAccount ffAccount;
  DateTime createdAt;

  MigrationFFTokenConnection({
    required this.token,
    required this.source,
    required this.ffAccount,
    required this.createdAt,
  });

  factory MigrationFFTokenConnection.fromJson(Map<String, dynamic> json) =>
      _$MigrationFFTokenConnectionFromJson(json);

  Map<String, dynamic> toJson() => _$MigrationFFTokenConnectionToJson(this);
}

@JsonSerializable()
class MigrationFFWeb3Connection {
  String topic;
  String address;
  String source;
  FFAccount ffAccount;
  DateTime createdAt;

  MigrationFFWeb3Connection({
    required this.topic,
    required this.address,
    required this.source,
    required this.ffAccount,
    required this.createdAt,
  });

  factory MigrationFFWeb3Connection.fromJson(Map<String, dynamic> json) =>
      _$MigrationFFWeb3ConnectionFromJson(json);

  Map<String, dynamic> toJson() => _$MigrationFFWeb3ConnectionToJson(this);
}

@JsonSerializable()
class MigrationWalletBeaconConnection {
  TezosConnection tezosWalletConnection;
  String name;
  DateTime createdAt;

  MigrationWalletBeaconConnection({
    required this.tezosWalletConnection,
    required this.name,
    required this.createdAt,
  });

  factory MigrationWalletBeaconConnection.fromJson(Map<String, dynamic> json) =>
      _$MigrationWalletBeaconConnectionFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MigrationWalletBeaconConnectionToJson(this);
}

@JsonSerializable()
class MigrationWalletConnectConnection {
  WCConnectedSession wcConnectedSession;
  String name;
  DateTime createdAt;

  MigrationWalletConnectConnection({
    required this.wcConnectedSession,
    required this.name,
    required this.createdAt,
  });

  factory MigrationWalletConnectConnection.fromJson(
          Map<String, dynamic> json) =>
      _$MigrationWalletConnectConnectionFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MigrationWalletConnectConnectionToJson(this);
}
