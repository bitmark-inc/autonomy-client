//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:autonomy_flutter/common/environment.dart';
import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/database/entity/connection.dart';
import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/service/aws_service.dart';
import 'package:autonomy_flutter/service/navigation_service.dart';
import 'package:autonomy_flutter/util/au_cached_manager.dart';
import 'package:autonomy_flutter/util/device.dart';
import 'package:autonomy_flutter/util/error_handler.dart';
import 'package:autonomy_flutter/util/log.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  SentryFlutter.init((options) {
    options.dsn = Environment.sentryDSN;
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    options.attachStacktrace = true;
  });

  runZonedGuarded(() async {
    FlutterNativeSplash.preserve(
        widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await FlutterDownloader.initialize();
    await Hive.initFlutter();
    FlutterDownloader.registerCallback(downloadCallback);
    AUCacheManager().setup();

    OneSignal.shared.setLogLevel(OSLogLevel.error, OSLogLevel.none);
    OneSignal.shared.setAppId(Environment.onesignalAppID);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      showErrorDialogFromException(details.exception,
          stackTrace: details.stack, library: details.library);
    };
    await _setupApp();
  }, (Object error, StackTrace stackTrace) async {
    /// Check error is Database issue
    if (error.toString().contains("DatabaseException")) {
      Sentry.captureException(error);

      log.info('[DatabaseException] Remove local database and resume app');

      await _deleteLocalDatabase();

      /// Need to setup app again
      Future.delayed(const Duration(milliseconds: 200), () async {
        await _setupApp();
      });
    } else {
      showErrorDialogFromException(error, stackTrace: stackTrace);
    }
  });
}

_setupApp() async {
  await setup();
  await injector<AWSService>().initServices();

  BlocOverrides.runZoned(
    () => runApp(OverlaySupport.global(child: AutonomyApp())),
    blocObserver: AppBlocObserver(),
  );

  Sentry.configureScope((scope) async {
    final deviceID = await getDeviceID();
    if (deviceID != null) {
      scope.user = SentryUser(id: deviceID);
    }
  });
  FlutterNativeSplash.remove();
}

Future<void> _deleteLocalDatabase() async {
  String appDatabaseMainnet =
      await sqfliteDatabaseFactory.getDatabasePath("app_database_mainnet.db");
  String appDatabaseTestnet =
      await sqfliteDatabaseFactory.getDatabasePath("app_database_testnet.db");
  await sqfliteDatabaseFactory.deleteDatabase(appDatabaseMainnet);
  await sqfliteDatabaseFactory.deleteDatabase(appDatabaseTestnet);
}

class AutonomyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Autonomy',
      theme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.grey,
        barBackgroundColor: Color(0xFF6D6B6B),
        // errorColor: Color(0xFFA1200A),
        textTheme: CupertinoTextThemeData(
          primaryColor: Colors.grey,
        ),
      ),
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      navigatorKey: injector<NavigationService>().navigatorKey,
      navigatorObservers: [
        routeObserver,
        SentryNavigatorObserver(),
        HeroController()
      ],
      initialRoute: AppRouter.onboardingPage,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.info(transition);
  }
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

var memoryValues = MemoryValues();

class MemoryValues {
  String? scopedPersona;
  String? viewingSupportThreadIssueID;
  DateTime? inForegroundAt;
  bool inGalleryView;
  List<Connection>? linkedFFConnections = [];

  MemoryValues({
    this.scopedPersona,
    this.viewingSupportThreadIssueID,
    this.inForegroundAt,
    this.inGalleryView = true,
    this.linkedFFConnections,
  });

  MemoryValues copyWith({
    String? scopedPersona,
  }) {
    return MemoryValues(scopedPersona: scopedPersona ?? this.scopedPersona);
  }
}

@pragma('vm:entry-point')
void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final SendPort? send =
      IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

void imageError(Object exception, StackTrace? stackTrace) {}
