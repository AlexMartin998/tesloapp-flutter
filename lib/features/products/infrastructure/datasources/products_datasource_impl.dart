import 'package:dio/dio.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';


class ProductsDatasourceImpl extends ProductsDatasource {

  // late xq lo configurare despues. Cuando los methods lo usen ya debe estar configurado
  late final Dio dio;
  // no me importa d donde venga el Token, no acoplar al AuthDatasource
  final String accessToken;


  ProductsDatasourceImpl({
    required this.accessToken
  }) : dio = Dio(  // configuro Dio para q toda req vaya con el JWT
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    )
  );


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    final res = await dio.get<List>('/products?limit=$limit&offset=$offset');

    final List<Product> products = [];
    for (final product in res.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }

}