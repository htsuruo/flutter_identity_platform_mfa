import 'package:flutter/services.dart';

class ApiResponse {
  ApiResponse({
    required this.success,
    this.json,
    this.exception,
  });

  final bool success;
  final Map<String, dynamic>? json;
  final PlatformException? exception;
}
