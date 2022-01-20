import 'package:autonomy_flutter/database/entity/asset_token.dart';
import 'package:floor/floor.dart';

@dao
abstract class AssetTokenDao {
  @Query('SELECT * FROM AssetToken')
  Future<List<AssetToken>> findAllAssetTokens();

  @Query('SELECT * FROM AssetToken WHERE id = :id')
  Future<AssetToken?> findAssetTokenById(String id);

  @insert
  Future<void> insertAsset(AssetToken asset);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAssets(List<AssetToken> assets);

  @delete
  Future<void> deleteAsset(AssetToken asset);
}