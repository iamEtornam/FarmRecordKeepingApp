import 'package:farm_keep/models/product.dart';
import 'package:farm_keep/repositories/db_connector.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getProduct(int id);
  Future<bool> insertProduct(Product product);
  Future<bool> updateProduct(Product product);
  Future<bool> deleteProduct(int id);
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<bool> deleteProduct(int id) async {
    try {
      final success = await DbHelper.deleteData(
        tableName: 'products',
        where: 'id = $id',
      );
      return success;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<Product?> getProduct(int id) async {
    try {
      final products = await DbHelper.readData(
        tableName: 'products',
        columns: ['id', 'name', 'date', 'process', 'image', 'createdAt'],
      );

      return products
          .map((product) => Product.fromJson(product))
          .toList()
          .where((element) => element.id == id)
          .first;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await DbHelper.readData(
        tableName: 'products',
        columns: ['id', 'name', 'date', 'process', 'image', 'createdAt'],
      );

      return products.map((product) => Product.fromJson(product)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<bool> insertProduct(Product product) async {
    try {
      //get values
      const tableName = 'products';
      Map<String, dynamic> data = product.toJson();

      //perform insert action
      await DbHelper.insertData(tableName: tableName, data: data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> updateProduct(Product product) async{
  try {
      //get values
      const tableName = 'products';
      Map<String, dynamic> data = product.toJson();

      //perform insert action
      final success = await DbHelper.updateData(tableName: tableName, values: data,where: 'id = ${product.id}');
      return success;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
