import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/initFoods.dart';
import 'reccommender.dart';

class HomePage extends StatefulWidget {
  final Auth auth;
  const HomePage(this.auth);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size get getScreenSize => MediaQuery.of(context).size;
  Auth get auth => widget.auth;
  List<Map<String, dynamic>> popUpMenuItems = [
    {"option": "Signout"}
  ];
  //var foodIds;

  @override
  void initState() {
    //FirebaseFirestore.instance.collection("food_items").get().then((value) => foodIds=value);
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
                Container(
                  margin: EdgeInsets.only(top: getScreenSize.height * 0.04),
                  width: getScreenSize.width * 0.4,
                  height: getScreenSize.width * 0.4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.blue[200], Colors.blue]),
                    borderRadius: BorderRadius.all(
                      Radius.circular(200),
                    ),
                  ),
                  child: Text('Hot n cool',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                TextButton(
                    onPressed: () async {
                      /* String token = await FirebaseAuth.instance.currentUser
                          .getIdToken(true); */
                      // await getRequest('recommend?foodId=60');
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => InitFoods()));
                    },
                    child: Text('tst'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
