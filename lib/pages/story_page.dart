import 'package:flutter/material.dart';

import "package:story_view/story_view.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../utilities/constants.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  double get deviceHeight => MediaQuery.of(context).size.height;
  double get deviceWidth => MediaQuery.of(context).size.width;

  List<StoryItem> storyItemList = [];

  final StoryController controller = StoryController();

  StoryItem storyItemBuilder(Duration duration) {
    return StoryItem(
      Stack(
        children: [
          Container(
            height: deviceHeight,
            child: Image.asset(
              "assets/images/jalebi.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 8.0),
              child: SizedBox(
                height: 350,
                width: 70,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Vegen",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Text(
                        "Main Course",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Text(
                        "prep + cook",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Text(
                        "Category",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      Text(
                        "Cuisine",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 260,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  /// Rating card color
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  glow: false,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    /// Star color
                    color: appBarColor,
                    size: 15,
                  ),
                  // itemBuilder: (context, index) {
                  //   switch (index) {
                  //     case 0:
                  //       return Icon(
                  //         Icons.star,
                  //         color: Colors.red,
                  //       );
                  //       break;
                  //     case 1:
                  //       return Icon(
                  //         Icons.star,
                  //         color: Colors.orange,
                  //       );
                  //       break;
                  //     case 2:
                  //       return Icon(
                  //         Icons.star,
                  //         color: Colors.amber,
                  //       );
                  //       break;
                  //     case 3:
                  //       return Icon(
                  //         Icons.star,
                  //         color: Colors.lightGreen,
                  //       );
                  //       break;
                  //     case 4:
                  //       return Icon(
                  //         Icons.star,
                  //         color: Colors.green,
                  //       );
                  //       break;
                  //   }
                  // },

                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
            ),
          )
        ],
      ),
      duration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          child: Stack(
        children: [
          Stack(
            children: [
              StoryView(
                onVerticalSwipeComplete: (direction) {
                  print("Swipe up");
                },
                repeat: false,
                progressPosition: ProgressPosition.top,
                controller: controller,
                storyItems: [
                  storyItemBuilder(Duration(seconds: 3)),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: SizedBox(
              //     height: 45,
              //     child: Container(
              //       color: Colors.black.withOpacity(0.3),
              //       child: Column(
              //         children: [
              //           SizedBox(
              //             height: 20,
              //             child: Icon(
              //               Icons.arrow_drop_up,
              //               size: 32,
              //               color: Colors.white,
              //             ),
              //           ),
              //           Text(
              //             "Swipe up",
              //             style: TextStyle(color: Colors.white),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      )),
    );
  }
}
