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

  TextEditingController dietController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController pctimeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();

  List<StoryItem> storyItemList = [];

  final StoryController controller = StoryController();

  StoryItem storyItemBuilder(Duration duration) {
    return StoryItem(
      Container(
        color: Colors.lime[100],
        child: Stack(
          children: [
            Container(
              height: 20,
              color: Colors.lime,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 1, right: 1),
              child: Container(
                height: deviceHeight * 0.40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/Kheer.jpg",
                        ))),
              ),
            ),
            Positioned(
              top: deviceHeight * 0.40 + 40,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                child: SizedBox(
                  height: deviceHeight - deviceHeight * 0.40 - 40,
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Kheer",
                            style: TextStyle(
                                fontSize: 25,
                                decoration: TextDecoration.overline,
                                decorationThickness: 2,
                                fontWeight: FontWeight.w400),
                          )),
                      // Diet
                      Padding(
                        padding: const EdgeInsets.only(right: 60.0, top: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            showCursor: false,
                            controller: dietController,
                            enabled: false,
                            decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[900])),
                                // hintText: "Breakfast",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Diet",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.black54)),
                          ),
                        ),
                      ),
                      // Course
                      Padding(
                        padding: const EdgeInsets.only(right: 60.0, top: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            showCursor: false,
                            controller: courseController,
                            enabled: false,
                            decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[900])),
                                // hintText: "Breakfast",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Course",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.black54)),
                          ),
                        ),
                      ),
                      // Prep + Cook time
                      Padding(
                        padding: const EdgeInsets.only(right: 60.0, top: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            showCursor: false,
                            controller: pctimeController,
                            enabled: false,
                            decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[900])),
                                // hintText: "Breakfast",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Prep + Cook time",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.black54)),
                          ),
                        ),
                      ),
                      // Category
                      Padding(
                        padding: const EdgeInsets.only(right: 60.0, top: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            showCursor: false,
                            controller: categoryController,
                            enabled: false,
                            decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[900])),
                                // hintText: "Breakfast",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Category",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.black54)),
                          ),
                        ),
                      ),
                      // Cuisine
                      Padding(
                        padding: const EdgeInsets.only(right: 60.0, top: 8),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            showCursor: false,
                            controller: cuisineController,
                            enabled: false,
                            decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[900])),
                                // hintText: "Breakfast",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: "Cuisine",
                                labelStyle: TextStyle(
                                    fontSize: 20, color: Colors.black54)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8,top: 300),
                child: Container(
                  height: 240,
                  width: 40,
                  alignment: Alignment.bottomRight,
                  decoration: BoxDecoration(
                    /// Rating card color
                    color: Colors.lime[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      glow: false,
                      direction: Axis.vertical,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(vertical: 4.0),
                      // itemBuilder: (context, _) => Icon(
                      //   Icons.star,

                      //   /// Star color
                      //   color: appBarColor,
                      //   size: 15,
                      // ),
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Icon(
                              Icons.star,
                              color: Colors.purple[200],
                            );
                            break;
                          case 1:
                            return Icon(
                              Icons.star,
                              color: Colors.purple[300],
                            );
                            break;
                          case 2:
                            return Icon(
                              Icons.star,
                              color: Colors.purple[400],
                            );
                            break;
                          case 3:
                            return Icon(
                              Icons.star,
                              color: Colors.purple[700],
                            );
                            break;
                          case 4:
                            return Icon(
                              Icons.star,
                              color: Colors.purple[900],
                            );
                            break;
                        }
                      },

                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      duration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    dietController.text = "Vegetarian";
    courseController.text = "Dessert";
    pctimeController.text = "30 + 30 mins";
    categoryController.text = "Sweet";
    cuisineController.text = "Indian";
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
