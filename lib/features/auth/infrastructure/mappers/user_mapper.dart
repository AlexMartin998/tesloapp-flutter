import 'package:teslo_shop/features/auth/domain/domain.dart';


class UserMapper {

  static User userJsonToEntity(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    fullName: json['fullName'],
    isActive: json['isActive'],
    token: json['token'] ?? '',

    // mapear el Array q nos retorna la api: {roles:['admin']}
    roles: List<String>.from(json['roles'].map((role) => role)),

  );

}
