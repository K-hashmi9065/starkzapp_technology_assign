// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import '../models/user_dto.dart';

class RemoteUserApi {
  final Dio dio;
  RemoteUserApi({Dio? dio}) : dio = dio ?? Dio() {
    this.dio.options.validateStatus = (status) =>
        status != null && status >= 200 && status < 400;
    this.dio.options.receiveTimeout = const Duration(seconds: 30);
    this.dio.options.sendTimeout = const Duration(seconds: 30);
    this.dio.options.headers.addAll({
      'User-Agent': 'Mozilla/5.0 (Flutter; Dio)',
    });
  }

  Future<List<UserDto>> getUsers({int results = 20}) async {
    final response = await dio.get(
      'https://randomuser.me/api/',
      queryParameters: {'results': results},
    );
    print('Debug: API Response: ${response.data}');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> items = data['results'] as List<dynamic>;
    return items
        .map((e) => UserDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
