import 'dart:async';

import 'package:flutter/material.dart';
import '../api_key.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

String baseUrl = "https://www.googleapis.com/customsearch";

List<dynamic> imgResult = [];

// &q=Kheer&searchType=image
class ImagesHelper {
  Future<String> getImage(String query) async {
    var completer = new Completer<String>();
    String val;

    await http.get(
        Uri.parse(
            '$baseUrl/v1?key=$googleCustomSearchAPI&cx=$cx&q=$query&searchType=image'),
        headers: {
          'Content-Type': 'application/json',
        }).then((value) {
      final response = value;
      if (response.statusCode == 200) {
        log(json.decode(response.body)['items'][0]['link'].toString(),
            name: "Images Helper");

        if (json.decode(response.body)['items'] != null)
          imgResult = json.decode(response.body)['items'];
        completer.complete(
            json.decode(response.body)['items'][0]['link'].toString());
      }
    });
    return completer.future;
  }
}
