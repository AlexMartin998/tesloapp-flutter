import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';



// riverpod: si no existe, crea la instancia, si ya existe la usa
final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});



// // // Usamos ChangeNotifier para q sea na solucion Generica q NO esta sujeta a Riverpod/Provider/Bloc  ||   refreshListenable espera 1 ChangeNotifier
// // ChangeNotifier: puede notificar cuando hay cambios y redibujar ante ellos
// notifica cambios en el State con    notifyListeners()    
class GoRouterNotifier extends ChangeNotifier {

  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;


  GoRouterNotifier(this._authNotifier) {
    // en todo momento debo estar pendiente de los cambios del _authNotifier
    _authNotifier.addListener((state) {
      // cuando cambia el authStatus, enseguida lo seteo aqui
      authStatus = state.authStatus;
    });
  }


  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();  // algo del state cambio, notificalo para q se redibuje el q escucha
  }

}
