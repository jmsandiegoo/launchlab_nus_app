import 'package:flutter/material.dart';
import 'package:launchlab/src/config/app_theme.dart';
import 'package:launchlab/src/presentation/user/widgets/accomplishment_form.dart';
import 'package:launchlab/src/utils/helper.dart';

class AddAccomplishmentPage extends StatelessWidget {
  const AddAccomplishmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightGreyColor,
        leading: GestureDetector(
          onTap: () => navigatePop(context),
          child: const Icon(Icons.keyboard_backspace_outlined),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: const AccomplishmentForm(
            isEditMode: false,
          )),
    );
  }
}
