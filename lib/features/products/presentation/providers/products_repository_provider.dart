import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';



// // Provider de SOLO Lectura q Provee la instancia del ProductsRepoImpl a lo largo de toda la app
// aqui es donde creamos la Instancia del RepoImpl pasandole el DatasourceImpl
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {

  // get token (in some time it not exists so we use ??)
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  return ProductsRepositoryImpl(
    ProductsDatasourceImpl(
      accessToken: accessToken
    )
  );

});
