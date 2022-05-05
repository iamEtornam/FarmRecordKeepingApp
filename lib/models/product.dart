import 'dart:typed_data';

class Product {
  String? name;
  int? id;
  String? date;
  String? process;
  Uint8List? image;
  String? createdAt;

  Product({this.name, this.id, this.date, this.process, this.image, this.createdAt});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    date = json['date'];
    process = json['process'];
    image = json['image'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['date'] = date;
    data['process'] = process;
    data['image'] = image;
    data['createdAt'] = createdAt;
    return data;
  }
}
