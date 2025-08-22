import 'package:get_storage/get_storage.dart';

final PrefConfig prefs = PrefConfig.instance;

class PrefConfig {
  static final PrefConfig instance = PrefConfig();

  // ABOUT GET STORAGE
  final GetStorage storage = GetStorage();

  dynamic getValue({required String key}) {
    return storage.read(key);
  }

  Future<void> setValue({required String key, dynamic value}) async {
    await storage.write(key, value);
  }

  Future<void> removeValue({required String key}) async {
    await storage.remove(key);
  }
}
