import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapping_app/constants/strings.dart';

class PlacesWebservices {
  late Dio dio;

  PlacesWebservices() {
    BaseOptions options = BaseOptions(
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> fetchSuggestions(
    String place,
    String sessionToken,
  ) async {
    try {
      Response response = await dio.get(
        baseUrlSuggestions,
        queryParameters: {
          "input": place,
          "types": "address",
          "components": "country.eg",
          "key": googleApiKey,
          "sessionToken": sessionToken,
        },
      );

      return response.data["predictions"];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        baseUrlSuggestions,
        queryParameters: {
          "place_id": placeId,
          "fields": "geometry",
          "key": googleApiKey,
          "sessionToken": sessionToken,
        },
      );

      return response.data;
    } catch (error) {
      print(error.toString());
      return Future.error(
        "place location error :",
        StackTrace.fromString(("this is trace")),
      );
    }
  }

  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(
        directionsBaseUrl,
        queryParameters: {
          "origin": "${origin.latitude}.${origin.longitude}",
          "destination": "${destination.latitude}.${destination.longitude}",
          "key": googleApiKey,
        },
      );

      return response.data;
    } catch (error) {
      print(error.toString());
      return Future.error(
        "place location error :",
        StackTrace.fromString(("this is trace")),
      );
    }
  }
}
