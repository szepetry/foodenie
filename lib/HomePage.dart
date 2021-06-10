import 'package:flutter/material.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/pages/loading.dart';
import "package:story_view/story_view.dart";
import 'pages/story_page.dart';
import 'api_key.dart';
import 'utilities/places_api.dart';

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
  Size get getScreenSize => MediaQuery.of(context).size;
  Auth get auth => widget.auth;
  List<Map<String, dynamic>> popUpMenuItems = [
    {"option": "Signout"}
  ];

  /// to get the current location and the data.
  @override
  void initState() {
    // PlacesAPI().getRestaurants();

    // Workmanager().initialize(getRestaurantsBackgroundService, isInDebugMode: true);

    // Workmanager().registerOneOffTask("1", "Foodenie Background Service");

    // final places = new GoogleMapsPlaces(
    //   apiKey: googlePlacesAPI,
    // );
    // print(places);
    super.initState();
  }

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
                      print('LL');
                      String option = optionDetails['option'];
                      if (option == 'Signout') {
                        Auth.signOut();
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.only(top: getScreenSize.height * 0.04),
                    width: getScreenSize.width * 0.4,
                    height: getScreenSize.width * 0.4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue[200], Colors.blue]),
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                    ),
                    child: Text('Hot n cool',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoadingPage();
                    }));
                  },
                  child: Text('Next Page'),
                ),
                Container(
                  height: 300,
                  padding: EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      StoryView(
                        onVerticalSwipeComplete: (direction) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                // fullscreenDialog: true,
                                // maintainState: true,
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
                              "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.black54,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          // StoryItem.inlineImage(
                          //   NetworkImage(
                          //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
                          //   caption: Text(
                          //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       backgroundColor: Colors.black54,
                          //       fontSize: 17,
                          //     ),
                          //   ),
                          // ),
                          // StoryItem.inlineProviderImage(
                          //   AssetImage("assets/images/1.jpg"),
                          //   // controller: controller,
                          // ),
                          // StoryItem.inlineImage(
                          //   url:
                          //       "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                          //   controller: controller,
                          //   caption: Text(
                          //     "Hektas, sektas and skatad",
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       backgroundColor: Colors.black54,
                          //       fontSize: 17,
                          //     ),
                          //   ),
                          // )
                        ],

                        // onStoryShow: (s) {
                        //   print("Showing a story");
                        // },
                        // onComplete: () {
                        //   print("Completed a cycle");
                        // },
                        // progressPosition: ProgressPosition.bottom,
                        // repeat: false,
                        // inline: true,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
