import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateService {
  static const String versionUrl =
      "https://mahad-food-delivery.web.app/version.json";

  static Future<Map<String, dynamic>?> checkForUpdate() async {
    final response = await http.get(Uri.parse(versionUrl));
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (data["version"] != currentVersion) {
      return data;
    }

    return null;
  }

  static Future<void> downloadAndInstall(String apkUrl) async {
    final response = await http.get(Uri.parse(apkUrl));

    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/update.apk');

    await file.writeAsBytes(response.bodyBytes);

    await OpenFilex.open(file.path);
  }
}
