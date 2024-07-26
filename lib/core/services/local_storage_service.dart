import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _hideLatestRentCardKey = 'hideLatestRentCard';

  Future<void> setHideLatestRentCard(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hideLatestRentCardKey, value);
  }

  Future<bool> getHideLatestRentCard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hideLatestRentCardKey) ?? false;
  }
}
