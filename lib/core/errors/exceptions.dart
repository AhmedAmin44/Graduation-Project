import 'package:dio/dio.dart';
import 'package:graduation_app/core/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errModel;

  ServerException({required this.errModel});
}

void handleDioExceptions(DioException e) {
  dynamic rawData = e.response?.data;

  ErrorModel buildErrorModel(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ErrorModel.fromJson(data);
    } else {
      return ErrorModel(
        status: 0,
        errorMessage: data?.toString() ?? 'Unexpected error occurred',
      );
    }
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
      throw ServerException(errModel: buildErrorModel(rawData));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
        case 401:
        case 403:
        case 404:
        case 409:
        case 422:
        case 504:
          throw ServerException(errModel: buildErrorModel(rawData));
        default:
          throw ServerException(
            errModel: ErrorModel(
              status: e.response?.statusCode ?? 0,
              errorMessage: 'Unexpected server error',
            ),
          );
      }
  }
}
