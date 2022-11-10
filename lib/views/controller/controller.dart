import 'package:app_actasalinstante/NavBar.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../RFCDescargas/SearchapiRFC/Api_service.dart';
import '../../RFCDescargas/SearchapiRFC/user_model.dart';
import '../../RFCDescargas/services/Variables.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Controller extends GetxController {
  Userlist2 _not = Userlist2();

  @override
  void initState() {
    GetNames();
  }

  String user = "";

  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = prefs.getString('username');

    print(user);
  }

  void sendNotification() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
        IO.Socket socket =
            IO.io('https://actasalinstante.com:3030/api/notify/newNotify/');

        socket.on('notification', (data) => print(data));
        socket.connect();
      }
    });

    AwesomeNotifications().createNotification(
      // Dart client

      content: NotificationContent(
          id: 1,
          channelKey: 'test_channel',
          title: user.toString() + ' Tu Pdf se descargo con exito',
          body: 'Tu Pdf se descargo con exito'),
    );

    AwesomeNotifications().actionStream.listen((event) {
      //Get.to(openfile);
    });
  }

  void error() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'test_channel',
          title: user.toString() + ' El formato de tu curp es invalido',
          body: 'Tu Curp tiene detalles'),
    );

    AwesomeNotifications().actionStream.listen((event) {
      //Get.to(openfile);
    });
  }

  void errorRFC() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'test_channel',
          title: user.toString() + ' El formato de tu RFC es invalido',
          body: 'Tu RFC tiene detalles'),
    );

    AwesomeNotifications().actionStream.listen((event) {
     // Get.to(onStart);
    });
  }

  void errorCadenaDigital() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'test_channel',
          title:
              user.toString() + ' El formato de tu Cadena Digital es invalido',
          body: 'Tu Cadena Digital tiene detalles'),
    );

    AwesomeNotifications().actionStream.listen((event) {
      //Get.to(openfile);
    });
  }
}
