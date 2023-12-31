import 'package:dio/dio.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';



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
  Future<Product> saveProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/products' : '/products/$productId';

      productLike.remove('id'); // back does not wait for the ID
      productLike['images'] = await _uploadPhotos(productLike['images']);

      final res = await dio.request(
        url,
        data: productLike,
        options: Options(
          method: method
        ),
      );
      final product = ProductMapper.jsonToEntity(res.data);

      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final res = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(res.data);

      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
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



  Future<List<String>> _uploadPhotos(List<String> photos) async {
    final photosToUpload = photos
      .where((element) => element.contains('/')).toList();

    final photosIgnore = photos
      .where((element) => !element.contains('/')).toList();

    // upload all images at once (simultaneo)
    final List<Future<String>> uploadJob = photosToUpload
      .map(_uploadFile).toList();

    final newImages = await Future.wait(uploadJob);

    return [...photosIgnore, ...newImages];
  }


  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;

      // build form-data to send files
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName)
      });


      final res = await dio.post('/files/product', data: data);
      return res.data['image'];
    } catch (e) {
      throw Exception();
    }
  }
}