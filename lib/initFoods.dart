import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reccommender.dart';
import 'utilities/images_helper.dart';

class InitFoods extends StatefulWidget {
  var scrollCallback;
  InitFoods(this.scrollCallback);

  @override
  _InitFoodsState createState() => _InitFoodsState();
}

class _InitFoodsState extends State<InitFoods> {
  //AIzaSyBIKqeHx-mpDgh3PGohFssylA_XEnM1HIs,068776d7116269ea4
  Size get scSize => MediaQuery.of(context).size;
  List<Map<String, dynamic>> foods = [];
  //List<Map<String, dynamic>> dbFoods = <Map<String, dynamic>>[];
  bool isVeg;
  bool isLoading = true;
  bool isButtonLoading = false;
  List<Map<String, dynamic>> selected = [];
  List<Map<String, dynamic>> filtered = [];
  List<String> imagesAll = [];
  int count = 0;

  bool checkIfVeg(List<dynamic> userPrefs) {
    List<String> nonVegList = ['High Protein Non Vegetarian', 'Non Vegeterian'];
    for (var item in nonVegList) {
      if (userPrefs.contains(item)) {
        return false;
      }
    }
    return true;
  }

  List<Map<String, dynamic>> getVegItems(List<dynamic> userPrefs) {
    List<Map<String, dynamic>> res = [];
    List<String> nonFood = ['Snack', 'Dessert'];
    bool isSnacky = false;
    for (var itm in nonFood) {
      if (userPrefs.contains(itm)) {
        isSnacky = true;
      }
    }
    int nonFoodNum = isSnacky ? 8 : 0;
    int foodNum = isSnacky ? 12 : 20;
    for (var item in filtered) {
      String course = item['course'];
      if (nonFoodNum == 0 && foodNum == 0) break;
      if (nonFood.contains(course) &&
          userPrefs.contains(course) &&
          nonFoodNum > 0) {
        res.add(item);
        nonFoodNum--;
      } else if (!nonFood.contains(course) && foodNum > 0) {
        res.add(item);
        foodNum--;
      }
    }
    return res;
  }

  List<Map<String, dynamic>> getNonVegItems(List<dynamic> userPrefs) {
    List<Map<String, dynamic>> res = [];
    List<String> nonFood = ['Snack', 'Dessert'];
    bool isSnacky = false;
    for (var itm in nonFood) {
      if (userPrefs.contains(itm)) {
        isSnacky = true;
      }
    }
    int nonFoodNum = isSnacky ? 8 : 0;
    int vegFoodNum = isSnacky ? 3 : 5;
    int nonVegFoodNum = isSnacky ? 9 : 15;
    for (var item in filtered) {
      String course = item['course'];
      if (nonFoodNum == 0 && vegFoodNum == 0 && nonVegFoodNum == 0) break;
      if (nonFood.contains(course) &&
          userPrefs.contains(course) &&
          nonFoodNum > 0) {
        res.add(item);
        nonFoodNum--;
      } else if (!nonFood.contains(course) &&
          (vegFoodNum > 0 || nonVegFoodNum > 0)) {
        bool isVeg = checkIfVeg([item['diet']]);
        if (isVeg)
          vegFoodNum--;
        else
          nonVegFoodNum--;
        res.add(item);
      }
    }
    return res;
  }

  @override
  void initState() {
    if (!isLoading)
      setState(() {
        isLoading = true;
      });
    //var tempObj = (await user.doc(fbUid).get())
    List<dynamic> userPrefs = parseList(userObj['prefs']);
    print(userPrefs);
    this.filtered = allFoodsList.where((element) {
      String diet = element['diet'];
      if (userPrefs.contains(diet)) {
        return true;
      } else
        return false;
    }).toList();
    isVeg = checkIfVeg(userPrefs);

    if (isVeg)
      foods = getVegItems(userPrefs).map((e) => e).toList();
    else
      foods = getNonVegItems(userPrefs).map((e) => e).toList();
    /* int j = 0;
    int numNonFood = 0;
    int numVeg = 0;
    for (var i = 0; i < filtered.length; i++) {
      const veg = [
        'Vegetarian',
        'Eggetarian',
        'High Protein Vegetarian',
        'Vegan'
      ];
      bool isNonVeg = false;

      const nonFood = ['Snack', 'Dessert'];

      const nonVeg = ['High Protein Vegetarian', 'Non Vegeterian'];
      for (var item in nonVeg) {
        isNonVeg = userPrefs.contains(item);
        if (isNonVeg) break;
      }
      String dietTemp = allFoodsList.elementAt(i)['diet'];
      if (veg.contains(dietTemp) && numVeg <= 3) {
        if (isNonVeg) numVeg += 1;
        if (nonFood.contains(allFoodsList.elementAt(i)['course'])) {
          if (numNonFood <= 3) {
            numNonFood += 1;
            foods.add(allFoodsList.elementAt(i));
            j++;
          }
        } else {
          foods.add(allFoodsList.elementAt(i));
          j++;
        }
      } else if (nonVeg.contains(dietTemp)) {
        foods.add(allFoodsList.elementAt(i));
        j++;
      }
      if (j == 12) break;
    } */
    for (var i = 0; i < foods.length; i++)
      foods.elementAt(i)['selected'] = false;

    /*  FirebaseFirestore.instance
        .collection('food_items')
        .where('diet',
            whereIn: isVeg
                ? ['Vegetarian', 'High Protein Vegetarian', 'Eggetarian']
                : null /* isVeg ? ['Vegetarian', 'High Protein Vegetarian'] : null */)
        .get()
        .then((value) {
      //dbFoods = value.docs.map((e) => e.data()).toList();
     
    }); */
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  String getLink([String course]) {
    Random rand = new Random();
    if (course != null) {
      if (course.toLowerCase().contains('snack') ||
          course.toLowerCase().contains('dessert')) {
        int idx = rand.nextInt(snacks.length);
        return snacks[idx];
      }
    }
    if (isVeg) {
      int idx = rand.nextInt(vegFoods.length);
      return vegFoods[idx];
    } else {
      int idx = rand.nextInt(nonVegFoods.length);
      return nonVegFoods[idx];
    }
  }

  void getSimilar(String cuisine, String diet, String category) {
    int i = 0;
    for (var e in allFoodsList) {
      if (i <= 4) {
        if (e['cuisine'] == cuisine && e['diet'] == diet ||
            e['diet'] == diet && e['category'] == category ||
            e['cuisine'] == cuisine && e['category'] == category) {
          var temp = foods.firstWhere(
              (element) => element['food_ID'] == e['food_ID'], orElse: () {
            return {};
          });
          if (temp.isEmpty) {
            e['selected'] = false;
            foods.add(e);

            i++;
          }
          /* var temp = foods.firstWhere(
              (element) => element['food_ID'] == e['food_ID'], orElse: () {
            return {};
          });
          if (temp.isEmpty) {
            e['selected'] = false;
            e['link'] =
                "https://miro.medium.com/max/1400/1*MyAk_JfQZqzCF8qIIoWF5A.png";
            ImagesHelper().getImage(e['recipe_title']).then((value) {
              setState(() {
                e['link'] = value;
              });
            }).then((value) {
              
            });
          } */
        }
      } else {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Alata'),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.lime[100],
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purple[900],
            child: isButtonLoading
                ? Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  )
                : Text('Next'),
            onPressed: () async {
              /* await FirebaseFirestore.instance
                  .collection('food_items')
                  .doc('0DQXHIqW1KKaBEi2wyho')
                  .get()
                  .then((value) {
                print(value.data());
              }); */
              //.update({'rank': FieldValue.increment(1)});
              /* await FirebaseFirestore.instance
                  .collection('food_items')
                  .where('rank', isEqualTo: 1)
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  print(element.data());
                });
              }); */
              setState(() {
                isButtonLoading = true;
              });
              foods.forEach((element) async {
                if (element['selected'] == true) {
                  print(element['recipe_title']);

                  await updateRank(element['food_ID'], value: 5, isPrefs: true);
                }
              });
              await user.doc(fbUid).update({'isSetupDone': true});
              setState(() {
                isButtonLoading = false;
              });
              widget.scrollCallback();
            },
          ),
          body: Container(
            height: scSize.height * 0.95,
            width: scSize.width * 0.95,
            color: Colors.lime[100],
            margin: EdgeInsets.only(
                top: scSize.height * 0.02, left: scSize.width * 0.025),
            alignment: Alignment.center,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    // shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                        child: Text(
                          "Select at least 5 food items.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            // decoration: TextDecoration.overline,
                            // decorationThickness: 3,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              crossAxisCount: 2,
                            ),
                            itemCount: foods.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> item =
                                  foods.elementAt(index);
                              String name = item['recipe_title'];
                              String link = item['imageURL'];
                              int id = item['food_ID'];
                              return GestureDetector(
                                  onTap: () {
                                    /* foods.elementAt(index)['selected'] =
                                        !foods.elementAt(index)['selected']; */
                                    print(foods.elementAt(index)['selected']);

                                    getSimilar(item['cuisine'], item['diet'],
                                        item['category']);

                                    setState(() {
                                      foods.elementAt(index)['selected'] =
                                          !foods.elementAt(index)['selected'];
                                    });
                                    print(foods.elementAt(index)['selected']);
                                  },
                                  child: FoodTile(name, link,
                                      foods.elementAt(index)['selected']));
                            }),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class FoodTile extends StatelessWidget {
  String name;
  String link;
  bool isSelected;
  FoodTile(this.name, this.link, this.isSelected);

  @override
  Widget build(BuildContext context) {
    Size scSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.purple[900], width: !isSelected ? 0.5 : 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(link),
            backgroundColor: Colors.lime,
            radius: 35,
          ),
          Container(
            width: scSize.width * 0.4,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
