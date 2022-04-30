import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/tabbar/tabbar.dart';
import 'screens/login_screen.dart';

import 'helpers/constant.dart';
import 'helpers/singleton.dart';

import 'routes/routes.dart';
import 'theme/app_theme.dart';

final ThemeData _noramlTheme = AppTheme.buildAppTheme();

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  Singleton.instance.customizationSVProgressHUD();
  Singleton.instance.hideProgress();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ),
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool(Constant.isLoggedIn) ?? false;
  if (kDebugMode) {
    print(status);
  }

  await Firebase.initializeApp();
  await setupFirebaseNotification();

  if (status == true) {
    Singleton.instance.getLoggedInUser().then((user) {
      if ((user.id ?? 0) <= 0) {
        Singleton.instance.objLoginUser = user;
        Singleton.instance.authToken =
            Singleton.instance.objLoginUser.token ?? "";
        Singleton.instance.name = Singleton.instance.objLoginUser.username!;
        Singleton.instance.userId = Singleton.instance.objLoginUser.systemId!;

        if (Singleton.instance.objLoginUser.profilePicture == null) {
          Singleton.instance.profile = "";
        } else {
          Singleton.instance.profile =
              Singleton.instance.objLoginUser.profilePicture!;
        }
        runApp(MyApp(loginStatus: status));
      } else {
        runApp(const MyApp(loginStatus: false));
      }
    });
  } else {
    runApp(const MyApp(loginStatus: false));
  }
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
bool permissionAllowed = false;
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  '10',
  'demo2_build',
  importance: Importance.high,
);

Future<void> setupFirebaseNotification() async {
  final SharedPreferences prefs = await _prefs;

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  try {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      requestPermissionss();
    }

    //Handle the background notifications (the app is termianted)
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        if (kDebugMode) {
          print("ON INITIAL MESSAGE ==> ${value.notification?.title}");
          print("ON INITIAL MESSAGE ==> ${value.notification?.body}");
        }
      }
      if (kDebugMode) {
        print("messages handleed in background $value");
      }
    });

    //Handle the notification if the app is in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      // RemoteNotification notification1 = message.data['title'];

      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        if (kDebugMode) {
          print(
              "ON ANDROID FOREGROUND MESSAGE ==> ${message.notification?.title}");
          print(
              "ON ANDROID FOREGROUND MESSAGE ==> ${message.notification?.body}");
        }

        String? title;
        String? body;
        if (Platform.isIOS) {
          title = notification.title;
          body = notification.body;
        } else if (Platform.isAndroid) {
          title = message.notification?.title;
          body = message.notification?.body;
        }

        showPushNotificationWithAlertDialog(title ?? "", body ?? "");
        if (kDebugMode) {
          print(title);
          print(body);
        }
      } else {
        if (kDebugMode) {
          print("data not available");
        }
      }
    });
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    //Handle the background notifications (the app is closed but not termianted)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
        print("ON MESSAGEOPEN APP ==> ${message.notification?.title}");
        print("ON MESSAGEOPEN APP ==> ${message.notification?.body}");
      }
    });
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print("message------ PlatformException $e");
    }
  } catch (e) {
    if (kDebugMode) {
      print("message------ Exception $e");
    }
  }

  _firebaseMessaging.getToken().then((token) {
    if (kDebugMode) {
      print("TOKEN ==> $token");
    }
    Singleton.instance.fcmToken = token ?? "";
    prefs.setString("token", token ?? "");
  });

  if (kDebugMode) {
    print(prefs.getString("token"));
  }
}

void requestPermissionss() {
  try {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        )
        .then((value) {
      if (!value!) {
        if (kDebugMode) {
          print("Please allow permission from settings");
        }
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print("===exception" + e.toString());
    }
  }
}

class MyApp extends StatelessWidget {
  final bool loginStatus;

  const MyApp({Key? key, required this.loginStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constant.appName,
      home: loginStatus
          ? const SafeArea(top: false, child: DynamicTabbedPage())
          : const SafeArea(child: LoginScreen()),
      theme: _noramlTheme,
      routes: Routes.getAll(),
      navigatorKey: navigatorKey,
    );
  }
}

void showPushNotificationWithAlertDialog(String title, String body) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (ctx) {
      return Theme(
        data: ThemeData.light(),
        child: AlertDialog(
          title: Text(
            title,
          ),
          content: Text(
            body,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Ok",
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
