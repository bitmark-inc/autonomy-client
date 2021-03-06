//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/theme_manager.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:autonomy_flutter/view/au_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReleaseNotesPage extends StatefulWidget {
  final String releaseNotes;
  const ReleaseNotesPage({required this.releaseNotes, Key? key})
      : super(key: key);

  @override
  State<ReleaseNotesPage> createState() => _ReleaseNotesPageState();
}

class _ReleaseNotesPageState extends State<ReleaseNotesPage> {
  @override
  void dispose() {
    super.dispose();
    UIHelper.currentDialogTitle = '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AuThemeManager.get(AppTheme.sheetTheme);

    return Container(
      color: theme.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text("What’s new?", style: theme.textTheme.headline1),
          SizedBox(height: 40),
          Expanded(
            child: Markdown(
              data: widget.releaseNotes.replaceAll('\n', '\u3164\n'),
              softLineBreak: true,
              padding: EdgeInsets.only(bottom: 50),
              styleSheet: markDownBlackStyle,
            ),
          ),
          SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: AuFilledButton(
                  text: "CLOSE",
                  onPress: () => Navigator.of(context).pop(),
                  color: theme.primaryColor,
                  textStyle: TextStyle(
                      color: theme.backgroundColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: "IBMPlexMono"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
