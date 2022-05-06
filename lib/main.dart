import 'package:farm_keep/app.dart';
import 'package:farm_keep/repositories/db_connector.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.openDb();
  runApp(const MyApp());
}
