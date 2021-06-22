import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/initFoods.dart';
import 'reccommender.dart';
import 'package:foodenie/pages/loading.dart';
import "package:story_view/story_view.dart";
import 'pages/story_page.dart';
import 'api_key.dart';
import 'utilities/places_api.dart';
import 'utilities/notifications.dart';
import 'utilities/images_helper.dart';
import 'utilities/trending_builder.dart';

import "package:google_maps_webservice/places.dart";
import 'package:workmanager/workmanager.dart';

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
  List<Map<String, dynamic>> popUpMenuItems = [
    {"option": "Signout"},
    {"option": "Next page"},
    {"option": "Exit"}
  ];
  //var foodIds;

  @override
  void initState() {
    //FirebaseFirestore.instance.collection("food_items").get().then((value) => foodIds=value);
    super.initState();
  }
/* 
  /// to get the current location and the data.
  @override
  void initState() {
    // PlacesAPI().getRestaurants();
    // setState(() {
    //   link = ImagesHelper().getImage("Kheer");
    // });

    // Workmanager()
    //     .initialize(getRestaurantsBackgroundService, isInDebugMode: true);
    // Workmanager().cancelAll();

    // Workmanager().registerOneOffTask("1", "Foodenie Background Service");
    // Workmanager().registerPeriodicTask("Foodenie Restaurants Suggestions", "Foodenie Background Service",frequency: Duration(minutes: 15),);

    // final places = new GoogleMapsPlaces(
    //   apiKey: googlePlacesAPI,
    // );
    // print(places);
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            child: SingleChildScrollView(
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
                      child: Icon(Icons.menu),
                      onSelected: (optionDetails) async {
                        // print('LL');
                        String option = optionDetails['option'];
                        if (option == 'Signout') {
                          Auth.signOut();
                        } else if (option == "Next page") {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoadingPage();
                          }));
                        }
                      },
                      itemBuilder: (context) => List.generate(
                        popUpMenuItems.length,
                        (index) => PopupMenuItem<Map<String, dynamic>>(
                          child: Text(popUpMenuItems[index]['option']),
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
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Text(
                                    "${double.parse(snapshot.data['main']['temp'].toString()).round().toString()}°C",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                          "${snapshot.data['weather'][0]['main'].toString()}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                      Text("Lunch",
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
                    padding: const EdgeInsets.only(top: 20, left: 30),
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
                            onVerticalSwipeComplete: (direction) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoryPage(),
                                  ));
                            },
                            repeat: true,
                            progressPosition: ProgressPosition.top,
                            controller: controller,
                            storyItems: [
                              StoryItem.text(
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
                              ),
                            ],
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
                                    style: TextStyle(color: Colors.white),
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
                    padding: const EdgeInsets.only(top: 10, left: 30),
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
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TrendingBuilder(
                        asset: "assets/images/jalebi.jpg",
                        number: "1",
                      ),
                      TrendingBuilder(
                        asset: "assets/images/jalebi.jpg",
                        number: "2",
                      )
                    ],
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TrendingBuilder(
                        asset: "assets/images/jalebi.jpg",
                        number: "3",
                      ),
                      TrendingBuilder(
                        asset: "assets/images/jalebi.jpg",
                        number: "4",
                      )
                    ],
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
    );
  }
}
