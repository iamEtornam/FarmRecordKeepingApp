import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: const Color.fromRGBO(198, 246, 168, 1),
      ),
      body: const BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({Key? key}) : super(key: key);

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
      controller: scrollController, children: [
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
              onPressed: () {},
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
        return GridView.builder(
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
                child: GridItem(
                  backgroundColor: selectedIndex == null
                      ? Colors.white
                      : (selectedIndex == index ? yellowColor : Colors.white),
                ));
          },
          itemCount: 20,
        );
      })
    ]);
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              Image.network(
                'https://images.pexels.com/photos/610294/pexels-photo-610294.jpeg?cs=srgb&dl=pexels-david-bartus-610294.jpg&fm=jpg',
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
                      children: const [
                        Expanded(
                          child: Text('Groundnuts',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Havest',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                    const Text('5 May'),
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
                    onPressed: () {},
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
