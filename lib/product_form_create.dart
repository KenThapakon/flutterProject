import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductFormCreate extends StatefulWidget {
  const ProductFormCreate({super.key});

  @override
  State<ProductFormCreate> createState() => _ProductFormCreateState();
}

class _ProductFormCreateState extends State<ProductFormCreate> {
  final dio = Dio();
  final baseApi = "https://testpos.trainingzenter.com/lab_dpu/movie/create/";
  final productName = TextEditingController();
  final productCover = TextEditingController();
  final productDescription = TextEditingController();
  final productPrice = TextEditingController();

  late String productOwner = "65130457";
  late String msg = "";
  @override
  Future<dynamic> productCreate() async {
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
          .post(baseApi,
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 232, 170, 14),
        title: const Text('เพิ่มภาพยนต์'),
        centerTitle: true,
      ),
      body: Column(
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
                  border: OutlineInputBorder(), labelText: 'URL รูป'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: productDescription,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'รายละเอียดภาพยนต์'),
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
              onPressed: productCreate,
              style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 255, 183, 0)),
              child: Text("บันทึกข้อมูล", style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), // สีส้มอ่อน
                  fontSize: 20, // ขนาดตัวอักษร
                  ),),),
        ],
      ),
    );
  }
}
