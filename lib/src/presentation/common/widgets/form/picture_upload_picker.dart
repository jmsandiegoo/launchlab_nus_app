import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/modal_bottom_buttons_widget.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class PictureUploadPicker extends StatelessWidget {
  const PictureUploadPicker(
      {super.key, required this.imageHandler, this.image});

  final void Function(File?) imageHandler;
  final File? image;

  Future pickImage(ImagePicker picker, ImageSource source) async {
    XFile? pickedImageXFile = await picker.pickImage(source: source);
    File? pickedImageFile = convertToFile(pickedImageXFile);
    imageHandler(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return GestureDetector(
      onTap: () {
        showModalBottomSheetHandler(
          context,
          (context) => ModalBottomButtonsWidget(
            buttons: [
              ModalBottomButton(
                icon: Icons.photo_camera_outlined,
                label: "Camera",
                onPressHandler: () {
                  pickImage(picker, ImageSource.camera);
                  navigatePop(context);
                },
              ),
              ModalBottomButton(
                icon: Icons.photo_outlined,
                label: "Photo",
                onPressHandler: () {
                  pickImage(picker, ImageSource.gallery);
                  navigatePop(context);
                },
              ),
            ],
          ),
        );
      },
      child: CircleAvatar(
        radius: 50.0,
        backgroundImage: image != null ? FileImage(image!) : null,
        child:
            image == null ? Image.asset("assets/images/avatar_temp.png") : null,
      ),
    );
  }
}
