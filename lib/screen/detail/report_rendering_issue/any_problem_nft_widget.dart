//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import 'package:autonomy_flutter/database/entity/asset_token.dart';
import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/screen/customer_support/support_thread_page.dart';
import 'package:autonomy_flutter/screen/detail/report_rendering_issue/report_rendering_issue_widget.dart';
import 'package:autonomy_flutter/util/constants.dart';
import 'package:autonomy_flutter/util/error_handler.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnyProblemNFTWidget extends StatelessWidget {
  final AssetToken asset;
  final ThemeData theme;

  const AnyProblemNFTWidget(
      {Key? key, required this.asset, required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showReportIssueDialog(context),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.fromLTRB(0, 18, 0, 24),
        color: theme.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ANY PROBLEMS WITH THIS NFT?',
                style: theme.textTheme.bodyText1),
            SizedBox(
              width: 4,
            ),
            SvgPicture.asset("assets/images/iconSharpFeedback.svg",
                color: theme.textTheme.bodyText1?.color),
          ],
        ),
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    UIHelper.showDialog(
        context,
        "Report issue?",
        ReportRenderingIssueWidget(
          token: asset,
          onReported: (issueID) {
            showErrorDialog(
              context,
              "🤔",
              "We have automatically filed the rendering issue, and we will look into it. If you require further support or want to tell us more about the problem, please tap the button below.",
              "GET SUPPORT",
              () => Navigator.of(context).pushNamed(
                AppRouter.supportThreadPage,
                arguments: DetailIssuePayload(
                    reportIssueType: ReportIssueType.ReportNFTIssue,
                    issueID: issueID),
              ),
              "CLOSE",
            );
          },
        ),
        isDismissible: true);
  }
}
