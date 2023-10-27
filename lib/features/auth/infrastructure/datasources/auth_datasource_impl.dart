import 'package:dio/dio.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';


class AuthDatasourceImpl extends AuthDatasource {

  // // dio para este datasource
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,

  ));


  @override
  Future<User> checkAuthStatus(String token) {
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {

    try {
      final res = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      // mapper
      final user = UserMapper.userJsonToEntity(res.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) throw ConnectionTimeout();
      throw CustomError('Something went wrong', 500);
    } catch (e) {
      throw CustomError('Something went wrong', 500);
    }

  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }

}
