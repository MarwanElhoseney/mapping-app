import 'package:mapping_app/data/models/place.dart';
import 'package:mapping_app/data/models/placeSuggestions.dart';
import 'package:mapping_app/data/models/place_direction.dart';

class MapsState {}

class MapsInitial extends MapsState {}

class PlacesLoaded extends MapsState {
  final List<PlaceSuggestion> places;

  PlacesLoaded(this.places);
}

class PlaceLocationLoaded extends MapsState {
  final Place place;

  PlaceLocationLoaded(this.place);
}

class DirectionLoaded extends MapsState {
  final PlaceDirections placeDirections;

  DirectionLoaded(this.placeDirections);
}
