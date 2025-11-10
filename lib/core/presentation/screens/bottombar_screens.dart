import 'package:book_buddy/core/presentation/screens/favourite_screen.dart';
import 'package:book_buddy/core/presentation/screens/home_screen.dart';
import 'package:book_buddy/core/presentation/screens/search_screen.dart';
import 'package:book_buddy/core/presentation/screens/settings_screen.dart';
import 'package:book_buddy/core/presentation/widgets/common/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class BottombarScreens extends StatefulWidget {
  const BottombarScreens({super.key});

  @override
  BottombarScreensState createState() => BottombarScreensState();
}

class BottombarScreensState extends State<BottombarScreens> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const FavouriteScreen(),
    const SettingsScreen(),
  ];

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    CupertinoIcons.search,
    Icons.favorite_outlined,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        height: screenWidth * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            listOfIcons.length,
            (index) => InkWell(
              onTap: () {
                setState(() {
                  currentIndex = index;
                  HapticFeedback.lightImpact();
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Stack(
                children: [
                  SizedBox(
                    width: screenWidth * .2125,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: index == currentIndex ? screenWidth * .12 : 0,
                        width: index == currentIndex ? screenWidth * .2125 : 0,
                        decoration: BoxDecoration(
                          color: index == currentIndex
                              ? Appcolor.primaryColor.withOpacity(.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * .2125,
                    alignment: Alignment.center,
                    child: Icon(
                      listOfIcons[index],
                      size: screenWidth * .076,
                      color: index == currentIndex
                          ? Appcolor.primaryColor
                          : Colors.black26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
