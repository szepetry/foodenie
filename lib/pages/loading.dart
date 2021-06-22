import 'package:flutter/material.dart';
import 'package:foodenie/weather/current_location.dart';
import 'package:foodenie/weather/network.dart';
import 'package:foodenie/pages/firstpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// apikey for weather data
const apiKey = "49470311c443d67979763092262f5e36";

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  // latitude and longitude variables.
  double latitude;
  double longitude;
  void getlocationData() async {
    CurrentLocation location = new CurrentLocation();

    await location.getCurrentLocation();

    latitude = location.latitude;
    longitude = location.longitude;

    Weather weather = Weather(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');

    await weather.getData().then((weatherData) {
      print(weatherData.runtimeType.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FirstPage(
          weatherLocation: weatherData,
        );
      }));
    });
  }

  @override
  void initState() {
    super.initState();
    getlocationData();
    // _controller = AnimationController(vsync: this);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.black,
          size: 60,
        ),
      ),
    );
  }
}
