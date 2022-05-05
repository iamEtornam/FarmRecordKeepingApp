import 'package:farm_keep/models/product.dart';
import 'package:farm_keep/repositories/product_repository.dart';

class ProductProvider {
  final ProductRepository _repository = ProductRepositoryImpl();

  Future<List<Product>> getProducts() async {
    return _repository.getProducts();
  }

  Future<bool> insertProduct(Product product) async {
    return _repository.insertProduct(product);
  }

  //TODO: update
  //TODO: delete
  //TODO: get one - IGNORE
}