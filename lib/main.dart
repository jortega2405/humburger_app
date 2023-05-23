import 'package:bom_hamburguer/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:bom_hamburguer/screens/menu_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BOM HAMBURGUER',
        theme: ThemeData.dark(),
        home: MenuScreen(),
      ),
    );
  }
}
