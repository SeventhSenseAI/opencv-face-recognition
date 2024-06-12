import 'package:faceapp/core/constants/api_constants.dart';
import 'package:faceapp/core/networking/api_provider.dart';
import 'package:faceapp/core/services/baseurl_service.dart';
import 'package:faceapp/core/services/shared_preferences_service.dart';
import 'package:faceapp/features/myapi/data/model/sub.dart';
import 'package:faceapp/features/sidemenu/data/model/menu_data.dart';

class SubscriptionRepository {

  Future<String> getKey(Map<String, String>? headers) async {
    final res = await ApiProvider(baseURL: BaseURLService().baseURL).get('key', headers: headers);
    return res['key'];
  }

  Future<dynamic> getSubscriptionDetails() async {
    final jwtToken = await SharedPreferencesService.getJwtToken();
    final Map<String, String> headers = {
      'jwt_token': jwtToken,
      'Content-Type': 'application/json',
    };

    final responseJson = await ApiProvider(baseURL: ApiConstants.sandboxBaseURL)
        .get("subscription", headers: headers);

    final subscription = Subscription.fromMap(responseJson as Map<String, dynamic>);
    return subscription;
  }

  Future<dynamic> buySubscription(String productId) async {
    final jwtToken = await SharedPreferencesService.getJwtToken();
    final Map<String, String> headers = {
      'jwt_token': jwtToken,
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {"product_id": productId};

    final responseJson = await ApiProvider(baseURL: ApiConstants.sandboxBaseURL)
        .post("subscription", headers: headers, body: body);

    final subscription =
        Subscription.fromMap(responseJson as Map<String, dynamic>);
    return subscription;
  }

    Future<dynamic> deleteAccount() async {
    final jwtToken = await SharedPreferencesService.getJwtToken();
    final Map<String, String> headers = {
      'jwt_token': jwtToken,
      'Content-Type': 'application/json',
    };

    final responseJson = await ApiProvider(baseURL: ApiConstants.sandboxBaseURL)
        .delete("account", headers: headers);

    final menuData = MenuData.fromMap(responseJson as Map<String, dynamic>);
    return menuData;
  }

}



