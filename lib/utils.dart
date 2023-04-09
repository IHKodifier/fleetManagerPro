import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fleet_manager_pro/states/add_media_state.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

TextStyle SafeGoogleFont(
  String fontFamily, {
  TextStyle? textStyle,
  Color? color,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) {
  try {
    return GoogleFonts.getFont(
      fontFamily,
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  } catch (ex) {
    return GoogleFonts.getFont(
      "Source Sans Pro",
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }
}

class Utils {
  static Future<List<File>?> pickMediafromCamera() async {
    final pickedFiles = <File>[];
    final XFile? xFile;
    var cameraPermissionStatus = await Permission.camera.status;
    if (cameraPermissionStatus.isDenied) {
      await Permission.camera.request();
      
    xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) {
      return [];
    } else {
      pickedFiles.insert(0, File(xFile.path));
return pickedFiles;
        
      }
     
    
    
      
    }

  // return Future.value([]);
  }

  static Future<List<File>> pickMediafromGallery() async {
    var pickedFiles = <XFile>[];

    pickedFiles =
        await ImagePicker().pickMultiImage(requestFullMetadata: false);
    if (pickedFiles == null) {
      return [];
    } else {
      return pickedFiles.map((e) => File(e.path)).toList();
    }
  }

  Future<CroppedFile?> cropSquareImage(File imageFile) async =>
      await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.square
          ]);

  Future<CroppedFile?> crop16_x_9(File imageFile) async =>
      await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.square
          ],
          maxHeight: 1800,
          );

  Future<File> createFileFromCroppedFile(CroppedFile croppedFile) async {
    final bytes = await croppedFile.readAsBytes();
    final fileName = path.basename(croppedFile.path);
    final directory = path.dirname(croppedFile.path);
    final newFilePath = path.join(directory, 'cropped_$fileName');
    final file = File(newFilePath);
    await file.writeAsBytes(bytes);
    return file;
  }
  static String thousandify(int number) {
    String str = number.toString();
  int len = str.length;
  if (len <= 3) {
    return str;
  }
  String result = '';
  int i = 0;
  int remaining = len % 3;
  if (remaining > 0) {
    result = str.substring(0, remaining);
    i = remaining;
  }
  while (i < len) {
    if (result.isNotEmpty) {
      result += ',';
    }
    result += str.substring(i, i + 3);
    i += 3;
  }
  return result;
}
}