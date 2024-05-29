import 'package:crud_app/product_list_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(CrudApp());
}
class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.white,

          ),
        )
      ),
      home: ProductListScreen(),
    );

  }
}

