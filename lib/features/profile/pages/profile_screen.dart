import 'package:customer/constants/styles.dart';
import 'package:customer/features/authentication/presentation/landing_screen.dart';
import 'package:customer/features/authentication/presentation/phone_input_screen.dart';
import 'package:customer/features/profile/pages/profile_email_screen.dart';
import 'package:customer/features/profile/pages/profile_name_screen.dart';
import 'package:customer/features/profile/pages/profile_nif_screen.dart';
import 'package:customer/network/model/user.dart';
import 'package:customer/network/network_defaults.dart';
import 'package:customer/user_defaults.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Edit account",
              style: font1(
                  size: 20, color: Colors.black, fontWeight: FontWeight.w600)),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: _buildBody());
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 22),
      child: Column(children: [
        SizedBox(height: 33),
        _buildProfileItem(Icons.person, widget.user.name, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileNameScreen(name: widget.user.name)),
          );
        }),
        _buildProfileItem(Icons.mail_outline, widget.user.email, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileEmailScreen(email: widget.user.email)),
          );
        }),
        _buildProfileItem(Icons.smartphone_outlined, "+345 33 33 333", () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhoneInputScreen(
                      phoneInputContext: PhoneInputContext.RECOVER,
                    )),
          );
        }),
        _buildProfileItem(Icons.note_outlined, "NIF", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileNifScreen()),
          );
        }),
        Divider(),
        SizedBox(height: 15),
        InkWell(
          onTap: () {
            _logout();
          },
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                "Logout",
                style: font1(
                    size: 13, color: Colors.red, fontWeight: FontWeight.w600),
              )
            ],
          ),
        )
      ]),
    );
  }

  _buildProfileItem(IconData icon, String text, Function onClick) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 34),
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Row(children: [
          Icon(icon),
          SizedBox(width: 21),
          Text(text,
              style: font1(
                  size: 14, color: Colors.black, fontWeight: FontWeight.w600)),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 17)
        ]),
      ),
    );
  }

  void _logout() async {
    await UserDefaults.removeAll();
    await NetworkDefaults.removeAll();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LandingScreen()),
        (Route<dynamic> route) => false);
  }
}
