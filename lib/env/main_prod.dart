import 'package:customer/env/app_config.dart';
import 'main_common.dart';

Future<void> main() async {
  env = Stage.prod;
  return await mainCommon();
}
