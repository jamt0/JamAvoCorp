import 'package:dio/dio.dart';
import 'package:jam_avo_corp/data/models/env_config/environment.dart';
import 'package:jam_avo_corp/models/preferences.dart';
import 'package:jam_avo_corp/data/models/response_base.dart';

abstract class BaseApi<T> {
  static final Dio dio = Dio();

  final String pathApi = Environment().config.pathApi;
  final Preferences _preferences = Preferences();

  Future<ResponseBase<T>> post<T>({
    required String url,
    required dynamic body,
    required T Function(Map<String, dynamic>? data) mapper,
    bool secured = true,
    bool isFormData = false,
  }) async {
    return dio
        .post<Map<String, dynamic>>(
      pathApi + url,
      data: body,
      options: await _getRequestOptions(
        secured: secured,
        isFormData: isFormData,
      ),
    )
        .then(
      (response) {
        return ResponseBase.fromJson(response.data!, mapper);
      },
    ).catchError((error) {
      if (error is DioError) {
        return ResponseBase<T>.fromError(error);
      } else {
        throw error;
      }
    });
  }

  Future<ResponseBase<T>> get<T>({
    required String url,
    required T Function(Map<String, dynamic>? data) mapper,
    bool secured = true,
    bool isFormData = false,
    Map<String, dynamic>? query,
  }) async {
    return dio
        .get<Map<String, dynamic>>(pathApi + url,
            options: await _getRequestOptions(
              secured: secured,
              isFormData: isFormData,
            ),
            queryParameters: query)
        .then(
      (response) {
        return ResponseBase.fromJson(response.data!, mapper);
      },
    ).catchError((error) {
      if (error is DioError) {
        return ResponseBase<T>.fromError(error);
      } else {
        throw error;
      }
    });
  }

  Future<Options> _getRequestOptions(
      {required bool secured, required bool isFormData}) async {
    var accessToken = await _preferences.getAccessToken();

    final requestHeaders = {
      if (secured) 'Authorization': 'Bearer $accessToken',
      if (isFormData) "Content-Type": "multipart/form-data"
    };

    if (secured | isFormData) {
      return Options(
        headers: requestHeaders,
        responseType: ResponseType.json,
      );
    }

    return Options(responseType: ResponseType.json);
  }
}
