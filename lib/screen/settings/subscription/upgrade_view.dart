import 'package:autonomy_flutter/screen/settings/subscription/upgrade_bloc.dart';
import 'package:autonomy_flutter/screen/settings/subscription/upgrade_state.dart';
import 'package:autonomy_flutter/service/iap_service.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/theme_manager.dart';
import 'package:autonomy_flutter/view/au_button_clipper.dart';
import 'package:autonomy_flutter/view/au_filled_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UpgradesView extends StatelessWidget {
  static const String tag = 'select_network';

  @override
  Widget build(BuildContext context) {
    context.read<UpgradesBloc>().add(UpgradeQueryInfoEvent());

    return BlocBuilder<UpgradesBloc, UpgradeState>(builder: (context, state) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upgrades",
                style: appTextTheme.headline1,
              ),
              SizedBox(height: 16.0),
              _subscribeView(context, state),
            ],
          ));
    });
  }

  static Widget _subscribeView(BuildContext context, UpgradeState state) {
    switch (state.status) {
      case IAPProductStatus.completed:
        return Text("You are subscribed.", style: appTextTheme.headline4);
      case IAPProductStatus.loading:
      case IAPProductStatus.pending:
        return Container(
          height: 80,
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(),
        );
      case IAPProductStatus.notPurchased:
      case IAPProductStatus.expired:
        return GestureDetector(
          onTap: (() => _showSubscriptionDialog(
                  context, state.productDetails?.price, (() {
                context.read<UpgradesBloc>().add(UpgradePurchaseEvent());
              }))),
          child: Column(
            children: [
              Row(children: [
                Text("Subscribe", style: appTextTheme.headline4),
                Spacer(),
                Icon(CupertinoIcons.forward),
              ]),
              SizedBox(height: 16.0),
              Text(
                "• View your collection on TVs and projectors.\n• Preserve and authenticate your artworks for the long-term.\n• Priority Support.",
                style: appTextTheme.bodyText1,
              )
            ],
          ),
        );
      case IAPProductStatus.error:
        return Text("Error when loading your subscription.",
            style: appTextTheme.headline4);
    }
  }

  static _showSubscriptionDialog(
      BuildContext context, String? price, Function()? onPressSubscribe) {
    final theme = AuThemeManager().getThemeData(AppTheme.sheetTheme);

    showCupertinoModalBottomSheet(
        context: context,
        // isDismissible: false,
        // enableDrag: true,
        expand: false,
        backgroundColor: Color(0xFF737373),
        topRadius: Radius.zero,
        duration: Duration(milliseconds: 300),
        builder: (context) {
          return Container(
            // color: Color(0xFF737373),
            child: ClipPath(
              clipper: AutonomyTopRightRectangleClipper(),
              child: Container(
                color: theme.backgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("More Autonomy", style: theme.textTheme.headline1),
                    SizedBox(height: 40),
                    SvgPicture.asset(
                      'assets/images/premium_comparation.svg',
                      height: 320,
                    ),
                    SizedBox(height: 16),
                    Text(
                        "*Coming in Q1: View your collection on TVs and projectors. Preserve and authentificate your artworks for the long-term.",
                        style: theme.textTheme.headline5),
                    SizedBox(height: 40),
                    AuFilledButton(
                      text: "SUBSCRIBE FOR ${price ?? "\$4.99"}/MONTH",
                      onPress: () {
                        if (onPressSubscribe != null) onPressSubscribe();
                        Navigator.of(context).pop();
                      },
                      color: Colors.white,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: "IBMPlexMono"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "NOT NOW",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: "IBMPlexMono"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}