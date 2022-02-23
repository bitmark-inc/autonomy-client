import 'package:autonomy_flutter/database/entity/connection.dart';
import 'package:autonomy_flutter/screen/app_router.dart';
import 'package:autonomy_flutter/screen/bloc/accounts/accounts_bloc.dart';
import 'package:autonomy_flutter/screen/bloc/persona/persona_bloc.dart';
import 'package:autonomy_flutter/util/string_ext.dart';
import 'package:autonomy_flutter/util/style.dart';
import 'package:autonomy_flutter/util/ui_helper.dart';
import 'package:autonomy_flutter/view/tappable_forward_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';

class AccountsView extends StatefulWidget {
  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final personaState = context.watch<PersonaBloc>().state;
    switch (personaState.deletePersonaState) {
      case ActionState.done:
        context.read<AccountsBloc>().add(GetAccountsEvent());
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        final accounts = state.accounts;
        if (accounts == null) return SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Accounts",
              style: appTextTheme.headline1,
            ),
            SizedBox(height: 24),
            ...accounts
                .map((account) => Column(
                      children: [
                        Slidable(
                            key: UniqueKey(),
                            endActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),

                              // A pane can dismiss the Slidable.
                              dismissible: DismissiblePane(onDismissed: () {
                                _deleteAccount(context, account);
                              }),

                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  icon: CupertinoIcons.delete,
                                  onPressed: (BuildContext context) {
                                    _deleteAccount(context, account);
                                  },
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                _accountItem(context, account),
                                SizedBox(height: 16),
                              ],
                            )),
                        Divider(height: 1.0),
                      ],
                    ))
                .toList(),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context, Account account) {
    final persona = account.persona;
    if (persona != null) {
      context.read<PersonaBloc>().add(DeletePersonaEvent(persona));
    }

    final connection = account.connections?.first;

    if (connection != null) {
      context.read<AccountsBloc>().add(DeleteLinkedAccountEvent(connection));
    }
  }

  Widget _accountItem(BuildContext context, Account account) {
    final persona = account.persona;
    if (persona != null) {
      return TappableForwardRow(
          leftWidget: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 24,
                  height: 24,
                  child: Image.asset("assets/images/autonomyIcon.png")),
              SizedBox(width: 16),
              Text(
                  persona.name.isNotEmpty
                      ? persona.name
                      : account.accountNumber.mask(4),
                  style: appTextTheme.headline4),
            ],
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRouter.personaDetailsPage, arguments: persona);
          });
    }

    final connection = account.connections?.first;
    if (connection != null) {
      return TappableForwardRow(
          leftWidget: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _appLogo(connection),
              SizedBox(width: 16),
              Text(
                  connection.name.isNotEmpty
                      ? connection.name
                      : connection.accountNumber.mask(4),
                  style: appTextTheme.headline4),
            ],
          ),
          rightWidget: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0x999999999), width: 1)),
            child: Text(
              "LINKED",
              style: TextStyle(
                  color: Color(0x999999999),
                  fontSize: 12,
                  fontFamily: "IBMPlexMono"),
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRouter.linkedAccountDetailsPage,
                arguments: connection);
          });
    }

    return SizedBox();
  }

  Widget _appLogo(Connection connection) {
    switch (connection.connectionType) {
      case 'feralFileToken':
      case 'feralFileWeb3':
        return SvgPicture.asset("assets/images/feralfileAppIcon.svg");

      case 'walletConnect':
        final walletName =
            connection.wcConnectedSession?.sessionStore.remotePeerMeta.name;

        switch (walletName) {
          case "MetaMask":
            return Image.asset("assets/images/metamask-alternative.png");
          case "Trust Wallet":
            return Image.asset("assets/images/trust-alternative.png");
          default:
            return Image.asset("assets/images/walletconnect-alternative.png");
        }

      case 'walletBeacon':
        final walletName = connection.walletBeaconConnection?.peer.name;
        switch (walletName) {
          case "Kukai Wallet":
            return Image.asset("assets/images/kukai_wallet.png");
          default:
            return Image.asset("assets/images/tezos_wallet.png");
        }

      default:
        return SizedBox();
    }
  }
}
