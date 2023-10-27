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
  Future<User> checkAuthStatus(String token) async {
    try {
      final res = await dio.get('/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          }
        )
      );

      final user = UserMapper.userJsonToEntity(res.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token Incorrecto');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexion a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
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
      if (e.response?.statusCode == 401) {
        // throw WrongCredentials();
        throw CustomError(e.response?.data['message'] ?? 'Credenciales Incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexion a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }

}
