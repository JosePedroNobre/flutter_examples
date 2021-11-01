import 'package:staffapp/env/app_config.dart';
import 'package:staffapp/env/domain_controller.dart';
import 'package:staffapp/env/socket_controller.dart';
import 'package:staffapp/network/generic/auth_base_api.dart';
import 'package:staffapp/network/generic/services_base_api.dart';

class Environment {
  load() {
    switch (env) {
      case Stage.dev:
        print("Loading Environment: dev");
        AuthBaseApi.setBaseURL("https://auth.dev.sensei.tech/");
        ServicesBaseApi.setBaseURL("https://api.dev.sensei.tech/");
        DomainController().domain = "pickandgo";
        DomainController().storeId = 1004;
        SocketController().socketurl = "wss://api.dev.sensei.tech/staffapp/ws";
        break;
      case Stage.storeTest:
        print("Loading Environment: store test");
        AuthBaseApi.setBaseURL("https://auth.storetest.sensei.tech/");
        ServicesBaseApi.setBaseURL("https://api.storetest.sensei.tech/");
        DomainController().domain = "pickandgo";
        DomainController().storeId = 1;
        SocketController().socketurl =
            "wss://api.storetest.sensei.tech/staffapp/ws";
        break;
      case Stage.uat:
        print("Loading Environment: store");
        AuthBaseApi.setBaseURL("https://auth.qa.sensei.tech/");
        DomainController().storeId = 1004;
        ServicesBaseApi.setBaseURL("https://api.qa.sensei.tech/");
        SocketController().socketurl = "wss://api.uat.sensei.tech/staffapp/ws";
        DomainController().domain = "pickandgo";
        break;
      case Stage.prod:
        print("Loading Environment: prod");
        AuthBaseApi.setBaseURL("https://auth.sensei.tech/");
        DomainController().storeId = 1;
        ServicesBaseApi.setBaseURL("https://api.sensei.tech/");
        SocketController().socketurl = "wss://api.sensei.tech/staffapp/ws";
        DomainController().domain = "pickandgo";
    }
  }
}
