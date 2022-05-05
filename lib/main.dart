import 'dart:typed_data';

import 'package:farm_keep/app.dart';
import 'package:farm_keep/repositories/db_connector.dart';
import 'package:farm_keep/repositories/product_repository.dart';
import 'package:flutter/material.dart';

import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.openDb();

  //example of how to use the product repository
  final repo = ProductRepositoryImpl();
  print(await repo.getProducts());
  print(await repo.insertProduct(Product(
    name: 'test',
    date: 'test',
    process: 'test',
    image: Uint8List(100),
    createdAt: 'test',
  )));
  print("***************** after insert ******************");
  final products = await repo.getProducts();
  print(products.length);

  runApp(const MyApp());
}
