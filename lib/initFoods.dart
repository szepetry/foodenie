import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reccommender.dart';

class InitFoods extends StatefulWidget {
  var scrollCallback;
  InitFoods(this.scrollCallback);

  @override
  _InitFoodsState createState() => _InitFoodsState();
}

class _InitFoodsState extends State<InitFoods> {
  //AIzaSyBIKqeHx-mpDgh3PGohFssylA_XEnM1HIs,068776d7116269ea4
  Size get scSize => MediaQuery.of(context).size;
  List<Map<String, dynamic>> foods = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> dbFoods = <Map<String, dynamic>>[];
  bool isVeg = false;
  bool isLoading = true;
  bool isButtonLoading = false;
  List<Map<String, dynamic>> selected = [];
  @override
  void initState() {
    if (!isLoading)
      setState(() {
        isLoading = true;
      });

    FirebaseFirestore.instance
        .collection('food_items')
        .where('diet',
            whereIn: isVeg
                ? ['Vegetarian', 'High Protein Vegetarian', 'Eggetarian']
                : null /* isVeg ? ['Vegetarian', 'High Protein Vegetarian'] : null */)
        .get()
        .then((value) {
      dbFoods = value.docs.map((e) => e.data()).toList();
      setState(() {
        foods.addAll(dbFoods.getRange(0, 6));
        for (var i = 0; i < foods.length; i++) {
          foods[i]['selected'] = false;
          foods[i]['link'] = getLink(foods[i]['course']);
        }
      });
    });
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
    for (var e in dbFoods) {
      if (i <= 2) {
        if (e['cuisine'] == cuisine && e['diet'] == diet ||
            e['diet'] == diet && e['category'] == category ||
            e['cuisine'] == cuisine && e['category'] == category) {
          var temp = foods.firstWhere(
              (element) => element['food_ID'] == e['food_ID'], orElse: () {
            return {};
          });
          if (temp.isEmpty) {
            e['selected'] = false;
            e['link'] = getLink(e['course']);
            foods.add(e);
            i++;
          }
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
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
                  await updateRank(element['food_ID']);
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
            margin: EdgeInsets.only(
                top: scSize.height * 0.02, left: scSize.width * 0.025),
            alignment: Alignment.center,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      crossAxisCount: 2,
                    ),
                    itemCount: foods.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> item = foods[index];
                      String name = item['recipe_title'];
                      String link = foods[index]['link'];
                      int id = item['food_ID'];
                      return GestureDetector(
                          onTap: () {
                            getSimilar(foods[index]['cuisine'],
                                foods[index]['diet'], foods[index]['category']);
                            setState(() {});
                            setState(() {
                              foods[index]['selected'] =
                                  !foods[index]['selected'];
                            });
                          },
                          child:
                              FoodTile(name, link, foods[index]['selected']));
                    }),
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
            color: Colors.green[200], width: !isSelected ? 0.5 : 2.0),
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
