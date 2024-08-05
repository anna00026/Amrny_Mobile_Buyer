import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:qixer/service/notifier_providers.dart';
import 'package:qixer/service/rtl_service.dart';
import 'package:qixer/themes/default_themes.dart';
import 'package:qixer/view/home/homepage_helper.dart';
import 'package:qixer/view/intro/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  await Firebase.initializeApp();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('icon'),
    ),
    // onDidReceiveBackgroundNotificationResponse: (_) {},
    // onDidReceiveNotificationResponse: (_) {},
  );
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidImplementation?.requestPermission();
  await HomepageHelper().locationPermissionCheck();

  runApp(const MyApp());

//get user id, so that we can clear everything cached by provider when user logs out and logs in again
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getInt('userId');
}

int? userId;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
      key: ObjectKey(userId),
      providers: NotifierProviders.getNotifierProviders(),
      child: Consumer<RtlService>(
        builder: (context, rtlProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Qixer',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale(rtlProvider.langSlug.substring(0, 2)),
              const Locale('en', "US")
            ],
            builder: (context, rtlchild) {
              return Consumer<RtlService>(
                builder: (context, rtlP, child) => Directionality(
                  textDirection: rtlP.direction == 'ltr'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: rtlchild!,
                ),
              );
            },
            theme: ThemeData(
              primarySwatch: Colors.blue,
              appBarTheme: DefaultThemes().appBarTheme(context),
              inputDecorationTheme:
                  DefaultThemes().inputDecorationTheme(context),
              outlinedButtonTheme: DefaultThemes().outlinedButtonTheme(context),
              elevatedButtonTheme: DefaultThemes().elevatedButtonTheme(context),
              dropdownMenuTheme: DefaultThemes().dropdownMenuTheme(),
            ),
            home: child,
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}
