import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String baseUrl = 'https://us-central1-foodenie.cloudfunctions.net/app/';
String token;
Future<Map<String, dynamic>> getRequest(String endPoint) async {
  Map<String, dynamic> result;

  print(token);
  try {
    http.Response res =
        await http.get(Uri.parse('$baseUrl' + endPoint), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print(res.body + 'ddd');
    if (res.statusCode >= 400) {
      throw new Error();
    } else {
      result = json.decode(res.body);
      return result;
    }
  } catch (e) {
    print(e);
    return result;
  }
}

Future<void> updateRank(int foodId) async {
  var foodDoc = await FirebaseFirestore.instance
      .collection('food_items')
      .where('food_ID', isEqualTo: foodId)
      .get();
  foodDoc.docs.forEach((element) async {
    await FirebaseFirestore.instance
        .collection('food_items')
        .doc(element.id.toString())
        .update({'rank': FieldValue.increment(1)});
  });
}
