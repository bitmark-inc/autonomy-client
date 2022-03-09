import 'dart:io';

import 'package:autonomy_flutter/database/cloud_database.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/util/migration/migration_util.dart';
import 'package:bloc/bloc.dart';

part 'router_state.dart';

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  ConfigurationService _configurationService;
  CloudDatabase _cloudDB;

  RouterBloc(this._configurationService, this._cloudDB)
      : super(RouterState(onboardingStep: OnboardingStep.undefined)) {
    on<DefineViewRoutingEvent>((event, emit) async {
      if (state.onboardingStep != OnboardingStep.undefined) return;

      await MigrationUtil(_cloudDB).migrateIfNeeded(Platform.isIOS);

      final personas = await _cloudDB.personaDao.getPersonas();
      final connections = await _cloudDB.connectionDao.getLinkedAccounts();
      if (personas.isEmpty && connections.isEmpty) {
        _configurationService.setDoneOnboarding(false);

        if (_configurationService.isDoneOnboardingOnce()) {
          emit(RouterState(onboardingStep: OnboardingStep.newAccountPage));
        } else {
          emit(RouterState(onboardingStep: OnboardingStep.startScreen));
        }
      } else {
        _configurationService.setDoneOnboarding(true);
        emit(RouterState(onboardingStep: OnboardingStep.dashboard));
      }
    });
  }
}
