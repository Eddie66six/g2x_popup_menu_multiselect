import 'package:flutter/material.dart';
import 'package:g2x_popup_menu_multiselect/g2x_popup_menu_multiselect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
         child: Container(
           color: Colors.red,
           child: G2xPopupMenuMultiSelect(
             onSelected: (_){},
             children: List.generate(100, (index) => G2xPopupMenuMultiSelectModel(
               index.toString(),
               "sdfgsdfgsdfgsdfgsdfgsdf   " + index.toString()
             )),
             child: Row(
               children: [
                 Text("sdfgsdfg"),
                 Icon(Icons.arrow_drop_down)
               ],
             ),
           ),
         ),
       ),
    );
  }
}