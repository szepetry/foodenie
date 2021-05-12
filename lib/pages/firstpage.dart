import 'package:flutter/material.dart';
import 'package:foodenie/utilities/constants.dart';
import 'package:foodenie/utilities/reusableCard.dart';
import 'package:foodenie/utilities/selectedCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



List<String> itemNames = [
  'veg',
  'nonVeg',
  'diet',
  'snacks',
  'sweets',
  'beverages'
];

Map<String, Color> colorOfItem = {
  'veg': normalColor,
  'nonVeg': normalColor,
  'diet': normalColor,
  'snacks': normalColor,
  'sweets': normalColor,
  'beverages': normalColor,
};

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
  void colorActivityOfCard(String item) {
    if (item == 'veg' || item == 'nonVeg') {
      item == 'veg'
          ? colorOfItem['veg'] = activeColor
          : colorOfItem['veg'] = normalColor;

      item == 'nonVeg'
          ? colorOfItem['nonVeg'] = activeColor
          : colorOfItem['nonVeg'] = normalColor;
    } else {
      colorOfItem[item] == activeColor
          ? colorOfItem[item] = normalColor
          : colorOfItem[item] = activeColor;
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
                        colorActivityOfCard('veg');
                      });
                    },
                    colour: colorOfItem['veg'],
                    cardChild: ItemCard(
                      item: 'Veg',
                      label: FontAwesomeIcons.leaf,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorActivityOfCard('nonVeg');
                      });
                    },
                    colour: colorOfItem['nonVeg'],
                    cardChild: ItemCard(
                      item: 'Non-Veg',
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
                         colorActivityOfCard('diet');
                      });
                    },
                    colour: colorOfItem['diet'],
                    cardChild: ItemCard(
                      item: 'Diet',
                      label: FontAwesomeIcons.dumbbell,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorActivityOfCard('snacks');
                      });
                    },
                    colour: colorOfItem['snacks'],
                    cardChild: ItemCard(
                      item: 'Snacks',
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
                        colorActivityOfCard('sweets');
                      });
                    },
                    colour: colorOfItem['sweets'],
                    cardChild: ItemCard(
                      item: 'Sweets',
                      label: FontAwesomeIcons.cookie,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        colorActivityOfCard('beverages');
                      });
                    },
                    colour: colorOfItem['beverages'],
                    cardChild: ItemCard(
                      item: 'Beverages',
                      label: FontAwesomeIcons.glassMartini,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomButton(
            title: 'Submit',
            ontap: () {
              setState(() {
                List<String> selectedName = [];
                for (int i = 0; i < colorOfItem.length; i++) {
                  if (colorOfItem[itemNames[i]] == activeColor) {
                    selectedName.add(itemNames[i]);
                  }
                }
              // print(colorOfItem.containsValue(activeColor));
                print(selectedName);
              });
            },
          ),
        ],
      ),
    );
  }
}

//for the weather info
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

//a customized button for submitting the selected items.
class BottomButton extends StatelessWidget {
  final Function ontap;
  final String title;
  BottomButton({@required this.ontap, @required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: kLargeButtonTextStyle,
            )
          ],
        ),
        color: Color(0XFF1F125A),
        margin: EdgeInsets.only(top: 4),
        width: double.infinity,
        height: containerHeight,
      ),
    );
  }
}
