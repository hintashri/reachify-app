import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reachify_app/theme/app_colors.dart';
import 'package:reachify_app/utils/const/logger.dart';
import 'package:flutter/cupertino.dart';

class AppFilePicker {
  static Future<void> showFilePickerBottomSheet({
    required BuildContext context,
    required Function(String filePath) onFilePicked,
  }) async {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Get.back();
              final String? pickedFile = await openImagePicker();
              if (pickedFile != null) {
                onFilePicked(pickedFile);
              }
            },
            child: Text(
              '📷 Capture Document',
              style: context.textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Get.back();
              final String? pickedFile = await openFilePicker();
              if (pickedFile != null) {
                onFilePicked(pickedFile);
              }
            },
            child: Text(
              '📂 Pick Document',
              style: context.textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back(); // closes the sheet
          },
          isDefaultAction: true,
          child: Text(
            'Cancel',
            style: context.textTheme.labelMedium?.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }

  static Future<String?> openImagePicker({
    ImageSource source = ImageSource.camera,
  }) async {
    try {
      final XFile? result = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );
      if (result != null) {
        // // logger.d("photo capture from = ${result.path}");
        // var file = File(result.path);
        // final input = ImageFile(
        //   rawBytes: await file.readAsBytes(),
        //   filePath: file.path,
        // );
        // final output = compress(ImageFileConfiguration(input: input));
        // logger.wtf('Input size = ${file.length()}');
        // logger.wtf('Output size = ${output.sizeInBytes}');
        final path = result.path;
        logger.f(path);
        return path;
      }
      return null;
    } catch (e, t) {
      logger.e('$e\n$t');
      return null;
    }
  }

  static Future<String?> openFilePicker() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
      );
      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path;
        logger.f(path);
        return path;
      }
      return null;
    } catch (e, t) {
      logger.e('$e\n$t');
      return null;
    }
  }

  // Future<bool> validateImageFromBytes(Uint8List imageData) async {
  //   var type = lookupMimeType('photo', headerBytes: imageData);
  //   return type == null ? false : type.contains('image');
  // }
}
