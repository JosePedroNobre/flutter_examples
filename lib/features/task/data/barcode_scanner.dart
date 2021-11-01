import 'dart:convert';

import 'package:flutter/services.dart';

class BarcodeScanner {
  static final BarcodeScanner _barcodeScanner = BarcodeScanner._internal();
  static const MethodChannel _methodChannel =
      MethodChannel('tech.sensei.staffapp/command');
  static const EventChannel _scanChannel =
      EventChannel('tech.sensei.staffapp/scan');

  factory BarcodeScanner() {
    return _barcodeScanner;
  }

  BarcodeScanner._internal();

  turnOn(Function scanned) {
    _scanChannel.receiveBroadcastStream().listen((event) {
      scanned(event);
    });
  }

  turnOff() {}

  scan(Function scanned) {
    _sendDataWedgeCommand(
      "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER",
      "START_SCANNING",
    );

    Future.delayed(const Duration(milliseconds: 5000), () {
      scanned("Timeout");
    });
    _scanChannel.receiveBroadcastStream().asBroadcastStream().listen((event) {
      scanned(event);
    });
  }

  void endScan() {
    _sendDataWedgeCommand(
      "com.symbol.datawedge.api.SOFT_SCAN_TRIGGER",
      "STOP_SCANNING",
    );
  }

  // Scanner
  Future<void> _sendDataWedgeCommand(String command, String parameter) async {
    try {
      String argumentAsJson =
          jsonEncode({"command": command, "parameter": parameter});

      await _methodChannel.invokeMethod(
          'sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      print("error while invoking channel");
    }
  }

  Future<void> createProfile(String profileName) async {
    try {
      await _methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      print("error while invoking channel");
    }
  }
}
