import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color nearBlack = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF333333);
  static const Color gray = Color(0xFF666666);
  static const Color lightGray = Color(0xFFBBBBBB);
  static const Color silver = Color(0xFFE5E5E5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color paper = Color(0xFFF9F9F9); // Background sedikit warm
}

final BoxShadow newspaperShadow = BoxShadow(
  color: Colors.black.withOpacity(0.12),
  offset: const Offset(0, 3),
  blurRadius: 10,
  spreadRadius: 0,
);

final BoxShadow floatShadow = BoxShadow(
  color: Colors.black.withOpacity(0.2),
  offset: const Offset(0, 4),
  blurRadius: 12,
);

class ApiConstants {
  static const String baseUrl = 'https://newsdata.io/api/1';
  static const String apiKey =
      'pub_d2149796c1dc416dae7fadb6fb5adb05'; // Replace with your actual API key

  // Endpoints
  static const String newsEndpoint = '/news';

  // Parameters
  static const String countryCode = 'id'; // Indonesia
  static const String languageCode = 'id'; // Indonesian
}

class AppCategories {
  static const List<String> categories = [
    'All',
    'Technology',
    'Business',
    'Sports',
    'Politics',
    'Entertainment',
    'Health',
    'Science',
  ];

  static String getCategoryParam(String category) {
    if (category == 'All') return '';
    return category.toLowerCase();
  }
}
