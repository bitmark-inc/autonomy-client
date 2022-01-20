// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AssetTokenDao? _assetDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AssetToken` (`artistName` TEXT, `artistURL` TEXT, `assetData` TEXT, `assetID` TEXT, `assetURL` TEXT, `basePrice` REAL, `baseCurrency` TEXT, `blockchain` TEXT NOT NULL, `contractType` TEXT, `desc` TEXT, `edition` INTEGER NOT NULL, `id` TEXT NOT NULL, `maxEdition` INTEGER, `medium` TEXT, `mintedAt` INTEGER, `previewURL` TEXT, `source` TEXT, `sourceURL` TEXT, `thumbnailURL` TEXT, `galleryThumbnailURL` TEXT, `title` TEXT NOT NULL, `ownerAddress` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AssetTokenDao get assetDao {
    return _assetDaoInstance ??= _$AssetTokenDao(database, changeListener);
  }
}

class _$AssetTokenDao extends AssetTokenDao {
  _$AssetTokenDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _assetTokenInsertionAdapter = InsertionAdapter(
            database,
            'AssetToken',
            (AssetToken item) => <String, Object?>{
                  'artistName': item.artistName,
                  'artistURL': item.artistURL,
                  'assetData': item.assetData,
                  'assetID': item.assetID,
                  'assetURL': item.assetURL,
                  'basePrice': item.basePrice,
                  'baseCurrency': item.baseCurrency,
                  'blockchain': item.blockchain,
                  'contractType': item.contractType,
                  'desc': item.desc,
                  'edition': item.edition,
                  'id': item.id,
                  'maxEdition': item.maxEdition,
                  'medium': item.medium,
                  'mintedAt': item.mintedAt,
                  'previewURL': item.previewURL,
                  'source': item.source,
                  'sourceURL': item.sourceURL,
                  'thumbnailURL': item.thumbnailURL,
                  'galleryThumbnailURL': item.galleryThumbnailURL,
                  'title': item.title,
                  'ownerAddress': item.ownerAddress
                }),
        _assetTokenDeletionAdapter = DeletionAdapter(
            database,
            'AssetToken',
            ['id'],
            (AssetToken item) => <String, Object?>{
                  'artistName': item.artistName,
                  'artistURL': item.artistURL,
                  'assetData': item.assetData,
                  'assetID': item.assetID,
                  'assetURL': item.assetURL,
                  'basePrice': item.basePrice,
                  'baseCurrency': item.baseCurrency,
                  'blockchain': item.blockchain,
                  'contractType': item.contractType,
                  'desc': item.desc,
                  'edition': item.edition,
                  'id': item.id,
                  'maxEdition': item.maxEdition,
                  'medium': item.medium,
                  'mintedAt': item.mintedAt,
                  'previewURL': item.previewURL,
                  'source': item.source,
                  'sourceURL': item.sourceURL,
                  'thumbnailURL': item.thumbnailURL,
                  'galleryThumbnailURL': item.galleryThumbnailURL,
                  'title': item.title,
                  'ownerAddress': item.ownerAddress
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AssetToken> _assetTokenInsertionAdapter;

  final DeletionAdapter<AssetToken> _assetTokenDeletionAdapter;

  @override
  Future<List<AssetToken>> findAllAssetTokens() async {
    return _queryAdapter.queryList('SELECT * FROM AssetToken',
        mapper: (Map<String, Object?> row) => AssetToken(
            artistName: row['artistName'] as String?,
            artistURL: row['artistURL'] as String?,
            assetData: row['assetData'] as String?,
            assetID: row['assetID'] as String?,
            assetURL: row['assetURL'] as String?,
            basePrice: row['basePrice'] as double?,
            baseCurrency: row['baseCurrency'] as String?,
            blockchain: row['blockchain'] as String,
            contractType: row['contractType'] as String?,
            desc: row['desc'] as String?,
            edition: row['edition'] as int,
            id: row['id'] as String,
            maxEdition: row['maxEdition'] as int?,
            medium: row['medium'] as String?,
            mintedAt: row['mintedAt'] as int?,
            previewURL: row['previewURL'] as String?,
            source: row['source'] as String?,
            thumbnailURL: row['thumbnailURL'] as String?,
            galleryThumbnailURL: row['galleryThumbnailURL'] as String?,
            title: row['title'] as String,
            ownerAddress: row['ownerAddress'] as String?));
  }

  @override
  Future<AssetToken?> findAssetTokenById(String id) async {
    return _queryAdapter.query('SELECT * FROM AssetToken WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AssetToken(
            artistName: row['artistName'] as String?,
            artistURL: row['artistURL'] as String?,
            assetData: row['assetData'] as String?,
            assetID: row['assetID'] as String?,
            assetURL: row['assetURL'] as String?,
            basePrice: row['basePrice'] as double?,
            baseCurrency: row['baseCurrency'] as String?,
            blockchain: row['blockchain'] as String,
            contractType: row['contractType'] as String?,
            desc: row['desc'] as String?,
            edition: row['edition'] as int,
            id: row['id'] as String,
            maxEdition: row['maxEdition'] as int?,
            medium: row['medium'] as String?,
            mintedAt: row['mintedAt'] as int?,
            previewURL: row['previewURL'] as String?,
            source: row['source'] as String?,
            thumbnailURL: row['thumbnailURL'] as String?,
            galleryThumbnailURL: row['galleryThumbnailURL'] as String?,
            title: row['title'] as String,
            ownerAddress: row['ownerAddress'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> insertAsset(AssetToken asset) async {
    await _assetTokenInsertionAdapter.insert(asset, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAssets(List<AssetToken> assets) async {
    await _assetTokenInsertionAdapter.insertList(
        assets, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteAsset(AssetToken asset) async {
    await _assetTokenDeletionAdapter.delete(asset);
  }
}