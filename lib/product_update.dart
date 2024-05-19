import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductUpdate extends StatefulWidget {
  const ProductUpdate({super.key, required this.movieId});
  final String movieId;

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  final dio = Dio();
  final baseApi = "https://testpos.trainingzenter.com/lab_dpu/movie/update/";
  final productName = TextEditingController();
  final productCover = TextEditingController();
  final productDescription = TextEditingController();
  final productPrice = TextEditingController();

  late String productOwner = "65130457";
  late String msg = "";

  @override
  void initState() {
    super.initState();
    getSingleProduct();
  }

  Future<dynamic> productUpdate() async {
    if (productName.text == '' ||
        productCover.text == '' ||
        productDescription.text == '' ||
        productPrice.text == '') {
      setState(() {
        msg = "กรุณาระบุข้อมูลให้ครบถ้วน";
      });
      return false;
    }
    try {
      await dio
          .put(baseApi + widget.movieId,
              data: {
                "movie_name": productName.text,
                "movie_cover": productCover.text,
                "movie_director": productPrice.text,
                "movie_description": productDescription.text,
                "movie_owner": productOwner
              },
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
              }))
          .then((response) => {Navigator.pushNamed(context, "product")});
    } catch (e) {
      setState(() {
        msg = "เกิดข้อผิดพลาด ไม่สามารถทำรายการได้";
      });
    }
  }

  Future<void> getSingleProduct() async {
    try {
      await dio
          .get(baseApi + widget.movieId,
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
                      productName.text = response.data['movie_name'];
                      productCover.text = response.data['movie_cover'];
                      productDescription.text =
                          response.data['movie_description'];
                      productPrice.text = response.data['movie_director'];
                    })
                  }
              });
    } catch (e) {
      if (!context.mounted) return;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('แก้ไขชื่อภาพยนต์'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: productName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'ชื่อภาพยนต์'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: productCover,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'URL รูปปกภาพยนต์'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: productDescription,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'รายละเอียดภาพยนต์'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: productPrice,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'ผู้สร้าง'),
                ),
              ),
              TextButton(
                  onPressed: productUpdate,
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("บันทึกข้อมูล",
                      style: TextStyle(color: Colors.blue))),
            ],
          ),
        ));
  }
}
