import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';




// // // StateNotifierProvider to be used with StateNotifier
// // StateNotifierProvider: like use cases   <--  Estos SII se usan en la UI
// .autoDispose(): Limpie la data de este State cuando se salga/destruya. Evito tener data al abrir el form d new
// .family(): para recibir Args en el provider
final productFormProvider = StateNotifierProvider.autoDispose.family
  <ProductFormNotifier, ProductFormState, Product>((ref, product) {

  // final saveProductCallback = ref.watch(productsRepositoryProvider).saveProduct; // no hacerlo separado, esto solo acata al back pero No upd la UI xq eso lo controlar el    ProductsProvider
  final saveProductCallback = ref.watch(productsProvider.notifier).saveProduct; // centralized

  return ProductFormNotifier(
    product: product,
    onSubmitCallback: saveProductCallback
  );
});





// // State notifier: Generico para varios Providers de != useCases
class ProductFormNotifier extends StateNotifier<ProductFormState> {

  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }): super(ProductFormState(
    id: product.id,
    title: Title.dirty(product.title),
    slug: Slug.dirty(product.slug),
    price: Price.dirty(product.price),
    inStock: Stock.dirty(product.stock),
    sizes: product.sizes,
    gender: product.gender,
    description: product.description,
    tags: product.tags.join(', '),
    images: product.images,
  ));


  // // onChanged
  void onTitleChanged(String value) {
    // create instance and set input as dirty 'cause it changed
    final newTitle = Title.dirty(value);

    state = state.copyWith(
      title: newTitle,

      // req validar todos los inputs existentes
      isFormValid: Formz.validate([
        newTitle,
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onSlugChanged(String value) {
    // create instance and set input as dirty 'cause it changed
    final newSlug = Slug.dirty(value);

    state = state.copyWith(
      slug: newSlug,

      // req validar todos los inputs existentes
      isFormValid: Formz.validate([
        newSlug,
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onPriceChanged(double value) {
    // create instance and set input as dirty 'cause it changed
    final newPrice = Price.dirty(value);

    state = state.copyWith(
      price: newPrice,

      // req validar todos los inputs existentes
      isFormValid: Formz.validate([
        newPrice,
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onStockChanged(int value) {
    // create instance and set input as dirty 'cause it changed
    final newStock = Stock.dirty(value);

    state = state.copyWith(
      inStock: newStock,

      // req validar todos los inputs existentes
      isFormValid: Formz.validate([
        newStock,
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
      ]),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(
      sizes: sizes,
    );
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender,
    );
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description,
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags
    );
  }


  // // onSubmit
  Future<bool> onFormSubmit() async {
    _touchedEverything();

    if (!state.isFormValid) return false;
    if (onSubmitCallback == null) return false;

    // like Product 'cause form returns somethig LIKE a product
    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images.map(
        (image) => image.replaceAll('${Environment.apiUrl}/files/product/', '')
      ).toList(),
    };

    try {
      await onSubmitCallback!(productLike);
      return true;
    } catch (e) {
      return false;
    }
  }


  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
    );
  }
}





// // // State: Con Riverpod NO es indispensable el Equatable para comparar states como en Bloc
class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.pure(),
    this.slug = const Slug.pure(),
    this.price = const Price.pure(),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.pure(),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });


  // // keep it inmutable: create new state based on previous one
  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );



}
