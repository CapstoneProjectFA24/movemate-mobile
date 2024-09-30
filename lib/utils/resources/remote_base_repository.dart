import 'dart:io' show HttpStatus;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

abstract class RemoteBaseRepository {
  @protected
  Future<T> getDataOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return httpResponse.data;
      } else {
        throw DioException(
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
        );
      }
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  @protected
  Future<T> getPayloadDataOf<T>({
    required Future<HttpResponse<Map<String, dynamic>>> Function() request,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final httpResponse = await request();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final payload = httpResponse.data['payload'];
        return fromJson(payload);
      } else {
        throw DioException(
          response: httpResponse.response,
          requestOptions: httpResponse.response.requestOptions,
          error:
              'Error ${httpResponse.response.statusCode}: ${httpResponse.response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
      rethrow;
    }
  }
}
