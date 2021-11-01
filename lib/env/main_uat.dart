import 'app_config.dart';
import 'main_common.dart';

Future<void> main() async {
  env = Stage.uat;
  return await mainCommon();
}
