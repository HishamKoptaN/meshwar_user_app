import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen_controller.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        builder: (controller) {
          return Center(
            child: GestureDetector(
              onTap: () => controller.addTaxiRequest(),
              child: const Text(
                'اطلب تاكسي الان',
              ),
            ),
          );
        },
      ),
    );
  }
}
