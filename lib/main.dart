import 'package:flutter/material.dart';
import 'AddPage/AddPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '代辦事項',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (Text('代辦事項')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, (MaterialPageRoute(builder: (context) => Addpage())));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
