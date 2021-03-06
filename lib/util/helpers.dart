//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:http/http.dart' as http;

int compareVersion(String version1, String version2) {
  final ver1 = version1.split(".").map((e) => int.parse(e)).toList();
  final ver2 = version2.split(".").map((e) => int.parse(e)).toList();

  var i = 0;
  while (i < ver1.length) {
    final result = ver1[i] - ver2[i];
    if (result != 0) {
      return result;
    }
    i++;
  }

  return 0;
}

Future<http.Response> callRequest(Uri uri) async {
  return await http.get(uri, headers: {
    "Connection": "Keep-Alive",
    "Keep-Alive": "timeout=5, max=1000"
  });
}
