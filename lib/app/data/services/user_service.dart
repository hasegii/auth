import 'package:auth/app/data/models/tokens/tokens.dart';
import 'package:auth/app/data/models/user/user_info.dart';
import 'package:auth/app/data/services/storage_service.dart';
import 'package:auth/app/data/static/static.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';

class UserService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final _httpClient = Dio();

  UserService() {
    _httpClient.options.baseUrl = "$baseUrl/users";
    _httpClient.options.headers.addAll({"ngrok-skip-browser-warning": "1"});
    _httpClient.options.connectTimeout = const Duration(seconds: 5);
    _httpClient.options.receiveTimeout = const Duration(seconds: 3);

    _httpClient.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            debugPrint('UserService: Connection timed out');
            handler.next(error);
          } else if (error.type == DioExceptionType.badResponse) {
            debugPrint('UserService badresponse');
            return handler.next(error);
          } else {
            debugPrint('UserService error: ${error.message}');
            return handler.next(error);
          }
        },
      ),
    );
  }

  Future<bool> login(UserInfo credentials) async {
    try {
      Response response =
          await _httpClient.post("/login", data: credentials.toJson());
      if (response.statusCode == 200) {
        await _storageService.writeTokens(Tokens.fromJson(response.data));
        return true;
      }
    } on DioException {
      return false;
    }
    return false;
  }

  Future<bool> register(UserInfo credentials) async {
    try {
      Response response =
          await _httpClient.post("/register", data: credentials.toJson());
      if (response.statusCode == 200) {
        await _storageService.writeTokens(Tokens.fromJson(response.data));
        return true;
      }
    } on DioException {
      return false;
    }
    return false;
  }

  Future<bool> refresh() async {
    try {
      Tokens? tokens = await _storageService.readTokens();
      if (tokens == null) {
        await _storageService.deleteTokens();
        return false;
      }
      Response response =
          await _httpClient.post("/refresh", data: tokens.toJson());
      if (response.statusCode == 200) {
        await _storageService.writeTokens(Tokens.fromJson(response.data));
        return true;
      }
    } on DioException {
      await _storageService.deleteTokens();
      return false;
    }
    return false;
  }
}
