import 'package:book_buddy/core/presentation/widgets/common/app_color.dart';
import 'package:book_buddy/core/presentation/widgets/common/text_styles.dart';
import 'package:book_buddy/core/presentation/widgets/home/custom_appbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Appcolor.lightcolor,
        appBar: CustomAppBar(onCartPressed: () {}),
        body: ListView(children: [Center(child: Text('Home screen'))]),
      ),
    );
  }
}
