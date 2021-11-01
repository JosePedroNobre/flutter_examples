import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:staffapp/env/socket_controller.dart';
import 'package:staffapp/features/dashboard/presentation/dashboard_screen.dart';
import 'package:staffapp/features/delegate_access/bloc/delegate_access_bloc.dart';
import 'package:staffapp/features/delegate_access/presentation/delegate_access_screen.dart';
import 'package:staffapp/features/qr_code/bloc/qr_code_bloc.dart';
import 'package:staffapp/features/qr_code/presentation/qr_code_screen.dart';
import 'package:staffapp/features/task/presentation/task_screen.dart';
import 'package:staffapp/network/generic/services_base_api.dart';
import 'package:staffapp/network/model/responses/authentication_response.dart';
import 'package:staffapp/network/model/socket_reponse.dart';
import 'package:staffapp/network/model/store_occupancy_payload.dart';
import 'package:staffapp/network/model/system_status_payload.dart';
import 'package:staffapp/network/model/task_response.dart';
import 'package:staffapp/network/model/work_session_status_payload.dart';
import 'package:staffapp/network/network_defaults.dart';
import 'package:staffapp/network/work_session_payload.dart';
import 'package:web_socket_channel/io.dart';

class NavigationShell extends StatefulWidget {
  NavigationShell({Key key}) : super(key: key);

  @override
  _NavigationShellState createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  List<Widget> _screens = [];
  int _selectedIndex = 2;
  int _previousIndex = 2;
  StreamController<WorkSessionPayload> numberOpenSessionsStream;
  StreamController<WorkSessionStatusPayload> workSessionStatusStream;
  StreamController<SystemStatusPayload> systemStatusStream;
  StreamController<StoreOccupancyPayload> occupancyStream;
  StreamController<List<TaskResponse>> storeTaskPayloadStream;
  StreamController<List<TaskResponse>> storeTaskCompletedStream;
  IOWebSocketChannel channel;

  @override
  void initState() {
    systemStatusStream = BehaviorSubject<
        SystemStatusPayload>(); // BehaviorSubject is special StreamController that captures the latest item that has been added to the controller, and emits that as the first item to any new listener without the need of broadcast it.
    occupancyStream = BehaviorSubject<StoreOccupancyPayload>();
    storeTaskPayloadStream = BehaviorSubject<List<TaskResponse>>();
    storeTaskCompletedStream = BehaviorSubject<List<TaskResponse>>();
    numberOpenSessionsStream = BehaviorSubject<WorkSessionPayload>();
    workSessionStatusStream = BehaviorSubject<WorkSessionStatusPayload>();
    connectToWebSocket();

    _screens = <Widget>[
      DashboardScreen(
        workSessionStatusStream: workSessionStatusStream.stream,
        systemStatusStream: systemStatusStream.stream,
        occupancyStream: occupancyStream.stream,
        numberOpenSessionsStream: numberOpenSessionsStream.stream,
        storeTaskPayloadStream: storeTaskPayloadStream.stream,
        storeTaskCompletedStream: storeTaskCompletedStream.stream,
      ),
      TaskScreen(
          workSessionStatusStream: workSessionStatusStream.stream,
          storeTaskPayloadStream: storeTaskPayloadStream.stream,
          storeTaskCompletedStream: storeTaskCompletedStream.stream),
      QRCodeScreen(),
      DelegateAccessScreen(),
    ];
    super.initState();
  }

  connectToWebSocket() async {
    String token = await NetworkDefaults.getToken();
    channel = IOWebSocketChannel.connect(
      SocketController().socketurl,
      pingInterval: Duration(seconds: 10),
      headers: {
        'Authorization': "Bearer ${token.replaceAll(new RegExp('"'), '')}"
      },
    );

    if (token != null) {
      channel.stream.asBroadcastStream().listen((data) {
        print(data);
        SocketResponse response = SocketResponse.fromJson(jsonDecode(data));
        if (response.type == "SYSTEM_STATUS") {
          systemStatusStream.sink.add(response.payload);
        } else if (response.type == "STORE_OCCUPATION") {
          occupancyStream.sink.add(response.payload);
        } else if (response.type == "TASK_UPDATE") {
          storeTaskPayloadStream.sink.add(response.payload);
        } else if (response.type == "COMPLETE_TASKS") {
          storeTaskCompletedStream.sink.add(response.payload);
        } else if (response.type == "NUM_OF_OPEN_WORK_SESSIONS") {
          numberOpenSessionsStream.sink.add(response.payload);
        } else if (response.type == "MY_WORK_SESSION_STATUS") {
          workSessionStatusStream.sink.add(response.payload);
        }
      }, onError: (error, StackTrace stackTrace) async {
        bool hasExpired = JwtDecoder.isExpired(token);
        if (hasExpired) {
          String _savedRefreshToken = await NetworkDefaults.getRefreshToken();
          AuthenticationResponse authResponse =
              await ServicesBaseApi.refreshToken(_savedRefreshToken);
          NetworkDefaults.setToken(authResponse.accessToken);
          connectToWebSocket();
        }
      }, onDone: () {
        print("Disconected");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0XFFF1F3F5),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 48,
            child: BottomNavigationBar(
              iconSize: 18,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lock_open),
                  label: "",
                ),
              ],
              currentIndex: _selectedIndex,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              unselectedItemColor: Color(0XFFADB5BD),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    numberOpenSessionsStream.close();
    workSessionStatusStream.close();
    systemStatusStream.close();
    occupancyStream.close();
    storeTaskPayloadStream.close();
    storeTaskCompletedStream.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_previousIndex != index) {
      setState(() {
        _selectedIndex = index;
        _previousIndex = index;
        BlocProvider.of<DelegateAccessBloc>(context).add(ResetDelegateAccess());
        BlocProvider.of<QrCodeBloc>(context).add(ResetQRCode());
      });
    }
  }
}
