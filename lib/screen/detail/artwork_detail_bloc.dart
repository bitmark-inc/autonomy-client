import 'package:autonomy_flutter/database/dao/asset_token_dao.dart';
import 'package:autonomy_flutter/screen/detail/artwork_detail_state.dart';
import 'package:autonomy_flutter/service/feralfile_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtworkDetailBloc extends Bloc<ArtworkDetailEvent, ArtworkDetailState> {
  FeralFileService _feralFileService;
  AssetTokenDao _assetTokenDao;

  ArtworkDetailBloc(this._feralFileService, this._assetTokenDao)
      : super(ArtworkDetailState(provenances: [])) {
    on<ArtworkDetailGetInfoEvent>((event, emit) async {
      final asset = await _assetTokenDao.findAssetTokenById(event.id);

      emit(ArtworkDetailState(asset: asset, provenances: []));

      final provenances = await _feralFileService.getAssetProvenance(event.id);
      final assetPrices = await _feralFileService.getAssetPrices([event.id]);

      emit(ArtworkDetailState(asset: asset, provenances: provenances, assetPrice: assetPrices.first));
    });
  }
}
