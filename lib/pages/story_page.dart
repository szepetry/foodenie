import 'package:flutter/material.dart';
import 'package:foodenie/reccommender.dart';

import "package:story_view/story_view.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../utilities/constants.dart';

class StoryPage extends StatefulWidget {
  Map<String, dynamic> foodItem;
  StoryPage(this.foodItem);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  double get deviceHeight => MediaQuery.of(context).size.height;
  double get deviceWidth => MediaQuery.of(context).size.width;
  double rating;
  List<StoryItem> storyItemList = [];

  final StoryController controller = StoryController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  StoryItem storyItemBuilder(Duration duration, dynamic foodItem) {
    return StoryItem(
      Container(
        color: Colors.lime[100],
        child: Column(
          children: [
            Container(
              height: 20,
              color: Colors.lime,
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 1, right: 1),
                child: Container(
                  // height: deviceHeight * 0.40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                          image: NetworkImage(foodItem['link']))),
                ),
              ),
            ),
            Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 8),
                child: SizedBox(
                  width: deviceWidth,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 9,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foodItem['recipe_title'],
                                  style: TextStyle(
                                      fontSize: 25,
                                      decoration: TextDecoration.overline,
                                      decorationThickness: 2,
                                      fontWeight: FontWeight.w400),
                                )),
                            // Diet
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20.0, top: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  initialValue: foodItem['diet'],
                                  showCursor: false,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.purple[900])),
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
                              padding:
                                  const EdgeInsets.only(right: 20.0, top: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  initialValue: foodItem['course'],
                                  showCursor: false,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.purple[900])),
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
                              padding:
                                  const EdgeInsets.only(right: 20.0, top: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  initialValue: '30 + 30 mins',
                                  showCursor: false,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.purple[900])),
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
                              padding:
                                  const EdgeInsets.only(right: 20.0, top: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  initialValue: foodItem['category'],
                                  showCursor: false,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.purple[900])),
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
                              padding:
                                  const EdgeInsets.only(right: 20.0, top: 8),
                              child: SizedBox(
                                height: 50,
                                child: TextFormField(
                                  initialValue: foodItem['cuisine'],
                                  showCursor: false,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.purple[900])),
                                      // hintText: "Breakfast",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText: "Cuisine",
                                      labelStyle: TextStyle(
                                          fontSize: 20, color: Colors.black54)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          // height: 240,
                          // width: 40,
                          // alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 8, top: 30),
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
                                  default:
                                    return Container();
                                }
                              },

                              onRatingUpdate: (rating) {
                                this.rating = rating;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      duration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*   dietController.text = "Vegetarian";
    courseController.text = "Dessert";
    pctimeController.text = "30 + 30 mins";
    categoryController.text = "Sweet";
    cuisineController.text = "Indian"; */
    return SafeArea(
      child: Material(
          child: WillPopScope(
        onWillPop: () {
          if (rating != null) {
            updateRank(widget.foodItem['food_ID'], rating)
                .then((value) => null);
          }
          return Future.value(true);
        },
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
                    storyItemBuilder(Duration(seconds: 3), widget.foodItem)
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
        ),
      )),
    );
  }
}
