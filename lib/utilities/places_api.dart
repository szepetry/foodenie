import 'package:flutter/material.dart';

import '../api_key.dart';
import '../weather/current_location.dart';
import '../utilities/notifications.dart';

import "package:google_maps_webservice/places.dart";
import 'package:geolocator/geolocator.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:developer';

PlacesSearchResponse response;

final places = new GoogleMapsPlaces(apiKey: googlePlacesAPI);

getRestaurantsBackgroundService() {
  print('Instant Report Executer');
  Workmanager().executeTask((backgroundTask, data) async {
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
          print("Jbdjksbdkjbdskbsd");
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
}
