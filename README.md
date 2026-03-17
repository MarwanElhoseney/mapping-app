#  Mapping App (Flutter)

A Flutter application that provides **Google Maps integration**, **place search**, **directions**, and **phone authentication using Firebase**.  
The app allows users to search for places, view routes, distance & duration, and authenticate securely using OTP.

---

##  Features

-  Phone Authentication using **Firebase OTP**
-  Google Maps integration
-  Place search with **Google Places Autocomplete**
-  Get place location details
-  Directions between two locations
-  Display **distance & estimated time**
-  Custom markers & polylines
-  Clean architecture using **Bloc (Cubit)**
-  Get current location using Geolocator

---

##  Project Architecture

lib/
├── business__logic/
│ └── cubit/
│ ├── maps/
│ └── phone_auth/
├── constants/
│ ├── my_colors.dart
│ └── strings.dart
├── data/
│ ├── models/
│ ├── repository/
│ └── webservices/
├── helpers/
├── presention/
│ ├── screens/
│ └── widgets/
├── app_router.dart
└── main.dart

![Image Alt](https://github.com/MarwanElhoseney/mapping-app/blob/4e05185ca7b8759b9ff1f5e075ecb99439ebb25c/images.jpeg)


