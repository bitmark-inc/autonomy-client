import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/util/device.dart';
import 'package:autonomy_flutter/util/log.dart';
import 'package:aws_firehose_api/firehose-2015-08-04.dart';
import 'package:aws_cognito_identity_api/cognito-identity-2014-06-30.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AWSService {
  static const region = 'us-east-1';
  static const deliveryStream = 'autonomy-analytic-data-stream';
  final _cognitoService = CognitoIdentity(region: region);
  ConfigurationService _configurationService;
  PackageInfo? _packageInfo;
  Firehose? _firehoseService;

  AWSService(this._configurationService);

  Future<void> initServices() async {
    // get an identity id from pool
    final openIdTokenResponse = await _cognitoService.getId(
        identityPoolId: 'us-east-1:f247d9ac-788b-4d80-9e86-49a41643de5b');

    if (openIdTokenResponse.identityId != null) {
      // get a credential from the identity with anonymous session
      final identityCredentialsResponse =
          await _cognitoService.getCredentialsForIdentity(
              identityId: openIdTokenResponse.identityId!);

      final identityCredential = identityCredentialsResponse.credentials;
      if (identityCredential != null) {
        // cast it into aws credential
        final awsClientCredentials = AwsClientCredentials(
            accessKey: identityCredential.accessKeyId!,
            secretKey: identityCredential.secretKey!,
            sessionToken: identityCredential.sessionToken,
            expiration: identityCredential.expiration);

        // init the firehose service with the provided credential
        _firehoseService =
            Firehose(region: region, credentials: awsClientCredentials);
      }

      _packageInfo = await PackageInfo.fromPlatform();
    }
  }

  Future<void> _recordFirehoseEvent(Map<String, dynamic> event) async {
    if (_firehoseService == null) {
      return;
    }

    final jsonString = "${jsonEncode(event)}\n";
    List<int> list = jsonString.codeUnits;
    Uint8List data = Uint8List.fromList(list);
    final record = Record(data: data);

    try {
      await _firehoseService?.putRecord(
          deliveryStreamName: deliveryStream, record: record);
    } catch (error) {
      log.warning(error.toString());
    }
  }

  Future<void> storeEventWithDeviceData(String name,
      {Map<String, dynamic> data = const {}}) async {
    if (_configurationService.isAnalyticsEnabled() == false) {
      return;
    }

    var additionalData = new Map<String, dynamic>.from(data);

    additionalData["name"] = name;
    additionalData["device_id"] = await getDeviceID() ?? "unknown";
    additionalData["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    additionalData["platform"] = Platform.operatingSystem;
    additionalData["version"] = _packageInfo?.version ?? "unknown";

    await _recordFirehoseEvent(additionalData);
  }
}