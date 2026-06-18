import 'package:package_info_plus/package_info_plus.dart';

class AppInfoUtil {
  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return "${info.version}+${info.buildNumber}";
  }

  static Future<String> getAppName() async {
    final info = await PackageInfo.fromPlatform();
    return info.appName;
  }

  static Future<String> getPackageName() async {
    final info = await PackageInfo.fromPlatform();
    return info.packageName;
  }
}
