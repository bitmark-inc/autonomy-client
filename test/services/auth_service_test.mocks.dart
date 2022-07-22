// Mocks generated by Mockito 5.2.0 from annotations
// in autonomy_flutter/test/services/auth_service_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;
import 'dart:io' as _i9;

import 'package:autonomy_flutter/database/entity/connection.dart' as _i6;
import 'package:autonomy_flutter/database/entity/persona.dart' as _i5;
import 'package:autonomy_flutter/gateway/iap_api.dart' as _i7;
import 'package:autonomy_flutter/model/backup_versions.dart' as _i3;
import 'package:autonomy_flutter/model/jwt.dart' as _i2;
import 'package:autonomy_flutter/model/network.dart' as _i15;
import 'package:autonomy_flutter/service/account_service.dart' as _i10;
import 'package:autonomy_flutter/service/configuration_service.dart' as _i13;
import 'package:autonomy_flutter/service/wallet_connect_dapp_service/wc_connected_session.dart'
    as _i11;
import 'package:autonomy_flutter/util/constants.dart' as _i12;
import 'package:libauk_dart/libauk_dart.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:wallet_connect/wallet_connect.dart' as _i14;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeJWT_0 extends _i1.Fake implements _i2.JWT {}

class _FakeBackupVersions_1 extends _i1.Fake implements _i3.BackupVersions {}

class _FakeOnesignalIdentityHash_2 extends _i1.Fake
    implements _i2.OnesignalIdentityHash {}

class _FakeWalletStorage_3 extends _i1.Fake implements _i4.WalletStorage {}

class _FakePersona_4 extends _i1.Fake implements _i5.Persona {}

class _FakeConnection_5 extends _i1.Fake implements _i6.Connection {}

/// A class which mocks [IAPApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockIAPApi extends _i1.Mock implements _i7.IAPApi {
  MockIAPApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i2.JWT> auth(Map<String, dynamic>? body) => (super.noSuchMethod(
      Invocation.method(#auth, [body]),
      returnValue: Future<_i2.JWT>.value(_FakeJWT_0())) as _i8.Future<_i2.JWT>);
  @override
  _i8.Future<dynamic> uploadProfile(String? requester, String? filename,
          String? appVersion, _i9.File? data) =>
      (super.noSuchMethod(
          Invocation.method(
              #uploadProfile, [requester, filename, appVersion, data]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<_i3.BackupVersions> getProfileVersions(
          String? requester, String? filename) =>
      (super.noSuchMethod(
              Invocation.method(#getProfileVersions, [requester, filename]),
              returnValue:
                  Future<_i3.BackupVersions>.value(_FakeBackupVersions_1()))
          as _i8.Future<_i3.BackupVersions>);
  @override
  _i8.Future<dynamic> getProfileData(
          String? requester, String? filename, String? version) =>
      (super.noSuchMethod(
          Invocation.method(#getProfileData, [requester, filename, version]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> deleteAllProfiles(String? requester) =>
      (super.noSuchMethod(Invocation.method(#deleteAllProfiles, [requester]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> deleteUserData() =>
      (super.noSuchMethod(Invocation.method(#deleteUserData, []),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<_i2.OnesignalIdentityHash> generateIdentityHash(
          Map<String, String>? body) =>
      (super.noSuchMethod(Invocation.method(#generateIdentityHash, [body]),
              returnValue: Future<_i2.OnesignalIdentityHash>.value(
                  _FakeOnesignalIdentityHash_2()))
          as _i8.Future<_i2.OnesignalIdentityHash>);
}

/// A class which mocks [AccountService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAccountService extends _i1.Mock implements _i10.AccountService {
  MockAccountService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<_i4.WalletStorage> getDefaultAccount() => (super.noSuchMethod(
          Invocation.method(#getDefaultAccount, []),
          returnValue: Future<_i4.WalletStorage>.value(_FakeWalletStorage_3()))
      as _i8.Future<_i4.WalletStorage>);
  @override
  _i8.Future<dynamic> androidBackupKeys() =>
      (super.noSuchMethod(Invocation.method(#androidBackupKeys, []),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<bool?> isAndroidEndToEndEncryptionAvailable() =>
      (super.noSuchMethod(
          Invocation.method(#isAndroidEndToEndEncryptionAvailable, []),
          returnValue: Future<bool?>.value()) as _i8.Future<bool?>);
  @override
  _i8.Future<dynamic> androidRestoreKeys() =>
      (super.noSuchMethod(Invocation.method(#androidRestoreKeys, []),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<List<_i5.Persona>> getPersonas() =>
      (super.noSuchMethod(Invocation.method(#getPersonas, []),
              returnValue: Future<List<_i5.Persona>>.value(<_i5.Persona>[]))
          as _i8.Future<List<_i5.Persona>>);
  @override
  _i8.Future<_i5.Persona> createPersona({String? name = r''}) =>
      (super.noSuchMethod(Invocation.method(#createPersona, [], {#name: name}),
              returnValue: Future<_i5.Persona>.value(_FakePersona_4()))
          as _i8.Future<_i5.Persona>);
  @override
  _i8.Future<_i5.Persona> importPersona(String? words) =>
      (super.noSuchMethod(Invocation.method(#importPersona, [words]),
              returnValue: Future<_i5.Persona>.value(_FakePersona_4()))
          as _i8.Future<_i5.Persona>);
  @override
  _i8.Future<_i5.Persona> namePersona(_i5.Persona? persona, String? name) =>
      (super.noSuchMethod(Invocation.method(#namePersona, [persona, name]),
              returnValue: Future<_i5.Persona>.value(_FakePersona_4()))
          as _i8.Future<_i5.Persona>);
  @override
  _i8.Future<_i6.Connection> nameLinkedAccount(
          _i6.Connection? connection, String? name) =>
      (super.noSuchMethod(
              Invocation.method(#nameLinkedAccount, [connection, name]),
              returnValue: Future<_i6.Connection>.value(_FakeConnection_5()))
          as _i8.Future<_i6.Connection>);
  @override
  _i8.Future<_i6.Connection> linkETHWallet(_i11.WCConnectedSession? session) =>
      (super.noSuchMethod(Invocation.method(#linkETHWallet, [session]),
              returnValue: Future<_i6.Connection>.value(_FakeConnection_5()))
          as _i8.Future<_i6.Connection>);
  @override
  _i8.Future<_i6.Connection> linkETHBrowserWallet(
          String? address, _i12.WalletApp? walletApp) =>
      (super.noSuchMethod(
              Invocation.method(#linkETHBrowserWallet, [address, walletApp]),
              returnValue: Future<_i6.Connection>.value(_FakeConnection_5()))
          as _i8.Future<_i6.Connection>);
  @override
  _i8.Future<dynamic> linkManuallyAddress(String? address) =>
      (super.noSuchMethod(Invocation.method(#linkManuallyAddress, [address]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<bool> isLinkedIndexerTokenID(String? indexerTokenID) =>
      (super.noSuchMethod(
          Invocation.method(#isLinkedIndexerTokenID, [indexerTokenID]),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  _i8.Future<dynamic> deletePersona(_i5.Persona? persona) =>
      (super.noSuchMethod(Invocation.method(#deletePersona, [persona]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> deleteLinkedAccount(_i6.Connection? connection) =>
      (super.noSuchMethod(Invocation.method(#deleteLinkedAccount, [connection]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> linkIndexerTokenID(String? indexerTokenID) => (super
      .noSuchMethod(Invocation.method(#linkIndexerTokenID, [indexerTokenID]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> setHidePersonaInGallery(
          String? personaUUID, bool? isEnabled) =>
      (super.noSuchMethod(
          Invocation.method(#setHidePersonaInGallery, [personaUUID, isEnabled]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<dynamic> setHideLinkedAccountInGallery(
          String? address, bool? isEnabled) =>
      (super.noSuchMethod(
          Invocation.method(
              #setHideLinkedAccountInGallery, [address, isEnabled]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  bool isPersonaHiddenInGallery(String? personaUUID) => (super.noSuchMethod(
      Invocation.method(#isPersonaHiddenInGallery, [personaUUID]),
      returnValue: false) as bool);
  @override
  bool isLinkedAccountHiddenInGallery(String? address) => (super.noSuchMethod(
      Invocation.method(#isLinkedAccountHiddenInGallery, [address]),
      returnValue: false) as bool);
  @override
  _i8.Future<List<String>> getShowedAddresses() =>
      (super.noSuchMethod(Invocation.method(#getShowedAddresses, []),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i8.Future<List<String>>);
  @override
  _i8.Future<String> authorizeToViewer() =>
      (super.noSuchMethod(Invocation.method(#authorizeToViewer, []),
          returnValue: Future<String>.value('')) as _i8.Future<String>);
}

/// A class which mocks [ConfigurationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockConfigurationService extends _i1.Mock
    implements _i13.ConfigurationService {
  MockConfigurationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<void> setIAPReceipt(String? value) =>
      (super.noSuchMethod(Invocation.method(#setIAPReceipt, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> setIAPJWT(_i2.JWT? value) =>
      (super.noSuchMethod(Invocation.method(#setIAPJWT, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> setWCSessions(List<_i14.WCSessionStore>? value) =>
      (super.noSuchMethod(Invocation.method(#setWCSessions, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  List<_i14.WCSessionStore> getWCSessions() =>
      (super.noSuchMethod(Invocation.method(#getWCSessions, []),
          returnValue: <_i14.WCSessionStore>[]) as List<_i14.WCSessionStore>);
  @override
  _i8.Future<void> setNetwork(_i15.Network? value) =>
      (super.noSuchMethod(Invocation.method(#setNetwork, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i15.Network getNetwork() =>
      (super.noSuchMethod(Invocation.method(#getNetwork, []),
          returnValue: _i15.Network.TESTNET) as _i15.Network);
  @override
  _i8.Future<void> setDevicePasscodeEnabled(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setDevicePasscodeEnabled, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  bool isDevicePasscodeEnabled() =>
      (super.noSuchMethod(Invocation.method(#isDevicePasscodeEnabled, []),
          returnValue: false) as bool);
  @override
  _i8.Future<void> setNotificationEnabled(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setNotificationEnabled, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> setAnalyticEnabled(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setAnalyticEnabled, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  bool isAnalyticsEnabled() =>
      (super.noSuchMethod(Invocation.method(#isAnalyticsEnabled, []),
          returnValue: false) as bool);
  @override
  _i8.Future<void> setDoneOnboarding(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setDoneOnboarding, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  bool isDoneOnboarding() =>
      (super.noSuchMethod(Invocation.method(#isDoneOnboarding, []),
          returnValue: false) as bool);
  @override
  _i8.Future<void> setDoneOnboardingOnce(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setDoneOnboardingOnce, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  bool isDoneOnboardingOnce() =>
      (super.noSuchMethod(Invocation.method(#isDoneOnboardingOnce, []),
          returnValue: false) as bool);
  @override
  _i8.Future<void> setFullscreenIntroEnable(bool? value) =>
      (super.noSuchMethod(Invocation.method(#setFullscreenIntroEnable, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  bool isFullscreenIntroEnabled() =>
      (super.noSuchMethod(Invocation.method(#isFullscreenIntroEnabled, []),
          returnValue: false) as bool);
  @override
  _i8.Future<void> setHidePersonaInGallery(
          List<String>? personaUUIDs, bool? isEnabled,
          {bool? override = false}) =>
      (super.noSuchMethod(
          Invocation.method(#setHidePersonaInGallery, [personaUUIDs, isEnabled],
              {#override: override}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  List<String> getPersonaUUIDsHiddenInGallery() => (super.noSuchMethod(
      Invocation.method(#getPersonaUUIDsHiddenInGallery, []),
      returnValue: <String>[]) as List<String>);
  @override
  bool isPersonaHiddenInGallery(String? value) =>
      (super.noSuchMethod(Invocation.method(#isPersonaHiddenInGallery, [value]),
          returnValue: false) as bool);
  @override
  _i8.Future<void> setHideLinkedAccountInGallery(
          List<String>? address, bool? isEnabled, {bool? override = false}) =>
      (super.noSuchMethod(
          Invocation.method(#setHideLinkedAccountInGallery,
              [address, isEnabled], {#override: override}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  List<String> getLinkedAccountsHiddenInGallery() => (super.noSuchMethod(
      Invocation.method(#getLinkedAccountsHiddenInGallery, []),
      returnValue: <String>[]) as List<String>);
  @override
  bool isLinkedAccountHiddenInGallery(String? value) => (super.noSuchMethod(
      Invocation.method(#isLinkedAccountHiddenInGallery, [value]),
      returnValue: false) as bool);
  @override
  List<String> getTempStorageHiddenTokenIDs({_i15.Network? network}) =>
      (super.noSuchMethod(
          Invocation.method(
              #getTempStorageHiddenTokenIDs, [], {#network: network}),
          returnValue: <String>[]) as List<String>);
  @override
  _i8.Future<dynamic> updateTempStorageHiddenTokenIDs(
          List<String>? tokenIDs, bool? isAdd,
          {_i15.Network? network, bool? override = false}) =>
      (super.noSuchMethod(
          Invocation.method(#updateTempStorageHiddenTokenIDs, [tokenIDs, isAdd],
              {#network: network, #override: override}),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  bool matchFeralFileSourceInNetwork(String? source) => (super.noSuchMethod(
      Invocation.method(#matchFeralFileSourceInNetwork, [source]),
      returnValue: false) as bool);
  @override
  _i8.Future<void> setWCDappSession(String? value) =>
      (super.noSuchMethod(Invocation.method(#setWCDappSession, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> setWCDappAccounts(List<String>? value) =>
      (super.noSuchMethod(Invocation.method(#setWCDappAccounts, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<bool> setLatestRefreshTokens(DateTime? value) =>
      (super.noSuchMethod(Invocation.method(#setLatestRefreshTokens, [value]),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  _i8.Future<void> setReadReleaseNotesInVersion(String? version) => (super
      .noSuchMethod(Invocation.method(#setReadReleaseNotesInVersion, [version]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> setPreviousBuildNumber(String? value) =>
      (super.noSuchMethod(Invocation.method(#setPreviousBuildNumber, [value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  List<String> getFinishedSurveys() =>
      (super.noSuchMethod(Invocation.method(#getFinishedSurveys, []),
          returnValue: <String>[]) as List<String>);
  @override
  _i8.Future<void> setFinishedSurvey(List<String>? surveyNames) =>
      (super.noSuchMethod(Invocation.method(#setFinishedSurvey, [surveyNames]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  bool isDemoArtworksMode() =>
      (super.noSuchMethod(Invocation.method(#isDemoArtworksMode, []),
          returnValue: false) as bool);
  @override
  _i8.Future<bool> toggleDemoArtworksMode() =>
      (super.noSuchMethod(Invocation.method(#toggleDemoArtworksMode, []),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  bool showTokenDebugInfo() =>
      (super.noSuchMethod(Invocation.method(#showTokenDebugInfo, []),
          returnValue: false) as bool);
  @override
  _i8.Future<dynamic> setShowTokenDebugInfo(bool? show) =>
      (super.noSuchMethod(Invocation.method(#setShowTokenDebugInfo, [show]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<void> reload() =>
      (super.noSuchMethod(Invocation.method(#reload, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> removeAll() =>
      (super.noSuchMethod(Invocation.method(#removeAll, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
}
