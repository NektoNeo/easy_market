import 'package:dio/dio.dart';

import '../models/packaging_request.dart';
import '../models/packaging_response.dart';
import 'mappers/packaging_mapper.dart';
import '../models/packaging_response_dto.dart';

class ApiException implements Exception {
  ApiException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => 'ApiException($code): $message';
}

class ApiClient {
  ApiClient({required this.baseUrl, required this.installationId})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
            headers: {'X-Installation-Id': installationId},
          ),
        );

  final String baseUrl;
  final String installationId;
  final Dio _dio;

  Future<PackagingResponse> generatePackaging(PackagingRequest request) async {
    final dto = PackagingMapper.toDto(request);
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/v1/generate/packaging',
        data: dto.toJson(),
      );
      final data = res.data;
      if (data == null) throw ApiException('EMPTY', 'Empty response');
      return PackagingMapper.toDomain(PackagingResponseDto.fromJson(data));
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  Future<Map<String, dynamic>> fetchTemplatesRaw() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/v1/templates');
      return res.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  ApiException _mapDio(DioException e) {
    final status = e.response?.statusCode;
    if (status == 429) {
      return ApiException('RATE_LIMIT', 'Too many requests');
    }
    if (status != null && status >= 500) {
      return ApiException('SERVER', 'Server error');
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException('NETWORK', 'Network error');
    }
    // include some diagnostics for dev (safe)
    final msg = e.message ?? 'Unknown error';
    return ApiException('UNKNOWN', msg);
  }

  @override
  String toString() => 'ApiClient(baseUrl=$baseUrl)';
}
