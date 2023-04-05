import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  static Future<List<File>> pickMediafromCamera() async {
    final pickedFiles = <File>[];
    final XFile? xFile;

    xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) {
      return [];
    } else {
      pickedFiles.insert(0, File(xFile.path));
      return pickedFiles;
    }
  }
  static Future<List<File>> pickMediafromGallery() async {
    var  pickedFiles = <XFile>[];

    pickedFiles = await ImagePicker().pickMultiImage(requestFullMetadata: false);
    if (pickedFiles == null) {
      return [];
    } else {
      //  var returnList= 
      // pickedFiles.insert(0, File(xFile.path));
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

  Future<CroppedFile?> crop16by9Image(File imageFile) async =>
      await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.square
          ]);
}
