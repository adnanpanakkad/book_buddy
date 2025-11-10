import 'package:book_buddy/core/presentation/widgets/common/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_buddy/core/presentation/widgets/common/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onCartPressed;

  const CustomAppBar({
    super.key,
    this.title = 'Book Buddy',
    this.onCartPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Appcolor.lightcolor,
      elevation: 0,
      leadingWidth: 170,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: Row(
        children: [
          const SizedBox(width: 10),
          Image.asset('assets/logo.png', height: 35, width: 35),
          const SizedBox(width: 15),
          Text(
            title,
            style: CustomTextStyle.RubicText(Colors.black, 18, FontWeight.w800),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.shopping_cart, color: Colors.black),
          onPressed: onCartPressed ?? () {},
        ),
      ],
    );
  }
}
