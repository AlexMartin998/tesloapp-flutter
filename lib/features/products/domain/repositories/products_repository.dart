import 'package:teslo_shop/features/products/domain/domain.dart';


abstract class ProductsRepository {

  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});

  Future<Product> getProductById(String id);

  Future<List<Product>> searchProductByTerm(String term);

  Future<Product> saveProduct(Map<String, dynamic> productLike);

}

