import 'dart:developer';
import 'dart:io';

import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/main.dart';
import 'package:autonomy_flutter/service/configuration_service.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/main.dart' as app;
import 'setting_page.dart';

final Finder autonomy_header = find.text('AUTONOMY');
final Finder startButton = find.text("START");
final Finder continueButton = find.text("CONTINUE");
final Finder notNowButton = find.text("NOT NOW");
final Finder createAccountButton = find.text("No");
final Finder continueButton2 = find.text("CONTINUE");
final Finder skipButton = find.text("SKIP");
final Finder continueButton3 = find.text("CONTINUE");
final Finder restoreButton = find.text("RESTORE");
final Finder NFTCollections = find.text("Collection");

Future<void> onboardingSteps(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle(Duration(seconds: 5));
  await tester.pumpWidget(AutonomyApp());
  await tester.pumpAndSettle(Duration(seconds: 3));

  expect(autonomy_header, findsOneWidget);

  await injector<ConfigurationService>().setFinishedSurvey([Survey.onboarding]);

  if (startButton.evaluate().isNotEmpty) {
    // Fresh start
    await tester.tap(startButton);

    await tester.pumpAndSettle();

    await tester.tap(continueButton);

    await tester.pumpAndSettle();

    if (notNowButton.evaluate().isNotEmpty) {
      await tester.tap(notNowButton);
      await tester.pumpAndSettle();
    }

    await tester.tap(createAccountButton);

    await tester.pumpAndSettle(Duration(seconds: 4));
    await tester.pumpAndSettle(Duration(seconds: 1));

    await tester.tap(continueButton2);

    await tester.pumpAndSettle();

    await tester.tap(skipButton);

    await tester.pumpAndSettle();

    await tester.tap(continueButton3);

    await tester.pumpAndSettle(Duration(seconds: 5));
    sleep(Duration(seconds: 3));

    expect(NFTCollections, findsOneWidget);
  } else {
    //Restore

    await tester.tap(restoreButton);

    await tester.pumpAndSettle(Duration(seconds: 3));
    //wait for Not now notification appear to close
    sleep(Duration(seconds: 5));

// find.byElementPredicate((element) => false)

    if (notNowButton.evaluate().isNotEmpty) {
      await tester.tap(notNowButton);
      await tester.pumpAndSettle();
      // sleep(Duration(seconds: 5));
    }
  }

  // debugPrint('xong onBoarding');
  // log('xong onBoarding');
  // log('xong onBoarding');
  // log('xong onBoarding');
  // log('xong onBoarding');
  // log('xong onBoarding');
  // log('xong onBoarding');
}
