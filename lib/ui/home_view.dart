import 'package:farm_keep/models/product.dart';
import 'package:farm_keep/providers/product_provider.dart';
import 'package:farm_keep/ui/add_record_view.dart';
import 'package:farm_keep/ui/qrcode_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ProductProvider _provider = ProductProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 2,
        centerTitle: false,
        title: RichText(
            text: const TextSpan(
                text: 'Farm',
                style: TextStyle(fontSize: 20, color: Colors.green),
                children: [
              TextSpan(
                text: 'Keep',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            ])),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?cs=srgb&dl=pexels-pixabay-415829.jpg&fm=jpg'),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const QRCodeScannerView())),
              leading: const Icon(Icons.qr_code_2),
              title: const Text('Scan QRcode'),
            ),
            const Divider()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddRecordView()));
          if (result == true) {
            setState(() {});
            _provider.getProducts();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: const Color.fromRGBO(198, 246, 168, 1),
      ),
      body: StreamBuilder<List<Product>>(
          stream: _provider.getProducts().asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData ||
                snapshot.hasError ||
                snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No products found'),
              );
            }
            return BodyWidget(
              products: snapshot.data!,
              productProvider: _provider,
            );
          }),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({Key? key, required this.products, required this.productProvider})
      : super(key: key);
  final List<Product> products;
  final ProductProvider productProvider;

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final yellowColor = const Color.fromRGBO(245, 244, 220, 1);

  final scrollController = ScrollController();
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        controller: scrollController,
        children: [
          Row(
            children: [
              RichText(
                  text: const TextSpan(
                      text: 'Record book for ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                    TextSpan(
                        text: 'Farm1',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                  ])),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0F0F0),
                            ),
                            height: 350,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                Expanded(
                                  child: QrImage(
                                    padding: const EdgeInsets.all(8),
                                    backgroundColor: Colors.white,
                                    data: 'Farm1',
                                    version: QrVersions.auto,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Scan QR Code to download record book',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(color: Colors.red, fontSize: 16),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(backgroundColor: yellowColor),
                  child: Row(
                    children: const [
                      Text(
                        'GENERATE QR CODE',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.qr_code_2,
                        color: Colors.black,
                      )
                    ],
                  ))
            ],
          ),
          const SizedBox(height: 16),
          OrientationBuilder(builder: (context, orientation) {
            return RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              color: Colors.green,
         
              onRefresh: () => widget.productProvider.getProducts(),
              child: GridView.builder(
                controller: scrollController,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    childAspectRatio: .9,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text('Do you want to delete this product?'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        final isDeleted = await widget.productProvider
                                            .deleteProduct(widget.products[index].id!);
                                        if (isDeleted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                              'Product deleted!',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ));
                                          setState(() {
                                            widget.productProvider.getProducts();
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text(
                                              'Could not delete product',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ));
                                        }
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No')),
                                ],
                              );
                            });
                      },
                      child: GridItem(
                        product: widget.products[index],
                        backgroundColor: selectedIndex == null
                            ? Colors.white
                            : (selectedIndex == index ? yellowColor : Colors.white),
                      ));
                },
                itemCount: widget.products.length,
              ),
            );
          })
        ]);
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    Key? key,
    required this.backgroundColor,
    required this.product,
  }) : super(key: key);

  final Color backgroundColor;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              Image.memory(
                product.image!,
                height: 120,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(product.name!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.process!,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                    Text(product.date!),
                  ],
                ),
              )
            ],
          ),
          backgroundColor == Colors.white
              ? const SizedBox.shrink()
              : Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddRecordView(
                                    product: product,
                                  )));
                    },
                    mini: true,
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
