import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launchlab/src/presentation/common/widgets/modal_bottom_buttons_widget.dart';
import 'package:launchlab/src/presentation/common/widgets/useful.dart';
import 'package:launchlab/src/utils/helper.dart';

class PictureUploadPickerInput
    extends FormzInput<File?, PictureUploadPickerError> {
  const PictureUploadPickerInput.unvalidated([File? value]) : super.pure(value);
  const PictureUploadPickerInput.validated([File? value]) : super.dirty(value);

  @override
  PictureUploadPickerError? validator(File? value) {
    return null;
  }
}

enum PictureUploadPickerError { invalid }

class PictureUploadPickerWidget extends StatelessWidget {
  const PictureUploadPickerWidget(
      {super.key,
      required this.onPictureUploadChangedHandler,
      this.image,
      this.imageURL = '',
      this.size = 110.0,
      this.isTeam = false});

  final void Function(File?) onPictureUploadChangedHandler;
  final File? image;
  final String? imageURL;
  final bool isTeam;
  final double size;

  Future pickImage(ImagePicker picker, ImageSource source) async {
    XFile? pickedImageXFile = await picker.pickImage(source: source);
    File? pickedImageFile = convertToFile(pickedImageXFile);
    onPictureUploadChangedHandler(pickedImageFile);
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
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              ModalBottomButton(
                icon: Icons.photo_outlined,
                label: "Photo",
                onPressHandler: () {
                  pickImage(picker, ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: isTeam ? BoxShape.rectangle : BoxShape.circle,
          image: DecorationImage(
            image: image != null
                ? FileImage(image!) as ImageProvider<Object>
                : isTeam
                    ? const ExactAssetImage(
                        "assets/images/team_avatar_temp.png")
                    : const ExactAssetImage("assets/images/avatar_temp.png"),
            fit: image != null ? BoxFit.cover : BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
