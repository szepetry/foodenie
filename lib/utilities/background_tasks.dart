import '../api_key.dart';
import 'notifications.dart';
import 'package:foodenie/weather/network.dart';
import "package:google_maps_webservice/places.dart";
import 'package:geolocator/geolocator.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:foodenie/reccommender.dart';
import 'dart:developer';
import 'dart:async';

PlacesSearchResponse response;

final places = new GoogleMapsPlaces(apiKey: googlePlacesAPI);

const breakfastKey = "breakfastTask";
const lunchKey = "lunchTask";
const dinnerKey = "dinnerTask";
const backgroundPlacesKey = "backgroundPlacesTask";

backgroundRecommendationService() async {
  await AndroidAlarmManager.periodic(
    Duration(minutes: 1),
    1,
    Reccommend.recommend,
    startAt: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 14, 54),
  );
}

recommender() {
  print("I can run :)");
}

// void printHello() async{
//   print("dkjbkdsnkxbkuds j");
//    await NotificationService().init();

//    NotificationService().showNotification("Foodenie",
//                   "Try out ${value.results[0].name}, ${value.results[2].name} and ${value.results[3].name} in your area");

//   await recommend().then((value) => print("YEP"));
// }

callbackDispatcher() {
  print('Background Executer');
  Workmanager().executeTask((backgroundTask, data) async {
    switch (backgroundTask) {
      case backgroundPlacesKey:
        {
          double latitude;
          double longitude;
          Position lastLocation;

          await NotificationService().init();

          await Geolocator.getLastKnownPosition().then((value) {
            lastLocation = value;
            log(lastLocation.toString(), name: "Last location");
          }).then((value) async {
            await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            ).then((value) {
              latitude = value.latitude;
              longitude = value.longitude;
              log(latitude.toString(), name: "Lati");
              log(longitude.toString(), name: "Long");
            }).then((value) async {
              // print(latitude);
              // print(longitude);
              double distanceInMeters = Geolocator.distanceBetween(latitude,
                  longitude, lastLocation.latitude, lastLocation.longitude);
              print(distanceInMeters.toString() + "m");
              if (distanceInMeters > 0.000000001) {
                print("Jbdjksbdkjbdskbsd");
                await places
                    .searchNearbyWithRankBy(
                        Location(lat: latitude, lng: longitude),
                        "prominence",
                        500,
                        type: "restaurant",
                        // language: "en"
                        keyword: "restaurant")
                    .then((value) {
                  if (value.unknownError == false) {
                    for (var item in value.results) print(item.name.toString());
                    NotificationService().showNotification("Foodenie",
                        "Try out ${value.results[0].name}, ${value.results[2].name} and ${value.results[3].name} in your area");

                    log(value.status.toString(), name: "Status");
                  } else {
                    log(value.errorMessage.toString(), name: "Error message");
                    log(value.status.toString(), name: "Status");
                  }

                  response = value;
                });
              }
            });
          });
          break;
        }
    }
    ;
    return Future.value(true);
  });
}

class PlacesAPI {
  getRestaurants() async {
    double latitude;
    double longitude;
    Position lastLocation;

    await NotificationService().init();

    await Geolocator.getLastKnownPosition().then((value) {
      lastLocation = value;
      log(lastLocation.toString(), name: "Last location");
    }).then((value) async {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).then((value) {
        latitude = value.latitude;
        longitude = value.longitude;
        log(latitude.toString(), name: "Lati");
        log(longitude.toString(), name: "Long");
      }).then((value) async {
        // print(latitude);
        // print(longitude);
        double distanceInMeters = Geolocator.distanceBetween(
            latitude, longitude, lastLocation.latitude, lastLocation.longitude);
        print(distanceInMeters.toString() + "m");
        if (distanceInMeters > 0.000000001) {
          await places
              .searchNearbyWithRankBy(
                  Location(lat: latitude, lng: longitude), "prominence", 500,
                  type: "restaurant",
                  // language: "en"
                  keyword: "restaurant")
              .then((value) {
            if (value.unknownError == false) {
              for (var item in value.results) print(item.name.toString());
              NotificationService().showNotification("Foodenie",
                  "Try out ${value.results[0].name}, ${value.results[2].name} and ${value.results[3].name} in your area");

              log(value.status.toString(), name: "Status");
            } else {
              log(value.errorMessage.toString(), name: "Error message");
              log(value.status.toString(), name: "Status");
            }

            response = value;
          });
        }
      });
    });
  }

  Future<dynamic> getWeatherData() async {
    var completer = new Completer<dynamic>();

    double latitude;
    double longitude;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((location) async {
      latitude = location.latitude;
      longitude = location.longitude;
      Weather weather = Weather(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$weatherKey&units=metric');
      await weather.getData().then((weatherData) {
        completer.complete(weatherData);
      });
    });
    return completer.future;
  }
}
