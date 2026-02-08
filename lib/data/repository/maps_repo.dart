import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapping_app/data/models/place.dart';
import 'package:mapping_app/data/models/place_direction.dart';
import 'package:mapping_app/data/webservices/placesWebsevices.dart';

import '../models/placeSuggestions.dart';

class MapsRepository {
  final PlacesWebservices placesWebservices;

  MapsRepository(this.placesWebservices);

  Future<List<PlaceSuggestion>> fetchSuggestions(
    String place,
    String sessionToken,
  ) async {
    final suggestions = await placesWebservices.fetchSuggestions(
      place,
      sessionToken,
    );
    return suggestions
        .map((suggestions) => PlaceSuggestion.fromJson(suggestions))
        .toList();
  }

  Future<Place> getPlaceLocation(String placeId, String sessionToken) async {
    final place = await placesWebservices.getPlaceLocation(
      placeId,
      sessionToken,
    );
    return Place.fromJson(place);
  }

  Future<PlaceDirections> getDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    final directions = await placesWebservices.getDirections(
      origin,
      destination,
    );
    return PlaceDirections.fromJson(directions);
  }
}
