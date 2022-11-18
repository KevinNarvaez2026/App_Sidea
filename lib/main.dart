import 'dart:convert';
import 'dart:io';

import 'package:app_actasalinstante/NavBar.dart';
import 'package:app_actasalinstante/SplashScreen/SplashLogin_Logout.dart';
import 'package:app_actasalinstante/SplashScreen/Splashscreen1.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:app_actasalinstante/views/controller/controller_bindings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/views/homepage.dart';

import 'package:get/route_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'RFCDescargas/services/Variables.dart';

Future<void> main() async {
  json_version();
  //INICIALIZAMOS LAS CREDENCIALES 
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var email = prefs.getString('token');
  var user = prefs.getString('username');

  print(email);
  print(user);

  runApp(
      MaterialApp(home: email == null && user == null ? MyAppfull() : init()));
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
  //    runApp(MaterialApp(home: email == null ? MyAppfull() : init()));
  // });
//runApp(MaterialApp(home:  getIt<AuthModel>().token == null ? MyApp() : NavBar()));

  getIt.registerSingleton<AuthModel>(AuthModel());
//  _saveValue(getIt<AuthModel>()) async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', getIt<AuthModel>());
//         }

//         Future<String> _returnValue() async {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             final token = await prefs.getString("token");
//             return token;
//         }

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'test_channel',
      channelName: 'Test Notification',
      channelDescription: 'Notficiations for basic testing',
    )
  ]);
  runApp(MyAppfull());

  HttpOverrides.global = MyHttpOverrides();
}


json_version(){

var json = jsonEncode({
"version": "0.2.0"

});
print(json.toString());
}
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   var email = prefs.getString('token');
//   var usuario = prefs.getString('username');

//   print(email);
//    print(usuario);
//   runApp(MaterialApp(home: email == null && usuario == null ? MyAppfull() : NavBar()));
//   getIt.registerSingleton<AuthModel>(AuthModel());

// //  _saveValue(getIt<AuthModel>()) async {
// //           SharedPreferences prefs = await SharedPreferences.getInstance();
// //           await prefs.setString('token', getIt<AuthModel>());
// //         }

// //         Future<String> _returnValue() async {
// //             SharedPreferences prefs = await SharedPreferences.getInstance();
// //             final token = await prefs.getString("token");
// //             return token;
// //         }

//   AwesomeNotifications().initialize(null, [
//     NotificationChannel(
//       channelKey: 'test_channel',
//       channelName: 'Test Notification',
//       channelDescription: 'Notficiations for basic testing',
//     )
//   ]);
//   // runApp(MyApp());

//   // Dart client
//   IO.Socket socket =
//       IO.io('https://actasalinstante.com:3030/api/notify/newNotify/');

//   socket.on('notification', (data) => print(data));
//   socket.connect();
//   HttpOverrides.global = MyHttpOverrides();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((_) {
//     // runApp(new MyApp());
//   });
// }
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyAppfull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//  return MaterialApp(

//       title: 'Actas al Instante',
//       debugShowCheckedModeBanner: false,

//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         primaryColor: Colors.white,
//         floatingActionButtonTheme: FloatingActionButtonThemeData(
//           elevation: 0,
//           foregroundColor: Colors.white,
//         ),
//         accentColor: Colors.redAccent,
//         textTheme: TextTheme(
//           headline1: TextStyle(fontSize: 22.0, color: Colors.redAccent),
//           headline2: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.w700,
//             color: Colors.redAccent,
//           ),
//           bodyText1: TextStyle(
//             fontSize: 14.0,
//             fontWeight: FontWeight.w400,
//             color: Colors.blueAccent,
//           ),
//         ),
//       ),
//       home: SplashScreen(),
//     );

    return GetMaterialApp(
      initialBinding: ControllerBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        accentColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 22.0, color: Colors.black),
          headline2: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.blueAccent,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class init extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//  return MaterialApp(

//       title: 'Actas al Instante',
//       debugShowCheckedModeBanner: false,

//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         primaryColor: Colors.white,
//         floatingActionButtonTheme: FloatingActionButtonThemeData(
//           elevation: 0,
//           foregroundColor: Colors.white,
//         ),
//         accentColor: Colors.redAccent,
//         textTheme: TextTheme(
//           headline1: TextStyle(fontSize: 22.0, color: Colors.redAccent),
//           headline2: TextStyle(
//             fontSize: 24.0,
//             fontWeight: FontWeight.w700,
//             color: Colors.redAccent,
//           ),
//           bodyText1: TextStyle(
//             fontSize: 14.0,
//             fontWeight: FontWeight.w400,
//             color: Colors.blueAccent,
//           ),
//         ),
//       ),
//       home: SplashScreen(),
//     );

    return GetMaterialApp(
      initialBinding: ControllerBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        primaryColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        accentColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 22.0, color: Colors.black),
          headline2: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.blueAccent,
          ),
        ),
      ),
      home: const SplashScreen2(),
    );
  }
}
