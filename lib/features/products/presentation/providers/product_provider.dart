import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';



// // // StateNotifierProvider to be used with StateNotifier
// .autoDispose se limpie en Auto c/q No se utiliza  |  .family para recibir Args en el provider
final productProvider = StateNotifierProvider
  .autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {

  // es quien ya solito se setea el AuthToken y se upd solito c/cambia el authStatus evaluando el token
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
    productsRepository: productsRepository,
    productId: productId
  );
});




// // // State Notifier: Generico para varios Providers de != useCases
class ProductNotifier extends StateNotifier<ProductState> {

  final ProductsRepository productsRepository;

  ProductNotifier({
    required this.productsRepository,
    required String productId,
  })
    : super(ProductState(id: productId)) {
      loadProduct();
    }


  Future<void> loadProduct() async {
    try {
      // ya tengo el ID xq el super() se ejecuta antes de llegar al constructor
      final product = await productsRepository.getProductById(state.id);

      // no req nada mas xq c/cierre ProductScreen se va a hacer el .autoDispose() q limpia este provider y cuando se vuelva a acceder a otro producto el   isLoading del state   va a estar en True. Asi q ya se automatizo eso
      state = state.copyWith(
        isLoading: false,
        product: product,
      );

    } catch (e) {
      print(e);
    }
  }

}




// // // State: Con Riverpod NO es indispensable el Equatable para comparar states como en Bloc
class ProductState {

  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    // Me lo deben proporcionar 100pre al crear este state
    required this.id,

    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });


  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );

}

