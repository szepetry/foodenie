import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class MealTimings extends StatefulWidget {
  final bool recall;
  final scrollCallback;
  const MealTimings(this.scrollCallback, {Key key, this.recall = false})
      : super(key: key);

  @override
  _MealTimingsState createState() => _MealTimingsState();
}

class _MealTimingsState extends State<MealTimings> {
  TimeOfDay breakfast = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay lunch = TimeOfDay(hour: 13, minute: 0);
  TimeOfDay dinner = TimeOfDay(hour: 20, minute: 0);

  TextEditingController breakfastController = TextEditingController();
  TextEditingController lunchController = TextEditingController();
  TextEditingController dinnerController = TextEditingController();

  bool get recall => widget.recall;

  @override
  void initState() {
    checkTimings();
    super.initState();
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

  _saveTimings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('breakfastHour', breakfast.hour);
    await prefs.setInt('breakfastMinute', breakfast.minute);
    await prefs.setInt('lunchHour', lunch.hour);
    await prefs.setInt('lunchMinute', lunch.minute);
    await prefs.setInt('dinnerHour', dinner.hour);
    await prefs.setInt('dinnerMinute', dinner.minute);
  }

  void _selectTime(TimeOfDay time, {String type}) async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (newTime != null) {
      if (type == "breakfast") {
        // Breakfast
        setState(() {
          breakfast = newTime;
          breakfastController.text = newTime.format(context);
        });
      } else if (type == "lunch") {
        // Lunch
        setState(() {
          lunch = newTime;
          lunchController.text = newTime.format(context);
        });
      } else {
        // Dinner
        setState(() {
          dinner = newTime;
          dinnerController.text = newTime.format(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    breakfastController.text = breakfast.format(context);
    lunchController.text = lunch.format(context);
    dinnerController.text = dinner.format(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.lime,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.lime[100],
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                    child: Text(
                      "Meal Timings",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        // decoration: TextDecoration.overline,
                        // decorationThickness: 3,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: GestureDetector(
                      onTap: () {
                        _selectTime(breakfast, type: "breakfast");
                      },
                      child: TextField(
                        showCursor: false,
                        controller: breakfastController,
                        enabled: false,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple[900])),
                            // hintText: "Breakfast",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Breakfast",
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.black54)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: GestureDetector(
                      onTap: () {
                        _selectTime(lunch, type: "lunch");
                      },
                      child: TextField(
                        enabled: false,
                        showCursor: false,
                        controller: lunchController,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.purple[900])),

                          // hintText: "Breakfast",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Lunch",
                          labelStyle:
                              TextStyle(fontSize: 20, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: GestureDetector(
                      onTap: () {
                        _selectTime(dinner, type: "dinner");
                      },
                      child: TextField(
                        showCursor: false,
                        enabled: false,
                        controller: dinnerController,
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple[900])),

                            // hintText: "Breakfast",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Dinner",
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.black54)),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        _saveTimings().then((val) async {
                          print("Saved timings");
                          if (recall == true)
                            Navigator.pop(context);
                          else
                            await widget.scrollCallback();
                        });
                      },
                      child: Text(
                        "done",
                        style:
                            TextStyle(color: Colors.purple[900], fontSize: 16),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
