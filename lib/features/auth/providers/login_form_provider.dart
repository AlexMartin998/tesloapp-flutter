import 'package:formz/formz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/shared/shared.dart';



// // State: Con Riverpod NO es indispensable el Equatable para comparar states como en Bloc
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;


  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });


  // // keep it inmutable: create new state based on previous one
  LoginFormState copyWith({
    bool? isPosting, // async validations
    bool? isFormPosted, // onTap on submit btn
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );


  @override
  String toString() {

    return """
      LoginFormState {
        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        email: $email
        password: $password
      }
    """;
  }

}


// // State notifier: Generico para varios Providers de != useCases
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier(): super(
    // la creacion del init state debe ser Sync
    LoginFormState(), // init state
  );


  onEmailChanged(String value) {
    // create instance and set input as dirty 'cause it changed
    final newEmail = Email.dirty(value);

    state = state.copyWith(
      email: newEmail,

      // req validar todos los inputs existentes
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChanged(String value) {
    // create instance and set input as dirty 'cause it changed
    final newPassword = Password.dirty(value);

    state = state.copyWith(
      password: newPassword,

      // req validar todos los inputs existentes
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onSubmit() {
    // validate inputs
    _toucheEveryField();
    if (!state.isValid) return;

    print(state); // call toString();
  }


  _toucheEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    // c/new state, riverpot notify that change (re-render)
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }

}



// // StateNotifierProvider: like use cases   <--  Estos SII se usan en la UI
// .autoDispose(): Limpie la data de este State cuando se salga/destruya. Evito tener data al hacer login d new
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {

  return LoginFormNotifier(); // instance of our notifier

});
