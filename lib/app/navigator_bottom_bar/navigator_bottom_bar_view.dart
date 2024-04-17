// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meshwar/helpers/media_query.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../helpers/constants.dart';
import 'navigator_bottom_bar_cnr.dart';

class NavigateBarScreen extends StatefulWidget {
  const NavigateBarScreen({super.key});
  @override
  State<NavigateBarScreen> createState() => _HomePageState();
}

class _HomePageState extends State<NavigateBarScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<NavigatorBottomBarCnr>(
        init: NavigatorBottomBarCnr(),
        builder: (cnr) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              actions: [
                const Spacer(flex: 1),
                Text(
                  cnr.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: context.screenSize * sevenFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
              ],
            ),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SizedBox(child: cnr.pages[cnr.currentIndex]),
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: cnr.currentIndex,
              backgroundColor: Colors.white30,
              onTap: (int index) async {
                cnr.setCurrentIndex(index);
              },
              items: [
                SalomonBottomBarItem(
                  selectedColor: const Color.fromARGB(255, 42, 38, 2),
                  unselectedColor: Colors.grey,
                  icon: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.black],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.location_on,
                      size: context.screenSize * 0.10,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "الخريطه",
                    style: TextStyle(fontSize: context.screenSize * threeFont),
                  ),
                ),
                SalomonBottomBarItem(
                  selectedColor: const Color.fromARGB(255, 42, 38, 2),
                  unselectedColor: Colors.grey,
                  icon: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.black],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.home,
                      size: context.screenSize * 0.10,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "الرئيسيه",
                    style: TextStyle(fontSize: context.screenSize * threeFont),
                  ),
                ),
                SalomonBottomBarItem(
                  selectedColor: const Color.fromARGB(255, 99, 92, 25),
                  unselectedColor: Colors.grey,
                  icon: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.black,
                        ],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.person,
                      size: context.screenSize * 0.10,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "الملف الشخصي",
                    style: TextStyle(fontSize: context.screenSize * threeFont),
                  ),
                ),
                // SalomonBottomBarItem(
                //   selectedColor: const Color.fromARGB(255, 99, 92, 25),
                //   unselectedColor: Colors.grey,
                //   icon: ShaderMask(
                //     shaderCallback: (Rect bounds) {
                //       return const LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           Colors.black,
                //           Colors.black,
                //         ],
                //       ).createShader(bounds);
                //     },
                //     child: Icon(
                //       Icons.home,
                //       size: context.screenSize * 0.10,
                //       color: Colors.white,
                //     ),
                //   ),
                //   title: Text(
                //     "الرئيسيه",
                //     style: TextStyle(fontSize: context.screenSize * threeFont),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
