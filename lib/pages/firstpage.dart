import 'package:flutter/material.dart';
import 'package:foodenie/utilities/constants.dart';
import 'package:foodenie/utilities/reusableCard.dart';
import 'package:foodenie/utilities/selectedCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//enum for all the customization options.
enum Options { veg, nonVeg, diet, snacks, sweets,beverages}

class FirstPage extends StatefulWidget {
  final weatherLocation;
  FirstPage({this.weatherLocation});
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int temperature;
  String weatherDescription;
  String cityName;

  @override
  void initState() {
    super.initState();
    updateUi(widget.weatherLocation);
  }

  void updateUi(dynamic weatherData) {
    var temp = weatherData['main']['temp'];
    temperature = temp.toInt();
    weatherDescription = weatherData['weather'][0]['description'];
    cityName = weatherData['name'];
    print(temperature);
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Weather Details"),
              content: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WeatherDetailsText(
                      item: "$temperature°C",
                      heading: "Temp: ",
                    ),
                    WeatherDetailsText(
                      item: weatherDescription,
                      heading: "Condition: ",
                    ),
                    WeatherDetailsText(
                      item: cityName,
                      heading: "City Name: ",
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  var nonVegColour = inactiveColor;
  var vegColour = inactiveColor;
  var otherColour = inactiveColor;
  var dietColour = inactiveColor;
  int weight = 60;
  int age = 19;

//for selecting either one option(either veg or non-veg)
  void colorDec(Options typeOfMeal) {
    typeOfMeal == Options.veg
        ? vegColour = colourOfCard
        : vegColour = inactiveColor;
    typeOfMeal == Options.nonVeg
        ? nonVegColour = colourOfCard
        : nonVegColour = inactiveColor;
    if (typeOfMeal == Options.diet) {
      dietColour == colourOfCard
          ? dietColour = inactiveColor
          : dietColour = colourOfCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF1F125A),
        leading: GestureDetector(
          child: Icon(Icons.wb_sunny),
          onTap: _showMaterialDialog,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorDec(Options.veg);
                      });
                    },
                    colour: Color(vegColour),
                    cardChild: GenderCard(
                      gender: 'Veg',
                      label: FontAwesomeIcons.leaf,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorDec(Options.nonVeg);
                      });
                    },
                    colour: Color(nonVegColour),
                    cardChild: GenderCard(
                      gender: 'Non-Veg',
                      label: FontAwesomeIcons.drumstickBite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorDec(Options.diet);
                      });
                    },
                    colour: Color(dietColour),
                    cardChild: GenderCard(
                      gender: 'Diet',
                      label: FontAwesomeIcons.dumbbell,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorDec(Options.snacks);
                      });
                    },
                    colour: Color(otherColour),
                    cardChild: GenderCard(
                      gender: 'Snacks',
                      label: FontAwesomeIcons.coffee,
                    ),
                  ),
                ),
              ],
            ),
          ),
           Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorDec(Options.sweets);
                      });
                    },
                    colour: Color(otherColour),
                    cardChild: GenderCard(
                      gender: 'Sweets',
                      label: FontAwesomeIcons.cookie,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorDec(Options.beverages);
                      });
                    },
                    colour: Color(otherColour),
                    cardChild: GenderCard(
                      gender: 'Beverages',
                      label: FontAwesomeIcons.glassMartini,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherDetailsText extends StatelessWidget {
  final heading;
  final item;
  WeatherDetailsText({@required this.item, @required this.heading});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(heading, style: kdialogueStyle),
        Text(item, style: kdialogueConditionText),
      ],
    );
  }
}
