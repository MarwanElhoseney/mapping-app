import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapping_app/business__logic/cubit/maps/maps_cubit.dart';
import 'package:mapping_app/business__logic/cubit/maps/maps_state.dart';
import 'package:mapping_app/business__logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:mapping_app/constants/my_colors.dart';
import 'package:mapping_app/data/models/place.dart';
import 'package:mapping_app/data/models/placeSuggestions.dart';
import 'package:mapping_app/data/models/place_direction.dart';
import 'package:mapping_app/helpers/location_helper.dart';
import 'package:mapping_app/presention/widgets/distance_and_time.dart';
import 'package:mapping_app/presention/widgets/my_drawer.dart';
import 'package:mapping_app/presention/widgets/place_item.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();

  List<PlaceSuggestion> places = [];

  static Position? position;
  final Completer<GoogleMapController> _mapController = Completer();

  static CameraPosition get _myCurrentLocationCameraPosition => CameraPosition(
    bearing: 0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0,
    zoom: 17,
  );

  Set<Marker> markers = Set();
  late PlaceSuggestion placeSuggestion;
  late Place selectedPlace;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition goToSearchedPlace;

  void buildCameraNewPosition() {
    goToSearchedPlace = CameraPosition(
      bearing: 0,
      tilt: 0,
      target: LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
      zoom: 13,
    );
  }

  PlaceDirections? placeDirections;
  late List<LatLng> polylinePoints;
  var progressIndicator = false;
  var isSearchedPlaceMarkerClicked = false;
  var isTimeAndDistanceVisible = false;
  late String time;
  late String distance;

  @override
  void initState() {
    super.initState();
    getMyCurrentLocation();
  }

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation();
    setState(() {});
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: markers,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      polylines:
          placeDirections != null
              ? {
                Polyline(
                  polylineId: const PolylineId("my_polyline"),
                  color: Colors.black,
                  width: 2,
                  points: polylinePoints,
                ),
              }
              : {},
    );
  }

  Future<void> goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition),
    );
  }

  void getPlacesSuggestion(String query) {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<MapsCubit>(
      context,
    ).emitPlaceSuggestions(query, sessionToken);
  }

  /// 🔍 Search Box
  Widget buildSearchField() {
    return Positioned(
      top: 50,
      left: 70,
      right: 20,

      child: Column(
        children: [
          Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Find a place",

                prefixIcon: Icon(Icons.search, color: MyColors.blue),
                border: InputBorder.none,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  getPlacesSuggestion(value);
                }
              },
            ),
          ),
          buildSuggestionsBloc(),
          buildSelectedPlaceLocationBloc(),
          buildDirectionBloc(),
        ],
      ),
    );
  }

  Widget buildDirectionBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is DirectionLoaded) {
          placeDirections = (state).placeDirections;

          getPolylinePoints();
        }
      },
      child: Container(),
    );
  }

  void getPolylinePoints() {
    polylinePoints =
        placeDirections!.polylinePoints
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList();
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<MapsCubit, MapsState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = (state).place;

          goToMySearchedForLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  void getDirections() {
    BlocProvider.of<MapsCubit>(context).emitPlaceDirections(
      LatLng(position!.latitude, position!.longitude),
      LatLng(
        selectedPlace.result.geometry.location.lat,
        selectedPlace.result.geometry.location.lng,
      ),
    );
  }

  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(goToSearchedPlace));
    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: goToSearchedPlace.target,
      markerId: MarkerId("1"),
      onTap: () {
        buildCurrentLocationMarker();
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isTimeAndDistanceVisible = true;
        });
      },
      infoWindow: InfoWindow(title: "${placeSuggestion.description}"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkerAndUpdateUI(searchedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      position: LatLng(position!.latitude, position!.longitude),
      markerId: MarkerId("2"),
      onTap: () {},
      infoWindow: InfoWindow(title: "your current location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkerAndUpdateUI(currentLocationMarker);
  }

  void addMarkerToMarkerAndUpdateUI(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  /// ☰ Drawer Button
  Widget buildDrawerButton() {
    return Positioned(
      top: 50,
      left: 20,
      child: Material(
        elevation: 6,
        shape: const CircleBorder(),
        color: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.menu),
          color: MyColors.blue,
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
    );
  }

  Widget buildSuggestionsBloc() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is PlacesLoaded && state.places.isNotEmpty) {
          places = state.places;
          return buildPlaceList();
        }
        return Container();
      },
    );
  }

  Widget buildPlaceList() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        itemCount: places.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: () async {
              placeSuggestion = places[index];
              FocusScope.of(context).unfocus();
              getSelectedPlaceLocation();
              polylinePoints.clear();
              removeAllMarkersAndUpdateUI();
            },
            child: PlaceItem(suggestion: places[index]),
          );
        },
      ),
    );
  }

  void removeAllMarkersAndUpdateUI() {
    setState(() {
      markers.clear();
    });
  }

  void getSelectedPlaceLocation() {
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(
      context,
    ).emitPlaceLocation(placeSuggestion.placeId, sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: Stack(
        children: [
          position != null
              ? buildMap()
              : const Center(child: CircularProgressIndicator()),
          buildDrawerButton(),
          buildSearchField(),
          isSearchedPlaceMarkerClicked
              ? DistanceAndTime(
                isTimeAndDistanceVisible: isTimeAndDistanceVisible,
                placeDirections: placeDirections,
              )
              : Container(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          onPressed: goToMyCurrentLocation,
          backgroundColor: MyColors.blue,
          child: const Icon(Icons.place, color: Colors.white),
        ),
      ),
    );
  }
}
