import 'package:customer/env/app_config.dart';
import 'package:customer/env/domain_controller.dart';
import 'package:customer/network/generic/auth_base_api.dart';
import 'package:customer/network/generic/services_base_api.dart';

class Environment {
  load() {
    switch (env) {
      case Stage.dev:
        print("Loading Environment: dev");
        AuthBaseApi.setBaseURL("https://auth.dev.sensei.tech/");
        ServicesBaseApi.setBaseURL("https://api.dev.sensei.tech/");
        DomainController().domain = "pickandgo";
        break;
      case Stage.uat:
        print("Loading Environment: uat");
        AuthBaseApi.setBaseURL("https://auth.qa.sensei.tech/");
        ServicesBaseApi.setBaseURL("https://api.qa.sensei.tech/");
        break;
      case Stage.prod:
        print("Loading Environment: prod");
        AuthBaseApi.setBaseURL("https://auth.sensei.tech/");
        ServicesBaseApi.setBaseURL("https://api.sensei.tech/");
    }
  }
}
