//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/common/injector.dart';
import 'package:autonomy_flutter/gateway/iap_api.dart';
import 'package:autonomy_flutter/service/auth_service.dart';
import 'package:autonomy_flutter/util/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';
import 'dart:convert';

import 'package:sentry_flutter/sentry_flutter.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor();

  final logFilterResponseRegex = [
    RegExp(r'.*\/nft.*'),
    RegExp(r'.*support.*\/issues.*'),
  ];

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final curl = cURLRepresentation(err.requestOptions);
    final message = err.message;
    apiLog.info("API Request: $curl");
    apiLog.warning("Respond error: $message");
    return handler.next(err);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    final curl = cURLRepresentation(response.requestOptions);
    final message = response.toString();
    bool _isHasMatchRegexCurl = await compute(computeHasMatchRegexCurl, curl);

    if (_isHasMatchRegexCurl) {
      final request = response.requestOptions;
      apiLog.info("API Request: ${request.method} ${request.uri.toString()}");
    } else {
      apiLog.info("API Request: $curl");
    }

    try {
      final _ = await compute(computeFilterRegexCurl, curl);

      apiLog.info("API Response Status: ${response.statusCode}");
    } catch (_) {
      apiLog.info("API Response: $message");
    }

    return handler.next(response);
  }

  String cURLRepresentation(RequestOptions options) {
    List<String> components = ["\$ curl -i"];
    if (options.method != null && options.method.toUpperCase() == "GET") {
      components.add("-X ${options.method}");
    }

    if (options.headers != null) {
      options.headers.forEach((k, v) {
        if (k != "Cookie") {
          components.add("-H \"$k: $v\"");
        }
      });
    }

    try {
      var data = json.encode(options.data);
      if (data != null) {
        data = data.replaceAll('\"', '\\\"');
        components.add("-d \"$data\"");
      }
    } catch (err) {
      //ignore
    }

    components.add("\"${options.uri.toString()}\"");

    return components.join('\\\n\t');
  }
}

class SentryInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Map<String, dynamic> data = {
      'url': response.requestOptions.uri.toString(),
      'method': response.requestOptions.method,
      'status_code': response.statusCode,
    };
    if (response.requestOptions.headers.isNotEmpty) {
      data['header'] = response.requestOptions.headers.toString();
    }
    Sentry.addBreadcrumb(
      Breadcrumb(
        type: 'http',
        category: 'http',
        data: data,
      ),
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        type: 'http',
        category: 'http',
        level: SentryLevel.error,
        data: {
          'url': err.requestOptions.uri.toString(),
          'method': err.requestOptions.method,
          'status_code': err.response?.statusCode ?? "NA",
          'reason': err.type.name,
        },
        message: err.message,
      ),
    );
    super.onError(err, handler);
  }
}

class AutonomyAuthInterceptor extends Interceptor {
  AutonomyAuthInterceptor();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path != IAPApi.authenticationPath) {
      final jwt = await injector<AuthService>().getAuthToken();
      options.headers["Authorization"] = "Bearer ${jwt.jwtToken}";
    }

    return handler.next(options);
  }
}

// use isolate for expensive task
Future<RegExp> computeFilterRegexCurl(dynamic curl) async {
  List<RegExp> _logFilterRegex = [RegExp(r'.*\/nft.*')];
  RegExp _regExp = _logFilterRegex.firstWhere((regex) => regex.hasMatch(curl));
  return _regExp;
}

// use isolate for expensive task
Future<bool> computeHasMatchRegexCurl(dynamic curl) async {
  bool _isCurlHasMatch = RegExp(r'.*support.*\/issues.*').hasMatch(curl);
  return _isCurlHasMatch;
}
