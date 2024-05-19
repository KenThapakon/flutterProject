import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie/login.dart';
import 'package:movie/product_form_create.dart';

import 'package:movie/product_update.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

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
      final response = await dio.get(
        baseApi + "list/65130457?format=json",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          productList = response.data!;
        });
      }
    } catch (e) {
      if (!context.mounted) return;
    }
  }

  Future<void> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  Future<void> productDelete(movieId) async {
    try {
      await dio.delete("${baseApi}update/$movieId",
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));
      getProduct();
    } catch (e) {
      if (!context.mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 232, 170, 14),
        title: const Text(
          'ภาพยนต์ของฉัน',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductFormCreate()),
              );
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: logOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text(
              "Enjoy watching!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Best Free Apps for Streaming Movies in 2024",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              productList[index]["movie_cover"],
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.5,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(productList[index]["movie_name"]),
                          subtitle: Text('Director ${productList[index]["movie_director"]}'),
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('วันที่ ${productList[index]["update_date"].split("T")[0]}              '),
                              ),
                            IconButton(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("ลบข้อมูล"),
                                  content: Text("ลบข้อมูล ${productList[index]["movie_name"]}"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text("ปิด"),
                                    ),
                                    TextButton(
                                      onPressed: () => productDelete(productList[index]["movie_id"]),
                                      child: const Text("ตกลง"),
                                    ),
                                  ],
                                ),
                              ),
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductUpdate(
                                      movieId: productList[index]["movie_id"].toString(),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                              color: Color.fromARGB(255, 232, 170, 14),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                      productName: productList[index]["movie_name"] ?? '',
                                      productCover: productList[index]["movie_cover"] ?? '',
                                      productDescription: productList[index]["movie_description"] ?? '',
                                      productPrice: productList[index]["movie_director"] ?? '',
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_drop_down_circle),
                              color: Color.fromARGB(255, 232, 170, 14),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
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
        backgroundColor: Color.fromARGB(255, 232, 170, 14),
        title: Text(widget.productName),
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
                  title: Text('ผู้สร้าง ${widget.productPrice}'),
                  subtitle: Text(widget.productDescription),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
