import 'package:flutter/material.dart';
import 'package:movie/login.dart';
import 'package:movie/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const MyHomePage(title: "My about time"),
        routes: <String, WidgetBuilder>{
          'product': (BuildContext context) => const ProductList(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int userId = 0;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences
        .getInstance(); //เพื่อเช็คว่ามีการเก็บ cached ชั่วคราวไว้ไหม
    final int userid = prefs.getInt('userauthen')!;
    setState(() {
      userId = userid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<bool>(
      builder: (context, snapshot) {
        if (userId >= 1) {
          return const ProductList();
        } else {
          return const Login();
        }
      },
      future: null,
    ));
  }
}
