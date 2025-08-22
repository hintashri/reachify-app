import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/const/logger.dart';

final NetworkConfig net = NetworkConfig.instance;

class NetworkConfig {
  static final NetworkConfig instance = NetworkConfig();

  static final Dio _dio = Dio();

  Future<void> init({required String token}) async {
    if (token.isNotEmpty) {
      _dio.options.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
    }
  }

  bool successfulRes({dynamic response}) {
    return response is Response && response.statusCode == 200;
  }

  dynamic get({
    required String url,
    required Map<String, dynamic> params,
  }) async {
    final keysToRemove = <String>[];
    params.forEach((key, value) {
      if ((value is String) && (params[key].isEmpty)) {
        keysToRemove.add(key);
      }
    });
    for (var key in keysToRemove) {
      params.remove(key);
    }
    logger.d(
      'CALLING GET NET\nURL: $url\nPARAMS: $params\nHEADERS: ${_dio.options.headers}',
    );
    return _dio
        .get(url, queryParameters: params)
        .then(_success)
        .catchError(_failed);
  }

  dynamic post({
    required String url,
    dynamic body,
    bool isRaw = true,
    dynamic params,
  }) async {
    // if (kIsWeb) {
    //   _dio.options.headers.removeWhere((key, value) => key == 'apikey');
    //   _dio.options.headers.removeWhere((key, value) => key == 'token');
    //   body.addAll(_parameters);
    // }
    //   var keysToRemove = <String>[];
    // params.forEach((key, value) {
    //   if ((value is String) && (params[key].isEmpty)) {
    //     keysToRemove.add(key);
    //   }
    // });
    // for (var key in keysToRemove) {
    //   params.remove(key);
    // }
    logger.d(
      'CALLING POST NET\nURL: $url\nBODY : $body\nPARAMS: $params\nHEADERS: ${_dio.options.headers}',
    );
    dynamic data;
    if (isRaw) {
      data = json.encode(body);
    } else {
      data = FormData.fromMap(body);
    }
    return _dio
        .post(url, data: data, queryParameters: params)
        .then(_success)
        .catchError(_failed);
  }

  dynamic _success(Response response) {
    try {
      final dynamic url = response.requestOptions.uri;
      final dynamic data = response.data;
      final int? code = response.statusCode;
      logger.i('URL : $url\nRESPONSE $code : $data');

      // ResponseModel model = ResponseModel();
      // if (code != null && code == 200) {
      //   if (data is String) {
      //     final jsonData = jsonDecode(data);
      //     model = ResponseModel.fromJson(jsonData);
      //   } else if (data is List<dynamic>) {
      //     model = ResponseModel.fromListJson(data);
      //   }
      // }
      // return model;
      return response;
    } catch (e, t) {
      logger.e('$e\n$t');
      return null;
    }
  }

  Future<String> _failed(dynamic error) async {
    logger.e('onFailed\n$error');

    String message = 'Something went wrong';
    try {
      if (!(await isConnected())) {
        message = 'No internet connection';
      } else if (error is DioException) {
        logger.e(error.response);
        final List<dynamic> errData = error.response?.data['errors'];
        final String? errMessage = errData.first['message'];
        // logger.e("message :${errMessage}");

        final DioException dError = error;
        // String requestMethod = dError.requestOptions.method;
        // String requestURI = dError.requestOptions.uri.path;

        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            message = errMessage ?? 'Connection Timed out';
            break;
          case DioExceptionType.sendTimeout:
            message = errMessage ?? 'Send Timed out';
            break;
          case DioExceptionType.receiveTimeout:
            message = errMessage ?? 'Receive Timed out';
            break;
          case DioExceptionType.badResponse:
            switch (error.response?.statusCode) {
              case 400:
                message = errMessage ?? 'Invalid request';
                break;
              case 401:
                message = errMessage ?? 'Access denied';
                break;
              case 402:
                message = errMessage ?? 'Access denied';
                break;
              case 403:
                message = errMessage ?? 'Access denied';
                break;
              case 404:
                message =
                    errMessage ??
                    'The requested information could not be found';
                break;
              case 409:
                message = errMessage ?? 'Conflict occurred';
                break;
              case 500:
                message =
                    errMessage ??
                    'Internal server error occurred, please try again later';
                break;
            }
            break;
          case DioExceptionType.unknown:
            switch (error.response?.statusCode) {
              case 400:
                message = 'Invalid request';
                break;
              case 401:
                message = 'Access denied';
                dError;
              case 402:
                message = 'Access denied';
                break;
              case 403:
                message = 'Access denied';
                break;
              case 404:
                message = 'The requested information could not be found';
                break;
              case 409:
                message = 'Conflict occurred';
                break;
              case 500:
                message =
                    'Internal server error occurred, please try again later';
                break;
            }
            break;
          case DioExceptionType.cancel:
            message = 'Request Cancelled';
            break;
          default:
            break;
        }
      }
    } catch (e) {
      message = e.toString();
    }
    return message;
  }

  Future<bool> isConnected() async {
    try {
      final List<InternetAddress> list = await InternetAddress.lookup(
        'google.com',
      );
      return list.isNotEmpty && list[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
