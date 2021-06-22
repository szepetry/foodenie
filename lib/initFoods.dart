import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'reccommender.dart';

class InitFoods extends StatefulWidget {
  const InitFoods();

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

  List<String> vegFoods = <String>[
    'https://media.easemytrip.com/media/Blog/India/636977607425696252/636977607425696252QYiiUU.jpg',
    'https://pbs.twimg.com/media/ETsKy9VVAAAm21Q.jpg',
    'https://www.hungryforever.com/wp-content/uploads/2015/03/Featured-image-vegetarian-restaurants-in-bangalore.jpg',
    'http://www.dineout.co.in/blog/wp-content/uploads/2019/08/sun-planet.jpg',
    'https://www.golokaso.com/wp-content/uploads/2018/05/veg-food-cover.jpg',
    'https://i.ytimg.com/vi/Q7PK8Wy8Sgk/maxresdefault.jpg',
    'https://qph.fs.quoracdn.net/main-qimg-678706e348c1e929cece3e5a259e7638',
    'https://img.taste.com.au/qwRsc_iL/w720-h480-cfill-q80/taste/2018/06/july-18_indian-style-potatoes-138753-1.jpg',
    'https://curlytales.com/wp-content/uploads/2017/08/veg_food-e1502966998573-1280x720.jpg',
    'https://goa-casitas.com/wp-content/uploads/2019/09/Jalsa.jpg'
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
    'https://bakerbynature.com/wp-content/uploads/2011/05/Tropical-Smoothie-1234567-1-of-1.jpg'
  ];

  String getLink([String course]) {
    Random rand = new Random();
    if (course == 'Snack' || course == 'Dessert') {
      int idx = rand.nextInt(snacks.length);
      return snacks[idx];
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
            e['link'] = getLink();
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
              setState(() {
                isButtonLoading = false;
              });
              Navigator.of(context).pop();
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
