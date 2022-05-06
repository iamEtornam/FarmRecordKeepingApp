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

  Future<bool> updateProduct(Product product) async {
    return _repository.updateProduct(product);
  }

  Future<bool> deleteProduct(int productID) async {
    return _repository.deleteProduct(productID);
  }

  Future<Product?> getOneProduct(int productID) async {
    return _repository.getProduct(productID);
  }
}
