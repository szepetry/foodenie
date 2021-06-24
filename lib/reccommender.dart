import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

List<String> vegFoods = <String>[
  'https://media.easemytrip.com/media/Blog/India/636977607425696252/636977607425696252QYiiUU.jpg',
  'https://pbs.twimg.com/media/ETsKy9VVAAAm21Q.jpg',
  'https://www.hungryforever.com/wp-content/uploads/2015/03/Featured-image-vegetarian-restaurants-in-bangalore.jpg',
  'http://www.dineout.co.in/blog/wp-content/uploads/2019/08/sun-planet.jpg',
  'https://i.ytimg.com/vi/Q7PK8Wy8Sgk/maxresdefault.jpg',
  'https://qph.fs.quoracdn.net/main-qimg-678706e348c1e929cece3e5a259e7638',
  'https://img.taste.com.au/qwRsc_iL/w720-h480-cfill-q80/taste/2018/06/july-18_indian-style-potatoes-138753-1.jpg',
  'https://curlytales.com/wp-content/uploads/2017/08/veg_food-e1502966998573-1280x720.jpg',
  'https://goa-casitas.com/wp-content/uploads/2019/09/Jalsa.jpg'
];
List<String> eggFoods = <String>[
  'https://c.ndtvimg.com/2020-05/rdcvrtb_fried-egg_625x300_29_May_20.jpg',
  'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mothers-day-brunch-croque-madame-1587047696.jpg?crop=0.821xw:0.548xh;0.103xw,0.393xh&resize=640:*',
  'https://images-gmi-pmc.edge-generalmills.com/8dfd9c8e-1580-4508-a223-e5c15dd46d8e.jpg',
  'https://www.thespicedlife.com/wp-content/uploads/2015/07/North-Indian-Baked-Eggs-1-1-of-1.jpg'
];
List<String> paneerFoods = <String>[
  'https://www.golokaso.com/wp-content/uploads/2018/05/veg-food-cover.jpg',
  'https://gbc-cdn-public-media.azureedge.net/img16268.768x512.jpg',
  'https://d4t7t8y8xqo0t.cloudfront.net/resized/750X436/eazytrendz%2F2624%2Ftrend20191101125754.jpg',
  'https://theurbantandoor.com/wp-content/uploads/2019/08/paneer-butter-masala.jpg',
  'http://www.awesomecuisine.com/content_images/1/paneer_dishes.jpg'
];
List<String> nonVegFoods = <String>[
  'https://zarpar.in/wp-content/uploads/2018/05/Non-Veg-Food.jpg',
  'https://english.cdn.zeenews.com/sites/default/files/styles/zm_700x400/public/2017/12/28/650592-non-veg-food-pti.jpg',
  'https://www.keralataxis.com/wp-content/uploads/2016/05/pearlspot_fry.jpg',
  'https://beautyhealthtips.in/wp-content/uploads/2018/03/Best-non-veg-food.jpg',
  'https://i.ndtvimg.com/i/2017-11/winter-dish_620x350_41510574200.jpg',
  'https://www.shoutlo.com/uploads/articles/header-img-non-vegetarian-dishes-in-ludhiana.jpg',
  'https://beautyhealthtips.in/wp-content/uploads/2016/06/Advantages-and-disadvantages-of-non-veg-food.jpg',
];

List<String> snacks = <String>[
  'https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/publications/food-beverage-nutrition/bakeryandsnacks.com/article/2019/01/23/protein-still-reigns-as-top-trend-in-healthy-snacks/9059533-1-eng-GB/Protein-still-reigns-as-top-trend-in-healthy-snacks_wrbm_large.jpg',
  'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/high-protein-snack-ideas-1616101260.png?crop=0.393xw:0.785xh;0.00641xw,0&resize=640:*',
  'https://www.healthifyme.com/blog/wp-content/uploads/2020/02/IS-1.jpg',
  'https://us.123rf.com/450wm/jirkaejc/jirkaejc1003/jirkaejc100300206/6629772-the-photo-shot-of-the-salty-snacks.jpg?ver=6',
  'https://hips.hearstapps.com/hmg-prod/images/delish-how-to-make-a-smoothie-horizontal-1542310071.png',
  'https://www.dinneratthezoo.com/wp-content/uploads/2018/05/frozen-fruit-smoothie-3.jpg'
];

String baseUrl = 'https://us-central1-foodenie.cloudfunctions.net/app/';
String token;
String fbUid;
Map<String, dynamic> userObj = {};
List<Map<String, dynamic>> allFoodsList = [];
List<Map<String, dynamic>> trendingList = [];
CollectionReference user = FirebaseFirestore.instance.collection('users');
CollectionReference foodItems =
    FirebaseFirestore.instance.collection('food_items');

List<String> parseList(List<dynamic> userPrefs) {
  List<String> res = [];
  userPrefs.forEach((element) {
    switch (element) {
      case 'veg':
        res.addAll([
          'Vegetarian',
          'High Protein Vegetarian',
          'Eggetarian',
          'Vegan',
          'No Onion No Garlic (Sattvic)'
        ]);
        break;
      case 'nonVeg':
        res.addAll(['Non Vegeterian', 'High Protein Non Vegetarian']);
        break;
      case 'diet':
        res.addAll(
            ['Gluten Free', 'High Protein Vegetarian', 'Diabetic Friendly']);
        break;
      case 'snacks':
      case 'sweets':
      case 'beverages':
        res.addAll(['Snack', 'Dessert']);
    }
  });
  return res.toSet().toList();
}

/* I/flutter (27956): Vegetarian
I/flutter (27956): Eggetarian
I/flutter (27956): High Protein Non Vegetarian
I/flutter (27956): Non Vegeterian
I/flutter (27956): Vegan
I/flutter (27956): High Protein Vegetarian
I/flutter (27956): Diabetic Friendly
I/flutter (27956): No Onion No Garlic (Sattvic)
I/flutter (27956): Gluten Free 
  /*  'veg',
  'nonVeg',
  'diet',
  'snacks',
  'sweets',
  'beverages' */
*/

List<dynamic> timeFilteredList(List<dynamic> prefs, {bool isTimeRec}) {
  if (isTimeRec) {
    prefs.remove('Snack');
    prefs.remove('Dessert');
    prefs.addAll(['Indian Breakfast', 'Main Course', 'Dinner']);
    return prefs;
  }
  return prefs;
}

bool isTimeRec(bool bf, bool lnch, bool dinr) {
  return bf || lnch || dinr;
}

String getLink(String diet, String course, String name) {
  math.Random rand = new math.Random();
  if (name.toLowerCase().contains('egg')) {
    int idx = rand.nextInt(eggFoods.length);
    return eggFoods[idx];
  }
  if (name.toLowerCase().contains('paneer')) {
    int idx = rand.nextInt(paneerFoods.length);
    return paneerFoods[idx];
  }
  if (course != null) {
    if (course.toLowerCase().contains('snack') ||
        course.toLowerCase().contains('dessert')) {
      int idx = rand.nextInt(snacks.length);
      return snacks[idx];
    }
  }
  if (diet.contains('Non')) {
    int idx = rand.nextInt(nonVegFoods.length);
    return nonVegFoods[idx];
  } else {
    int idx = rand.nextInt(vegFoods.length);
    return vegFoods[idx];
  }
}

Future<Map<String, dynamic>> recommend({bool isTimeRec = false}) async {
  var result;
  http.Response res;
  print(token);
  List<dynamic> userPrefs = parseList(userObj['prefs']);
  userPrefs = timeFilteredList(userPrefs, isTimeRec: isTimeRec);
  Iterable<Map<String, dynamic>> filtered = allFoodsList.where((element) {
    String diet = element['diet'];
    String course = element['course'];
    if (isTimeRec) {
      if (userPrefs.contains(diet)) {
        if (userPrefs.contains(course))
          return true;
        else
          return false;
      } else
        return false;
    } else {
      if (userPrefs.contains(diet) || userPrefs.contains(course))
        return true;
      else
        return false;
    }
  });
  trendingList = filtered.take(4).map((e) {
    e.addAll({'link': getLink(e['diet'], e['course'], e['recipe_title'])});
    return e;
  }).toList();
  String foodId = filtered.elementAt(0)['food_ID'].toString();
  String timeRec = isTimeRec.toString();
  try {
    Object body = jsonEncode({"prefs": userPrefs});
    Uri url =
        Uri.parse('$baseUrl' + 'recommend?foodId=$foodId&timeRec=$timeRec');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    res = await http.post(url, headers: headers, body: body);

    if (res.statusCode >= 400) {
      throw new Error();
    } else {
      result = json.decode(res.body);
      print(result);
      return result;
    }
  } catch (e) {
    print(res);
    print(e);
    return result;
  }
}

Future<void> updateRank(int foodId, [double value]) async {
  num inc = 1;
  if (value != null && value < 3) {
    inc = -1;
  }
  var foodDoc = await foodItems.where('food_ID', isEqualTo: foodId).get();
  foodDoc.docs.forEach((element) async {
    await foodItems
        .doc(element.id.toString())
        .update({'rank': FieldValue.increment(inc)});
  });
}
