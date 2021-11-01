import 'app_config.dart';
import 'main_common.dart';

Future<void> main() async {
  env = Stage.dev;
  return await mainCommon();
}
