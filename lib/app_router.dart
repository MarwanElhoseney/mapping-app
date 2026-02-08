import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapping_app/business__logic/cubit/maps/maps_cubit.dart';
import 'package:mapping_app/business__logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:mapping_app/constants/strings.dart';
import 'package:mapping_app/data/repository/maps_repo.dart';
import 'package:mapping_app/data/webservices/placesWebsevices.dart';
import 'package:mapping_app/presention/screens/login_screen.dart';
import 'package:mapping_app/presention/screens/map_screen.dart';
import 'package:mapping_app/presention/screens/otp_screen.dart';

class AppRouter {
  final PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: phoneAuthCubit),
                  BlocProvider(
                    create:
                        (_) => MapsCubit(MapsRepository(PlacesWebservices())),
                  ),
                ],
                child: MapScreen(),
              ),
        );

      case loginScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider<PhoneAuthCubit>.value(
                value: phoneAuthCubit,
                child: LoginScreen(),
              ),
        );

      case otpScreen:
        final phoneNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider<PhoneAuthCubit>.value(
                value: phoneAuthCubit,
                child: OtpScreen(phoneNumber: phoneNumber),
              ),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No Route Found'))),
        );
    }
  }
}
