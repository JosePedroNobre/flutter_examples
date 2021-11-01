import 'package:customer/constants/styles.dart';
import 'package:customer/features/help/help_screen.dart';
import 'package:customer/features/receipts/pages/receipt_help_screen.dart';
import 'package:customer/features/home/pages/qr_code_screen.dart';
import 'package:customer/features/onboarding/onboarding_screen.dart';
import 'package:customer/features/profile/pages/profile_screen.dart';
import 'package:customer/features/receipts/pages/receipt_screen.dart';
import 'package:customer/features/wallet/presentation/wallet_screen.dart';
import 'package:customer/network/model/user.dart';
import 'package:customer/user_defaults.dart';
import 'package:customer/widgets/sensei_drawer/sensei_drawer.dart';
import 'package:customer/widgets/sensei_drawer/sensei_drawer_controller.dart';
import 'package:customer/features/authentication/presentation/landing_screen.dart';
import 'package:customer/network/network_defaults.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  SenseiDrawerController _controller;
  User user;
  List<String> _navigationItems = [
    "Receipts",
    "Wallet",
    "Help",
    "Replay Onboarding",
    "Logout",
  ];

  @override
  void initState() {
    super.initState();
    getUser();
    _controller = SenseiDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
  }

  getUser() async {
    user = User.fromJson(
        await UserDefaults.readObject(UserDefaultsKeys.USER.toString()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SenseiDrawer(
        backgroundColor: Colors.black,
        itemGap: 0.0,
        controller: _controller,
        header: _buildNavigationHeader(),
        footer: _buildNavigationFooter(),
        drawerItems: _navigationItems
            .asMap()
            .map((i, e) => MapEntry(i, _buildNavigationItem(i, e)))
            .values
            .toList(),
        child: QRCodeScreen(drawerController: _controller),
      ),
    );
  }

  Widget _buildNavigationHeader() {
    // TODO: get user image
    return FutureBuilder<dynamic>(
      future: UserDefaults.getName(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () => _controller.close(() {}),
                        splashColor: Colors.transparent,
                        color: Colors.white,
                        icon: Icon(
                          Icons.chevron_left,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(
                          "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.data.toString(),
                    style: font2(
                        size: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      _controller.close(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                                return ProfileScreen(user: user);
                              },
                              fullscreenDialog: false,
                            ));
                      });
                    },
                    child: Text(
                      "Edit account",
                      style: font2(
                          size: 16,
                          color: Color(0XFF838CFF),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }

  Widget _buildNavigationItem(int index, String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Color(0XFF6A7178),
        onTap: () async {
          switch (index) {
            case 0:
              _controller.close(() {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return ReceiptScreen();
                      },
                      fullscreenDialog: true,
                    ));
              });
              break;
            case 1:
              _controller.close(() {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return WalletScreen();
                      },
                      fullscreenDialog: false,
                    ));
              });
              break;
            case 2:
              _controller.close(() {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return HelpScreen();
                      },
                      fullscreenDialog: false,
                    ));
              });
              break;
            case 3:
              _controller.close(() {
                Navigator.push(
                    context,
                    MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return OnboardingScreen(
                          onNext: () {
                            Navigator.pop(context);
                          },
                          onSkip: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      fullscreenDialog: true,
                    ));
              });

              break;
            case 4:
              _logout();
              break;
            default:
              _controller.close(() {});
          }
        },
        child: Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          width: double.infinity,
          child: Text(
            text,
            style: font1(
                size: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationFooter() {
    return Row(
      children: [
        Text(
          "Legal",
          style:
              font2(size: 14, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        Spacer(),
        Text(
          "V1.0.0",
          style:
              font2(size: 14, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        Spacer(),
      ],
    );
  }

  void _logout() async {
    await NetworkDefaults.removeAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LandingScreen()),
        (Route<dynamic> route) => false);
  }
}
