import 'package:customer/constants/shadows.dart';
import 'package:customer/features/home/bloc/qr_code_bloc.dart';
import 'package:customer/features/home/pages/store_map.dart';
import 'package:customer/features/notifications/pages/notifications_screen.dart';
import 'package:customer/network/model/sensei_error.dart';
import 'package:customer/user_defaults.dart';
import 'package:customer/widgets/sensei_drawer/sensei_drawer_controller.dart';
import 'package:customer/constants/styles.dart';
import 'package:customer/widgets/sensei_qr_code.dart';
import 'package:customer/widgets/sensei_qr_code_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  final SenseiDrawerController drawerController;
  QRCodeScreen({Key key, this.drawerController}) : super(key: key);

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  LatLng currentPostion;

  @override
  void initState() {
    _getUserLocation();
    BlocProvider.of<QrCodeBloc>(context).add(GetQRCode(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        title: SvgPicture.asset(
          "images/variable_images/Logo.svg",
          color: Color(0XFFCED4DA),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            widget.drawerController.toggle();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return NotificationsScreen();
                }),
              );
            },
          ),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF1F3F5),
                Colors.white,
                const Color(0xFFF1F3F5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [_buildContent(), Spacer(), _buildCurrentStore()],
          )),
    );
  }

  Widget _buildGreeting() {
    return FutureBuilder<dynamic>(
      future: UserDefaults.getName(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? Text(
                "Hi, ${snapshot.data.toString()}",
                textAlign: TextAlign.center,
                style: font1(
                    size: 23,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              )
            : Text(
                "Unable to find User's name",
                textAlign: TextAlign.center,
                style: font1(
                    size: 23,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor),
              );
      },
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 76),
          Container(width: double.infinity, child: _buildGreeting()),
          SizedBox(height: 24),
          BlocConsumer<QrCodeBloc, QrCodeState>(
              cubit: BlocProvider.of<QrCodeBloc>(context),
              listenWhen: (previous, current) => current is QrCodeScreenError,
              buildWhen: (previous, current) =>
                  (current is QrCodeScreenInitial) ||
                  (current is QRCodeLoading) ||
                  (current is QRCodeLoaded),
              builder: (context, state) {
                if (state is QrCodeScreenInitial) {
                  return _buildQRCodeCard(null);
                } else if (state is QRCodeLoading) {
                  return _buildQRCodeCard(null);
                } else if (state is QRCodeLoaded) {
                  return _buildQRCodeCard(state.gateToken.token);
                } else {
                  return SenseiQRCodeError(
                      error: QRCodeError.IN_DEBT,
                      callToAction: () {},
                      width: 235);
                }
              },
              listener: (context, state) {
                if (state is QrCodeScreenError) {
                  _showErrorDialog(state.senseiError);
                }
              }),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, color: Color(0XFFCED4DA)),
              SizedBox(width: 8),
              Text(
                "Scan key to enter".toUpperCase(),
                style: font1(
                    size: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.25,
                    color: Color(0XFFCED4DA)),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildCompanions(),
        ],
      ),
    );
  }

  Widget _buildQRCodeCard(String qrCodeData) {
    return Container(
      width: 235,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        boxShadow: [primaryShadow()],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SenseiQRCode(data: qrCodeData),
          _buildPaymentInfo(),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    int mockCardNum = 7925;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Divider(height: 1),
          SizedBox(height: 9),
          Container(
            height: 40,
            child: Row(
              children: [
                Spacer(),
                SvgPicture.asset("images/card_visa.svg"),
                SizedBox(width: 8),
                Text(
                  "••••$mockCardNum",
                  style: font2(
                    size: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF8C939B),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCompanions() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Colors.white,
        boxShadow: [primaryShadow()],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_outlined),
          Text(
            "3",
            style: font2(
                size: 16,
                fontWeight: FontWeight.w400,
                color: Color(0XFF8C939B)),
          )
        ],
      ),
    );
  }

  _buildCurrentStore() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreMap(
                  latLng: currentPostion,
                  senseiDrawerController: widget.drawerController),
            ));
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [primaryShadow()],
          ),
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 40),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Selected Store",
                    style: font2(
                        size: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffADB5BD)),
                  ),
                  SizedBox(height: 13),
                  Text(
                    "Sensei Multi-Concept Store",
                    style: font1(
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Address unavailable",
                    style: font2(
                      size: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF6A7178),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Open until 8:00 PM",
                    style: font2(
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF33D887),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.chevron_right),
            ],
          )),
    );
  }

  void _getUserLocation() async {
    var position = await _determinePosition();
    currentPostion = LatLng(position.latitude, position.longitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _getUserLocation();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _getUserLocation();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  _showErrorDialog(SenseiError senseiError) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog dialog = AlertDialog(
      title: Text(senseiError?.errorCode ?? "Oops!", style: font1(size: 16)),
      content: Text(
        senseiError?.message ?? "An error occurred",
        style: font1(size: 14),
      ),
      actions: [okButton],
    );
    showDialog(
        context: context,
        builder: (context) {
          return dialog;
        });
  }
}
