import 'package:autonomy_flutter/util/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

AppBar getBackAppBar(BuildContext context,
    {String title = "", required Function()? onBack}) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    leading: SizedBox(),
    leadingWidth: 0.0,
    automaticallyImplyLeading: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onBack,
          child: Row(
            children: [
              if (onBack != null) ...[
                Row(
                  children: [
                    SvgPicture.asset('assets/images/nav-arrow-left.svg'),
                    SizedBox(width: 7),
                    Text(
                      "BACK",
                      style: appTextTheme.caption,
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(width: 60),
              ],
            ],
          ),
        ),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: appTextTheme.caption,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 60),
      ],
    ),
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
  );
}
