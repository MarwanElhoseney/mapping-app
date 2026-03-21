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
![Image](https://github.com/user-attachments/assets/f101a2c6-8b56-4e94-be5a-49a3138fc391)



