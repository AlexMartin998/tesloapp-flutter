import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_impl.dart';

import '../domain/domain.dart';



// // // StateNotifierProvider to be used with StateNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl(datasource: AuthDatasourceImpl());
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService
  );
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

  // // 100pre las Abstracciones para desacoplar el codigo
  // de 1 el repo, sin use cases individuales con sus providers
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }): super(AuthState()) {
    // at the 1st instance chect auth status
    checkAuthStatus();
  }


  Future<void> login(String email, String password) async {
    // fake a slightly slow request
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e){
      logout(e.message); // backend error message || customMessage
    } catch (e) {
      logout('Something went wrong');
    }
  }

  void register(String email, String password) {

  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout(); // checking -> unauthenticated

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<void> logout([String? errorMessage]) async {
    // remove authToken
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }


  // upd state after successful login
  void _setLoggedUser(User user) async {
    // save token in mobile
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '' // clean errMsg
    );
  }

}


