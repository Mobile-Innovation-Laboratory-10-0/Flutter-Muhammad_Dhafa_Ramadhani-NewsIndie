import 'package:dio/dio.dart';
import '../models/article_model.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[API] $obj'),
    ));
  }

  Future<List<Article>> fetchNews({String? category}) async {
    try {
      final queryParams = {
        'apikey': ApiConstants.apiKey,
        'country': ApiConstants.countryCode,
        'language': ApiConstants.languageCode,
      };

      if (category != null &&
          category.isNotEmpty &&
          category.toLowerCase() != 'all') {
        queryParams['category'] = category;
      }

      final response = await _dio.get(
        ApiConstants.newsEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success' && data['results'] != null) {
          final results = data['results'] as List;
          return results.map((json) => Article.fromJson(json)).toList();
        } else {
          throw Exception(
              'API returned unsuccessful status: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout - Please check your internet');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server took too long to respond');
      } else if (e.response?.statusCode == 429) {
        throw Exception('API rate limit exceeded - Please try again later');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Invalid API key - Please check your configuration');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}
