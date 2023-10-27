import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

import '../domain/domain.dart';



// // // StateNotifierProvider to be used with StateNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl(datasource: AuthDatasourceImpl());

  return AuthNotifier(authRepository: authRepository);
});




// // // State: Con Riverpod NO es indispensable el Equatable para comparar states como en Bloc
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });


  // // keep it inmutable: create new state based on previous one
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );

}



// // // State notifier: Generico para varios Providers de != useCases
class AuthNotifier extends StateNotifier<AuthState> {

  // de 1 el repo, sin use cases individuales con sus providers
  final AuthRepository authRepository;

  AuthNotifier({
    required this.authRepository
  }): super(AuthState());


  Future<void> login(String email, String password) async {
    // fake a slightly slow request
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials {  // evaludar el Tipo de Error en el Catch
      logout('Se ha producido un problema al iniciar sesión. Compruebe su correo electrónico y contraseña o cree una cuenta');
    } catch (e) {
      logout('Algo salio mal');
    }
  }

  void register(String email, String password) {

  }

  void checkAuthStatus(String email, String password) {

  }

  Future<void> logout([String? errorMessage]) async {
    // remove authToken

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }


  // upd state after successful login
  void _setLoggedUser(User user) {
    // save token in mobile

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

}


