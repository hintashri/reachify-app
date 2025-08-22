import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/widgets/buttons/app_back_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: Center(
          child: Text(
            'Profile Screen',
            style: context.textTheme.headlineMedium,
          )),
    );
  }
}
