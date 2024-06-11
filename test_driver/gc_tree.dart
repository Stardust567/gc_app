// 导入扩展
import 'package:flutter_driver/driver_extension.dart';
// 导入main入口文件
import 'package:gc_app/main.dart' as app;

void main() {
  enableFlutterDriverExtension();

  app.main();
}
