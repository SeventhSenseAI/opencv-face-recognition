import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesService {
  static const _email = "email";
  static const _devToken = "devToken";
  static const _jwtToken = "jwtToken";
  static const _liveness = "liveness";
  static const _region = "region";
  static const _fcmToken = "fcmToken";
  static const _apiToken = "APIToken";
  static const _onboard = "onboard";
  static const _login = "login";
  static const _sideMenu = "sidemenu";
  static const _search = "search";
  static const _collection = "collection";
  static const _person = "person";

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? emailVal = prefs.getString(_email);
    return emailVal ?? '';
  }

  static Future<void> setEmail(String emailVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_email, emailVal);
  }

  static Future<String> getDevToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? devTokenVal = prefs.getString(_devToken);
    return devTokenVal ?? '';
  }

  static Future<void> setDevToken(String devTokenVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_devToken, devTokenVal);
  }

  static Future<String> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtTokenVal = prefs.getString(_jwtToken);
    return jwtTokenVal ?? '';
  }

  static Future<void> setJwtToken(String jwtTokenVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtToken, jwtTokenVal);
  }

  static Future<bool> getLiveness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isliveness = prefs.getBool(_liveness) ?? false;
    return isliveness;
  }

  static Future<void> setLiveness(bool isLiveness) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_liveness, isLiveness);
  }

  static Future<String> getRegion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? region = prefs.getString(_region);
    return region ?? '';
  }

  static Future<void> setRegion(String region) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_region, region);
  }

  static Future<String> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? region = prefs.getString(_fcmToken);
    return region ?? '';
  }

  static Future<void> setFcmToken(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmToken, fcmToken);
  }

  static Future<String> getAPIToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? region = prefs.getString(_apiToken);
    return region ?? '';
  }

  static Future<void> setAPIToken(String apiToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiToken, apiToken);
  }

  static Future<bool> getOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool onboard = prefs.getBool(_onboard) ?? false;
    return onboard;
  }

  static Future<void> setOnboard(bool onboard) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboard, onboard);
  }

  static Future<bool> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool login = prefs.getBool(_login) ?? false;
    return login;
  }

  static Future<void> setLogin(bool login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_login, login);
  }

  static Future<bool> getMenu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool menu = prefs.getBool(_sideMenu) ?? false;
    return menu;
  }

  static Future<void> setMenu(bool menu) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sideMenu, menu);
  }

    static Future<bool> getSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool search = prefs.getBool(_search) ?? false;
    return search;
  }

  static Future<void> setSearch(bool search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_search, search);
  }

    static Future<bool> getCollection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool collection = prefs.getBool(_collection) ?? false;
    return collection;
  }

  static Future<void> setCollection(bool collection) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_collection, collection);
  }

    static Future<bool> getSavePerson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool person = prefs.getBool(_person) ?? false;
    return person;
  }

  static Future<void> setSavePerson(bool person) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_person, person);
  }
}
