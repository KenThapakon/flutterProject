import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie/login.dart';
import 'package:movie/product_form_create.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'product_update.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final dio = Dio();
  final baseApi = "https://testpos.trainingzenter.com/lab_dpu/movie/";
  late List productList = [];

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Future<void> getProduct() async {
    try {
      await dio
          .get(baseApi + "list/65130457?format=json",
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ))
          .then((response) => {
                if (response.statusCode == 200)
                  {
                    setState(() {
                      productList = response.data!;
                    })
                  }
              });
    } catch (e) {
      if (!context.mounted) return;
    }
  }

  Future<void> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> productDelete(movieId) async {
    try {
      await dio
          .delete("${baseApi}update/$movieId",
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ))
          .then((response) => {
                {Navigator.pop(context, "Cancel"), getProduct()}
              });
    } catch (e) {
      if (!context.mounted) return;
    }
  }

  Widget build(BuildContext context) {
    print(productList);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('ภาพยนต์ของฉัน'),
        ),
        body: Column(
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text("Enjoy watching !"),
              subtitle: Text("Best Free Apps for Streaming Movies in 2024"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Icon(Icons.logout),
                  onPressed: () => {
                    logOut(),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()))
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductFormCreate()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 9, 210, 19),
                  ),
                  child: const Text(
                    'เพิ่มข้อมูล',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
                child: TextButton(
              onPressed: () {},
              child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Image.network(productList[index]["movie_cover"]),
                          ListTile(
                            leading: const Icon(Icons.arrow_drop_down_circle),
                            title: Text(productList[index]["movie_name"]),
                            subtitle: Text(
                                'Director ${productList[index]["movie_director"]}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'วันที่ลงภาพยนต์ ${productList[index]["update_date"]}'),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                              title: const Text("ลบข้อมูล"),
                                              content: Text(
                                                  "ลบข้อมูล ${productList[index]["movie_name"]}"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text("ปิด"),
                                                ),
                                                TextButton(
                                                    onPressed: () => {
                                                          productDelete(
                                                              productList[index]
                                                                  ["movie_id"])
                                                        },
                                                    child: const Text("ตกลง")),
                                              ])),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 255, 0, 0),
                                  ),
                                  child: const Text(
                                    'ลบ',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductUpdate(
                                                movieId: productList[index]
                                                        ["movie_id"]
                                                    .toString())));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          24, 177, 252, 1)),
                                  child: const Text(
                                    'แก้ไข',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductDetail(
                                                  productName:
                                                      productList[index]
                                                              ["movie_name"] ??
                                                          '',
                                                  productCover:
                                                      productList[index]
                                                              ["movie_cover"] ??
                                                          '',
                                                  productDescription: productList[
                                                              index][
                                                          "movie_description"] ??
                                                      '',
                                                  productPrice: productList[
                                                              index]
                                                          ["movie_director"] ??
                                                      '',
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          24, 177, 252, 1)),
                                  child: const Text(
                                    'รายละเอียด..',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ))
          ],
        ));
  }
}

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    Key? key,
    required this.productName,
    required this.productCover,
    required this.productDescription,
    required this.productPrice,
  }) : super(key: key);

  final String productName;
  final String productCover;
  final String productDescription;
  final String productPrice;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(widget.productCover),
                ListTile(
                  title: Text(widget.productName),
                  subtitle: Text(widget.productDescription),
                ),
                Text(
                  'ผู้สร้าง ${widget.productPrice}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
