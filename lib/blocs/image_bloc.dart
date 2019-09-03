import 'package:flutter/material.dart';
import 'package:rewalls/models/single_image_model.dart';

class ImageBloc extends ChangeNotifier {
  SingleImage _imageSingle;
  SingleImage get imageSingle => _imageSingle;

  set imageSingle (SingleImage imageSingle) {
    _imageSingle = imageSingle;
    notifyListeners(); 
  }

  showImageDetail(SingleImage imageData) {
    imageSingle = imageData;
  }
}