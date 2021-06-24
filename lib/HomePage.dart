import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/initFoods.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'reccommender.dart';
import 'package:foodenie/pages/loading.dart';
import "package:story_view/story_view.dart";
import 'pages/story_page.dart';
import 'api_key.dart';
import 'utilities/places_api.dart';
import 'utilities/notifications.dart';
import 'utilities/images_helper.dart';
import 'pages/meal_timings.dart';
import 'utilities/trending_builder.dart';

import "package:google_maps_webservice/places.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'dart:developer';

class HomePage extends StatefulWidget {
  final Auth auth;
  const HomePage(this.auth);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StoryController controller = StoryController();
  var link;
  Size get getScreenSize => MediaQuery.of(context).size;
  Auth get auth => widget.auth;
  Map<String, dynamic> userObj = {};
  List<dynamic> prefs = [];
  List<dynamic> recFoods = [
/*     {
      'category': 'Poha s',
      'diet': 'Vegetarian',
      'rank': 0,
      'recipe_title': 'Schezwan Poha  (Fusion )',
      'course': 'Indian Breakfast',
      'food_ID': 5476,
      'cuisine': 'Indo Chinese',
      'tags': 'Breakfast  Ideas|Fusion s|Sichuan s',
      'link':
          'https://curlytales.com/wp-content/uploads/2017/08/veg_food-e1502966998573-1280x720.jpg'
    },
    {
      'rank': 2,
      'tags':
          'Party Food s|Paneer s|Indian Lunch s|Office Lunch Box s|Indian Vegetarian s|Indian Potluck & Kitty Party s|Weekend Lunch s',
      'recipe_title': 'Layered Paneer Butter Masala Biryani',
      'cuisine': 'North Indian s',
      'food_ID': 2094,
      'course': 'Main Course',
      'category': 'Biryani s',
      'diet': 'Vegetarian',
      'link':
          'https://www.golokaso.com/wp-content/uploads/2018/05/veg-food-cover.jpg'
    } */
  ];
  List<StoryItem> storyFoods = [];
  List<Widget> trendingItems = [];
  String mealTime = "";

  List<Map<String, dynamic>> popUpMenuItems = [
    {"option": "Signout"},
    {"option": "Next page"},
    {"option": "Meal timings"},
    {"option": "Exit"}
  ];
  bool isLoading = true;
  bool isLoadSuccess = false;
  set setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  set setLoadSuccess(bool value) {
    setState(() {
      isLoadSuccess = value;
    });
  }

  Future<bool> initRecommend() {
    bool res;
    if (!isLoading) setLoading = true;
    recommend().then((value) {
      if (value == null || value.isEmpty) {
        setLoadSuccess = false;
      } else {
        recFoods = value['result'];
        for (var i = 0; i < recFoods.length; i++) {
          var foodItem = recFoods[i];
          recFoods[i]['link'] = getLink(
              foodItem['diet'], foodItem['course'], foodItem['recipe_title']);
        }
        /* print('items');
        recFoods.forEach((element) {
          print(element);
        });
        print('trending');
        trendingItems.forEach((element) {
          print(element);
        }); */
        storyFoods =
            recFoods.map((foodItem) => generateStoryItem(foodItem)).toList();
        setLoadSuccess = true;
      }
      setLoading = false;
      res = true;
    }).catchError((e) {
      setLoading = false;
      setLoadSuccess = false;
      res = false;
    });
    return Future.value(res);
  }

  @override
  void initState() {
    initRecommend().then((value) {
      int i = 1;
      trendingList.forEach((element) {
        Widget w = TrendingBuilder(foodItem: element, number: (i++).toString());
        trendingItems.add(w);
        setState(() {});
      });
    });
    //FirebaseFirestore.instance.collection("food_items").get().then((value) => foodIds=value);
    /*   user.doc(auth.uid).get().then((value) {
      userObj = value.data();
      foodItems.orderBy('rank').limit(20).get().then((value) {
        Map<String, dynamic> highestRankedFood = value.docs.last.data();
        print(highestRankedFood);
        String foodId = highestRankedFood['rank'].toString();
        prefs = userObj['prefs'];
        String isVeg = prefs.contains('veg').toString();
        String isDiet = prefs.contains('diet').toString();
        String snacksOk = prefs.contains('snacks').toString();
        getRequest('recommend?foodId=$foodId').then((value) {
          recFoods = value['result'];
          setState(() {
            storyFoods = recFoods
                .map((foodItem) => generateStoryItem(foodItem))
                .toList();
          });
        });
      });
    }); */

    super.initState();
  }

  int i = 0;
  StoryItem generateStoryItem(Map<String, dynamic> foodItem) {
    return StoryItem(
        GestureDetector(
          onVerticalDragUpdate: (details) {
            i += 1;
            if (i == 1) {
              controller.pause();
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => StoryPage(foodItem)))
                  .then((value) {
                i = 0;
                controller.play();
              });
            }
          },
          child: StoryItem.inlineImage(
            url: foodItem['link'],
            controller: controller,
            caption: Text(
              foodItem['recipe_title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.black54,
                fontSize: 17,
              ),
            ),
          ).view,
        ),
        duration: Duration(seconds: 2));
  }
/* 
  /// to get the current location and the data.
  @override
  void initState() {
    // checkTimings();
    checkMealTime();
    // PlacesAPI().getRestaurants();
    // setState(() {
    //   link = ImagesHelper().getImage("Kheer");
    // });

    Workmanager()
        .initialize(getRestaurantsBackgroundService, isInDebugMode: true);
    Workmanager().cancelAll();

    // Workmanager().registerOneOffTask("1", "Foodenie Background Service");
    // Workmanager().registerPeriodicTask("Foodenie Restaurants Suggestions", "Foodenie Background Service",frequency: Duration(minutes: 15),);

    // final places = new GoogleMapsPlaces(
    //   apiKey: googlePlacesAPI,
    // );
    // print(places);
    super.initState();
  } */

  checkMealTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TimeOfDay breakfast = TimeOfDay(
        hour: prefs.getInt("breakfastHour"),
        minute: prefs.getInt("breakfastMinute"));
    TimeOfDay lunch = TimeOfDay(
        hour: prefs.getInt("lunchHour"), minute: prefs.getInt("lunchMinute"));
    TimeOfDay dinner = TimeOfDay(
        hour: prefs.getInt("dinnerHour"), minute: prefs.getInt("dinnerMinute"));

    TimeOfDay timeNow = TimeOfDay.now();

    if (breakfast.hour <= timeNow.hour && timeNow.hour < lunch.hour) {
      setState(() => mealTime = "Breakfast");
    } else if (lunch.hour <= timeNow.hour && timeNow.hour < dinner.hour) {
      setState(() => mealTime = "Lunch");
    } else {
      setState(() => mealTime = "Dinner");
    }
  }

  checkTimings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log(prefs.getInt("breakfastHour").toString(), name: "breakfastHour");
    log(prefs.getInt("breakfastMinute").toString(), name: "breakfastMinute");
    log(prefs.getInt("lunchHour").toString(), name: "lunchHour");
    log(prefs.getInt("lunchMinute").toString(), name: "lunchMinute");
    log(prefs.getInt("dinnerHour").toString(), name: "dinnerHour");
    log(prefs.getInt("dinnerMinute").toString(), name: "dinnerMinute");
    // log(TimeOfDay(hour: prefs.getInt("breakfastHour"), minute: prefs.getInt("breakfastMinute")).format(context));
  }

  Widget reloadPage() {
    return Container(
      width: getScreenSize.width,
      height: getScreenSize.height,
      margin: EdgeInsets.only(
          bottom: getScreenSize.height * 0.07,
          right: getScreenSize.width * 0.0),
      child: GestureDetector(
        onTap: initRecommend,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded,
                color: Colors.green, size: getScreenSize.width * 0.5),
            Text(
              'Tap to refresh',
              style: TextStyle(fontSize: 20, color: Colors.green[900]),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.lime,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Alata'),
        home: SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.lime[100],
              // color: Colors.pink[100],
              height: getScreenSize.height,
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : !isLoadSuccess
                      ? reloadPage()
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: getScreenSize.width * 0.03,
                                    right: getScreenSize.width * 0.03),
                                width: getScreenSize.width,
                                height: getScreenSize.height * 0.06,
                                alignment: Alignment.centerRight,
                                child: PopupMenuButton(
                                  color: Colors.lime[100],
                                  child: Icon(Icons.menu),
                                  onSelected: (optionDetails) async {
                                    // print('LL');
                                    String option = optionDetails['option'];
                                    if (option == 'Signout') {
                                      Auth.signOut();
                                    } else if (option == "Next page") {
                                      /*  Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoadingPage();
                            })); */
                                    } else if (option == "Meal timings") {
                                      /* Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MealTimings(
                                recall: true,
                              );
                            })); */
                                    }
                                  },
                                  itemBuilder: (context) => List.generate(
                                    popUpMenuItems.length,
                                    (index) =>
                                        PopupMenuItem<Map<String, dynamic>>(
                                      child:
                                          Text(popUpMenuItems[index]['option']),
                                      value: popUpMenuItems[index],
                                    ),
                                  ),
                                ),
                              ),
                              // Weather Widget
                              Container(
                                // margin: EdgeInsets.only(top: getScreenSize.height * 0.04),
                                width: getScreenSize.width * 0.4,
                                height: getScreenSize.width * 0.4,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.purple[900],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(200),
                                  ),
                                ),
                                child: FutureBuilder(
                                    future: PlacesAPI().getWeatherData(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: Text(
                                                "${double.parse(snapshot.data['main']['temp'].toString()).round().toString()}°C",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                      "${snapshot.data['weather'][0]['main'].toString()}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15)),
                                                  Text(mealTime,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15)),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                    }),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 30),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Food Recommendations",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            decoration: TextDecoration.overline,
                                            decorationThickness: 3,
                                            fontWeight: FontWeight.w200))),
                              ),
                              Container(
                                height: 230,
                                width: getScreenSize.width * 0.9,
                                padding: EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: StoryView(
                                        /* onVerticalSwipeComplete: (direction) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StoryPage(recFoods),
                                              ));
                                        }, */
                                        repeat: true,
                                        progressPosition: ProgressPosition.top,
                                        controller: controller,
                                        storyItems: storyFoods

                                        /* StoryItem.text(
                                            title:
                                                "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
                                            backgroundColor: Colors.orange,
                                            roundedTop: true,
                                          ),
                                          StoryItem.inlineImage(
                                            url:
                                                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                                            controller: controller,
                                            caption: Text(
                                              "Omotuo & Nkatekwan",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                backgroundColor: Colors.black54,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ), */
                                        ,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SizedBox(
                                        height: 45,
                                        child: Container(
                                          color: Colors.black.withOpacity(0.3),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                                child: Icon(
                                                  Icons.arrow_drop_up,
                                                  size: 32,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "Swipe up",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 30),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Trending",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            decoration: TextDecoration.overline,
                                            decorationThickness: 3,
                                            fontWeight: FontWeight.w200))),
                              ),
                              SizedBox(
                                width: getScreenSize.width,
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(flex: 1, child: trendingItems[0]),
                                    Flexible(flex: 1, child: trendingItems[1])
                                  ] /* [
                                    TrendingBuilder(
                                      asset: "assets/images/jalebi.jpg",
                                      number: "1",
                                    ),
                                    TrendingBuilder(
                                      asset: "assets/images/jalebi.jpg",
                                      number: "2",
                                    )
                                  ] */
                                  ,
                                ),
                              ),
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Container()
                                  Flexible(flex: 1, child: trendingItems[2]),
                                  Flexible(flex: 1, child: trendingItems[3])
                                ] /* [
                                  TrendingBuilder(
                                    asset: "assets/images/jalebi.jpg",
                                    number: "3",
                                  ),
                                  TrendingBuilder(
                                    asset: "assets/images/jalebi.jpg",
                                    number: "4",
                                  )
                                ] */
                                ,
                              )

                              // Future builder for building images based on String
                              // FutureBuilder(
                              //   builder: (context, snapshot) {
                              //     if (snapshot.hasData != true) {
                              //       return Text("Loading");
                              //     } else {
                              //       return Center(
                              //           child: Image.network(snapshot.data.toString()));
                              //     }
                              //   },
                              //   future: ImagesHelper().getImage("Kheer"),
                              // )
                            ],
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
