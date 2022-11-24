import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart'
    as path_provider_interface;

///To save the Excel file in the Mobile and Desktop platforms.
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  String path;
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    final Directory directory =
        await path_provider.getApplicationSupportDirectory();
    path = directory.path;
  } else {
    path = await path_provider_interface.PathProviderPlatform.instance
        .getApplicationSupportPath();
  }

  final String fileLocation = '/storage/emulated/0/Download/$fileName';
  // Platform.isAndroid ? '$path\\$fileName' : '$path/$fileName';
  final File file = File(fileLocation);
  await file.writeAsBytes(bytes, flush: true);
}
