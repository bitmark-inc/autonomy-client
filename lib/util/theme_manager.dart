//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/util/style.dart';
import 'package:flutter/material.dart';

enum AppTheme {
  mainTheme,
  sheetTheme,
  markdownTheme,
  markdownThemeBlack,
  anyProblemNFTTheme,
  anyProblemNFTDarkTheme,
}

class AuThemeManager {
  static ThemeData get(AppTheme theme) {
    switch (theme) {
      case AppTheme.mainTheme:
        return mainTheme;
      case AppTheme.markdownTheme:
        return markdownTheme;
      case AppTheme.markdownThemeBlack:
        return markdownThemeBlack;
      case AppTheme.anyProblemNFTTheme:
        return anyProblemNFTTheme;
      case AppTheme.anyProblemNFTDarkTheme:
        return anyProblemNFTDarkTheme;
      default:
        return sheetTheme;
    }
  }

  static final ThemeData mainTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.grey,
    secondaryHeaderColor: Color(0xFF6D6B6B),
    errorColor: Color(0xFFA1200A),
    textTheme: appTextTheme,
  );

  static final ThemeData sheetTheme = ThemeData(
    backgroundColor: Colors.black,
    primaryColor: Colors.white,
    disabledColor: Color(0xFF999999),
    textTheme: ThemeData.light().textTheme.copyWith(
          headline1: appTextTheme.headline1?.copyWith(color: Colors.white),
          headline2: appTextTheme.headline2?.copyWith(color: Colors.white),
          headline3: appTextTheme.headline3?.copyWith(color: Colors.white),
          headline4: appTextTheme.headline4?.copyWith(color: Colors.white),
          headline5: appTextTheme.headline5?.copyWith(color: Colors.white),
          bodyText1: appTextTheme.bodyText1?.copyWith(color: Colors.white),
          bodyText2: appTextTheme.bodyText2?.copyWith(color: Colors.white),
          button: appTextTheme.bodyText2?.copyWith(color: Colors.white),
          caption: appTextTheme.caption?.copyWith(color: Colors.white),
        ),
  );

  static final ThemeData markdownTheme = ThemeData(
      backgroundColor: Colors.black,
      primaryColor: Colors.white,
      textTheme: ThemeData.dark().textTheme.copyWith(
          bodyText2: appTextTheme.bodyText1?.copyWith(color: Colors.white)));

  static final ThemeData markdownThemeBlack = ThemeData(
      backgroundColor: Colors.black,
      primaryColor: Colors.white,
      textTheme: ThemeData.dark().textTheme.copyWith(
          bodyText2: appTextTheme.bodyText1?.copyWith(color: Colors.black)));

  static final ThemeData anyProblemNFTTheme = ThemeData(
      backgroundColor: Color(0xFFEDEDED),
      primaryColor: Colors.black,
      textTheme: TextTheme(
          bodyText1: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "IBMPlexMono")));

  static final ThemeData anyProblemNFTDarkTheme = ThemeData(
      backgroundColor: Colors.black,
      textTheme: TextTheme(
          bodyText1: TextStyle(
              color: Color(0xFFEDEDED),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "IBMPlexMono")));
}
