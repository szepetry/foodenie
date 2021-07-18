import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/utilities/background_tasks.dart';
import 'package:foodenie/utilities/notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_messaging/firebase_messaging.dart';
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

String baseUrl =
    'http://192.168.0.11:3000/'; //'https://us-central1-foodenie.cloudfunctions.net/app/';
String token;
String fbUid;
Map<String, dynamic> userObj = {};
List<Map<String, dynamic>> allFoodsList = [];
List<Map<String, dynamic>> trendingList = [];
CollectionReference user = FirebaseFirestore.instance.collection('users');
CollectionReference foodItems =
    FirebaseFirestore.instance.collection('food_items');
List<dynamic> likedItems = [];

void initMsgListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved");
    print(event.notification.body);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });
}

Future<String> get getFcmToken async =>
    await FirebaseMessaging.instance.getToken();

class Reccommend {
  static String setString(bool bf, bool lnch, bool dinr) {
    if (bf)
      return 'BF';
    else if (lnch)
      return 'LNCH';
    else if (dinr) return 'DINR';
  }

  static Future<void> initNotificationAlert() async {
    print('trig');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime bf = getTiming('BF', prefs);
    DateTime lnch = getTiming('LNCH', prefs);
    DateTime dinr = getTiming('DINR', prefs);
    DateTime now = DateTime.now();
    bool isBf = checkTiming(now, bf, 30);
    bool isLnch = checkTiming(now, lnch, 30);
    bool isDinr = checkTiming(now, dinr, 30);
    String timing = setString(isBf, isLnch, isDinr);
    var weatherData = await getWeatherData();
    print(weatherData);
    String weather = weatherData['weather'];
    String temperature = weatherData['temperature'];
    await Firebase.initializeApp();
    User fbUser = FirebaseAuth.instance.currentUser;
    String fbUid;
    if (fbUser != null) {
      fbUid = fbUser.uid;
    } else {
      fbUid = prefs.getString('fbUid');
    }
    var userRef = await user.doc(fbUid).get();
    var userObj = userRef.data();
    List<dynamic> likedItems = [];
    for (var i = 0; i < userObj['liked'].length; i++) {
      var item = await userObj['liked'][i].get();

      likedItems.add(item.data());
    }

    print(likedItems);
    List<dynamic> userPrefs = parseList(userObj['prefs']);
    Map<String, dynamic> notificationObj = {
      "prefs": userPrefs,
      "likedItems": likedItems,
      "weather": weather,
      "temperature": temperature,
      "timing": timing
    };
    await userRef.reference.update({
      "notification_rec": FieldValue.arrayUnion([notificationObj])
    });
    //filtered.elementAt(0)['food_ID'].toString();
  }

  static DateTime getTiming(String period, SharedPreferences prefs) {
    DateTime now = DateTime.now();
    switch (period) {
      case 'BF':
        int bfHour = prefs.getInt('breakfastHour');
        int bfMin = prefs.getInt('breakfastMinute');
        DateTime bf = new DateTime(now.year, now.month, now.day, bfHour, bfMin);
        return bf;
      case 'LNCH':
        int lnHr = prefs.getInt('lunchHour');
        int lnMin = prefs.getInt('lunchMinute');
        DateTime lnch = new DateTime(now.year, now.month, now.day, lnHr, lnMin);
        return lnch;
      case 'DINR':
        int dnHr = prefs.getInt('dinnerHour');
        int dnMin = prefs.getInt('dinnerMinute');
        DateTime dinr = new DateTime(now.year, now.month, now.day, dnHr, dnMin);
        return dinr;
    }
  }

  static List<String> parseList(List<dynamic> userPrefs) {
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

  static List<dynamic> timeFilteredList(List<dynamic> prefs, {bool isTimeRec}) {
    if (isTimeRec) {
      prefs.remove('Snack');
      prefs.remove('Dessert');
      //Iterable<dynamic> items = ['Indian Breakfast', 'Main Course', 'Dinner'];
      prefs.add('Indian Breakfast');
      prefs.add('Main Course');
      prefs.add('Dinner');
      return prefs;
    }
    print(prefs);
    return prefs;
  }

  static String getLink(String diet, String course, String name) {
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

  static bool checkTiming(DateTime now, DateTime foodTime, int time) {
    bool res = now.isBefore(foodTime.add(Duration(minutes: 120))) &&
        now.isAfter(foodTime.subtract(Duration(minutes: 120)));
    return res;
  }

  static Future<bool> checkTimeRec() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = new DateTime.now();
    int bfHour = prefs.getInt('breakfastHour');
    int bfMin = prefs.getInt('breakfastMinute');
    DateTime bf = new DateTime(now.year, now.month, now.day, bfHour, bfMin);
    int lnHr = prefs.getInt('lunchHour');
    int lnMin = prefs.getInt('lunchMinute');
    DateTime lnch = new DateTime(now.year, now.month, now.day, lnHr, lnMin);
    int dnHr = prefs.getInt('dinnerHour');
    int dnMin = prefs.getInt('dinnerMinute');
    DateTime dinr = new DateTime(now.year, now.month, now.day, dnHr, dnMin);
    if (checkTiming(now, dinr, 120) ||
        checkTiming(now, lnch, 120) ||
        checkTiming(now, bf, 120))
      return Future.value(true);
    else
      return Future.value(false);
  }

  static Future<Map<String, dynamic>> getWeatherData() async {
    dynamic data = await PlacesAPI().getWeatherData();
    int tempNum = double.parse(data['main']['temp'].toString()).round();
    String weather = data['weather'][0]['main'].toString();
    String temperature = "";
    if (tempNum > 28) {
      temperature = "Hot";
    } else if (tempNum < 28 && tempNum > 20) {
      temperature = "Normal";
    } else if (tempNum < 20) {
      temperature = "Cold";
    }
    return Future.value(
        {"temperature": temperature, "weather": weather.trim()});
  }

  /*  static List<dynamic> timeFilteredList(List<dynamic> prefs, {bool isTimeRec}) {
  if (isTimeRec) {
    prefs.remove('Snack');
    prefs.remove('Dessert');
    //Iterable<dynamic> items = ['Indian Breakfast', 'Main Course', 'Dinner'];
    prefs.add('Indian Breakfast');
    prefs.add('Main Course');
    prefs.add('Dinner');
    return prefs;
  }
  print(prefs);
  return prefs;
} */

  static Future<void> recommend() async {
    var result;
    http.Response res;
    String token;
    if (Auth.googleAuthObj.currentUser != null) {
      token = await Auth.getIdToken;
    } else {
      var account = await Auth.gSignIn;
      token = (await account.authentication).idToken;
    }
    String fbUid = FirebaseAuth.instance.currentUser.uid;
    var userObj = (await user.doc(fbUid).get()).data();
    List<dynamic> likedItems = [];
    userObj['liked'].forEach((ref) async {
      var item = await ref.get();
      likedItems.add(item.data());
    });
    List<dynamic> userPrefs = parseList(userObj['prefs']);
    bool isTimeRec = await checkTimeRec();
    userPrefs = timeFilteredList(userPrefs, isTimeRec: isTimeRec);
    List<Map<String, dynamic>> allFoodsList =
        (await foodItems.get()).docs.map((e) => e.data()).toList();
    Iterable<Map<String, dynamic>> filtered = allFoodsList.where((element) {
      String diet = element['diet'];
      String course = element['course'];

      if (isTimeRec) {
        if (userPrefs.contains(diet)) {
          if (userPrefs.contains(course)) {
            return true;
          } else
            return false;
        } else
          return false;
      } else {
        if (userPrefs.contains(diet))
          return true;
        else
          return false;
      }
    });
    var i = 0;
    filtered.forEach((element) {
      if (i <= 3) {
        print(element['rank']);
        print(element['recipe_title']);
        i++;
      }
    });
    /* 
    trendingList = filtered.take(4).map((e) {
      e.addAll({'link': getLink(e['diet'], e['course'], e['recipe_title'])});
      return e;
    }).toList(); */

    var weatherData = await getWeatherData();
    print(weatherData);
    //filtered.elementAt(0)['food_ID'].toString();
    try {
      Object body = jsonEncode({
        "prefs": userPrefs,
        "likedItems": likedItems,
        "weather": weatherData['weather'],
        "temperature": weatherData['temperature']
      });
      Uri url =
          Uri.parse('$baseUrl' + 'recommend?timeRec=${isTimeRec.toString()}');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      res = await http.post(url, headers: headers, body: body);

      if (res.statusCode >= 400) {
        throw new Error();
      } else {
        result = json.decode(res.body);
        var i1 = result['result'][0]['recipe_title'];
        var i2 = result['result'][1]['recipe_title'];
        var i3 = result['result'][2]['recipe_title'];
        await NotificationService().init();

        NotificationService().showNotification(
            "Foodenie", "Try out $i1, $i2 and $i3 in your area");
        print(result);
        //return result;
      }
    } catch (e) {
      //print(res);
      print(e);
      //return result;
    }
  }
}

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
    //Iterable<dynamic> items = ['Indian Breakfast', 'Main Course', 'Dinner'];
    prefs.add('Indian Breakfast');
    prefs.add('Main Course');
    prefs.add('Dinner');
    return prefs;
  }
  print(prefs);
  return prefs;
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

bool checkTiming(DateTime now, DateTime foodTime) {
  bool res = now.isBefore(foodTime.add(Duration(minutes: 120))) &&
      now.isAfter(foodTime.subtract(Duration(minutes: 120)));
  return res;
}

Future<bool> checkTimeRec() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime now = new DateTime.now();
  int bfHour = prefs.getInt('breakfastHour');
  int bfMin = prefs.getInt('breakfastMinute');
  DateTime bf = new DateTime(now.year, now.month, now.day, bfHour, bfMin);
  int lnHr = prefs.getInt('lunchHour');
  int lnMin = prefs.getInt('lunchMinute');
  DateTime lnch = new DateTime(now.year, now.month, now.day, lnHr, lnMin);
  int dnHr = prefs.getInt('dinnerHour');
  int dnMin = prefs.getInt('dinnerMinute');
  DateTime dinr = new DateTime(now.year, now.month, now.day, dnHr, dnMin);
  if (checkTiming(now, dinr) || checkTiming(now, lnch) || checkTiming(now, bf))
    return Future.value(true);
  else
    return Future.value(false);
}

Future<Map<String, dynamic>> getWeatherData() async {
  dynamic data = await PlacesAPI().getWeatherData();
  int tempNum = double.parse(data['main']['temp'].toString()).round();
  String weather = data['weather'][0]['main'].toString();
  String temperature = "";
  if (tempNum > 28) {
    temperature = "Hot";
  } else if (tempNum < 28 && tempNum > 20) {
    temperature = "Normal";
  } else if (tempNum < 20) {
    temperature = "Cold";
  }
  return Future.value({"temperature": temperature, "weather": weather.trim()});
}

Future<Map<String, dynamic>> recommend() async {
  var result;
  http.Response res;
  print(token);
  for (var i = 0; i < userObj['liked'].length; i++) {
    var item = await userObj['liked'][i].get();
    likedItems.add(item.data());
  }
  List<dynamic> userPrefs = parseList(userObj['prefs']);

  bool isTimeRec = await checkTimeRec();
  print(isTimeRec);
  userPrefs = timeFilteredList(userPrefs, isTimeRec: isTimeRec);
  Iterable<Map<String, dynamic>> filtered = allFoodsList.where((element) {
    String diet = element['diet'];
    String course = element['course'];

    if (isTimeRec) {
      if (userPrefs.contains(diet)) {
        if (userPrefs.contains(course)) {
          return true;
        } else
          return false;
      } else
        return false;
    } else {
      if (userPrefs.contains(diet))
        return true;
      else
        return false;
    }
  });
  var i = 0;
  print(userPrefs);
  filtered.forEach((element) {
    if (i <= 3) {
      print(element['rank']);
      print(element['recipe_title']);
      i++;
    }
  });
  trendingList = filtered.take(4).map((e) => e).toList();
  var weatherData = await getWeatherData();
  print(weatherData);
  print('aa');
  print(likedItems);
  //filtered.elementAt(0)['food_ID'].toString();
  try {
    Object body = jsonEncode({
      "prefs": userPrefs,
      "likedItems": likedItems,
      "weather": weatherData['weather'],
      "temperature": weatherData['temperature']
    });
    Uri url =
        Uri.parse('$baseUrl' + 'recommend?timeRec=${isTimeRec.toString()}');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print(body);
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

Future<void> updateRank(int foodId,
    {double value, bool isPrefs = false}) async {
  num inc = 1;
  if (value != null && value < 3) {
    inc = -1;
  }
  var foodDoc = await foodItems.where('food_ID', isEqualTo: foodId).get();
  foodDoc.docs.forEach((element) async {
    var doc = foodItems.doc(element.id.toString());
    await doc.update({'rank': FieldValue.increment(inc)});
    if (isPrefs) {
      inc == 1
          ? rateFood(ref: element.reference, isLike: true)
          : rateFood(isLike: false, foodId: foodId);
    }
  });
}

Future<void> rateFood({DocumentReference ref, bool isLike, int foodId}) async {
  if (isLike) {
    await user.doc(fbUid).update({
      'liked': FieldValue.arrayUnion([ref])
    });
  } else {
    await user.doc(fbUid).update({
      'disliked': FieldValue.arrayUnion([foodId])
    });
  }
}

Future<void> notificationReccommend() {}

/* Future<void> updatePrefs(int foodId) async {
  await foodItems.where('food_ID',isEqualTo: foodId).get().then((value){
    
  });
} */
