import 'dart:io';

import 'package:farm_keep/models/product.dart';
import 'package:farm_keep/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AddRecordView extends StatefulWidget {
  const AddRecordView({Key? key, this.product}) : super(key: key);

  final Product? product;

  @override
  State<AddRecordView> createState() => _AddRecordViewState();
}

class _AddRecordViewState extends State<AddRecordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? processing;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedFile;
  final ProductProvider _productProvider = ProductProvider();
  bool isLoading = false;

  void selectImageFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
      });
    } else {
      throw Exception('Image not selected');
    }
  }

  void selectImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
      });
    } else {
      throw Exception('Image not selected');
    }
  }

  setImage() async {
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(widget.product!.image!);
    setState(() {
      _selectedFile = file;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _dateController.text = widget.product!.date!;
      _nameController.text = widget.product!.name!;
      processing = widget.product!.process!;
      setImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 2,
          title: Text(
            widget.product != null ? 'Edit Record' : 'Add Record',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Select product image',
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Select image source'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                  title: const Text('select from camera'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    selectImageFromCamera();
                                  }),
                              const Divider(),
                              ListTile(
                                  title: const Text('select from gallery'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    selectImageFromGallery();
                                  })
                            ],
                          ),
                        );
                      });
                },
                child: _selectedFile != null
                    ? Image.file(
                        _selectedFile!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/placeholder.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                onTap: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 365)));
                  if (date != null) {
                    _dateController.text = DateFormat('dd MMM yyyy').format(date);
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Date',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                  value: processing,
                  hint: const Text('Select a category'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Havest',
                      child: Text('Havest'),
                    ),
                    DropdownMenuItem(
                      value: 'Activity',
                      child: Text('Activity'),
                    ),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Process';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    processing = value;
                  }),
              const SizedBox(height: 35),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          //save data to database
                          final name = _nameController.text;
                          final date = _dateController.text;
                          final category = processing;
                          final image = _selectedFile!.readAsBytesSync();
                          final product = Product(
                              createdAt: DateTime.now().toIso8601String(),
                              date: date,
                              image: image,
                              name: name,
                              process: category);

                          final isSaved = widget.product != null
                              ? await _productProvider.updateProduct(product)
                              : await _productProvider.insertProduct(product);

                          setState(() {
                            isLoading = false;
                          });
                          if (isSaved) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                'Product saved successfully',
                                style: TextStyle(color: Colors.green),
                              ),
                            ));
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                'Could not save product',
                                style: TextStyle(color: Colors.red),
                              ),
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                              'One or more fields are empty!',
                              style: TextStyle(color: Colors.red),
                            ),
                          ));
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        widget.product != null ? 'Edit Record' : 'Add Record',
                        style: const TextStyle(color: Colors.white),
                      )),
            ],
          ),
        ));
  }
}
