import 'dart:io';
import 'dart:typed_data';

import 'package:autonomy_flutter/model/backup_versions.dart';
import 'package:autonomy_flutter/model/jwt.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'iap_api.g.dart';

@RestApi(baseUrl: "https://autonomy-auth.test.bitmark.com")
abstract class IAPApi {
  factory IAPApi(Dio dio, {String baseUrl}) = _IAPApi;

  @POST("/auth")
  Future<JWT> verifyIAP(@Body() Map<String, String> body);

  @MultiPart()
  @POST("/apis/v1/premium/profile-data")
  Future<dynamic> uploadProfile(
    @Header("requester") String requester,
    @Part(name: "filename") String filename,
    @Part(name: "appVersion") String appVersion,
    @Part(name: "data") File data,
  );

  @GET("/apis/v1/premium/profile-data/versions")
  Future<BackupVersions> getProfileVersions(
    @Header("requester") String requester,
    @Query("filename") String filename,
  );
}