import 'package:autonomy_flutter/model/account.dart';
import 'package:autonomy_flutter/model/asset_price.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'feralfile_api.g.dart';

@RestApi(baseUrl: "https://feralfile1.dev.bitmark.com/")
abstract class FeralFileApi {
  factory FeralFileApi(Dio dio, {String baseUrl}) = _FeralFileApi;

  @GET("/api/accounts/me")
  Future<Map<String, Account>> getAccount(
      @Header("Authorization") String bearerToken);

  @POST("/api/asset-prices")
  Future<Map<String, List<AssetPrice>>> getAssetPrice(
      @Header("Authorization") String bearerToken,
      @Body() Map<String, List<String>> body);
}
