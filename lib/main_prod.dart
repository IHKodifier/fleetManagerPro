import 'package:fleet_manager_pro/environment.dart';
import 'package:fleet_manager_pro/main_common.dart';

Future<void> main() async {
  await mainCommon(Environment.prod);
}
