import 'package:flutter/material.dart';

class PlacePredictions {
  String? secondary_text;
  String? main_text;
  String? place_id;

  PlacePredictions.fromJason(Map<String, dynamic> json) {
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }
}
