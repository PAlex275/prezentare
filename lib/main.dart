import 'package:flutter/material.dart';
import 'package:prezentare_comunitate/generate_img_screen.dart';
import 'package:prezentare_comunitate/generate_recipe_screen.dart';
import 'package:prezentare_comunitate/generate_text_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GenerateTextScreen(),
      // home: GenerateRecipeScreen(),
      //home: GenImgScreen(),
    );
  }
}
