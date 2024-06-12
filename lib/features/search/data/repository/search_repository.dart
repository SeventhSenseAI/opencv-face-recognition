import 'package:faceapp/core/services/baseurl_service.dart';

import '../../../../core/networking/api_provider.dart';
import '../model/user.dart';

class SearchDataRepository {
  final apiProvider = ApiProvider(baseURL: BaseURLService().baseURL);

  Future<List<DetectResponse>> detectFaces({
    required String base64Image,
  }) async {
    Map<String, dynamic> body = {
      "image": base64Image,
      "search": {
        "max_results": 10,
        "min_score": 0.7,
        "search_mode": "ACCURATE",
      },
    };
    apiProvider.baseURL = BaseURLService().baseURL;
    final responseJson = await apiProvider.post("detect", body: body);
    final List<dynamic> responseList = responseJson as List<dynamic>;

    final response = detectResponseFromMap(responseList);

    return response;
  }

  Future<double> livenessCheck({
    required String base64Image,
  }) async {
    Map<String, dynamic> body = {
      "image": base64Image,
      "max_results": 10,
      "min_score": 0.7,
      "os": "DESKTOP",
      "search_mode": "ACCURATE",
    };
    apiProvider.baseURL = BaseURLService().baseURL;
    final responseJson = await apiProvider.post("liveness", body: body);

    double score = responseJson['liveness_score'];

    return score;
  }
}
