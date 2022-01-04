import 'package:driver_app/page/forgot_password.dart';
import 'package:driver_app/page/home.dart';
import 'package:driver_app/page/login_page.dart';
import 'package:driver_app/page/register_page.dart';
import 'package:driver_app/translation/app_language.dart';
import 'package:driver_app/translation/app_localizations.dart';
import 'package:driver_app/utils/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'page/loading.dart';

Future<void> main() async {
  statusBarColor();
  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  const MyApp({Key? key, required this.appLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          locale: model.appLocal,
          navigatorKey: GlobalVariable.navState,
          supportedLocales: const [
            Locale('en', ''),
            Locale('zh', ''),
            Locale('ms', ''),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(color: Colors.black),
                iconTheme: IconThemeData(color: Colors.teal), //
              ),
              primarySwatch: Colors.teal,
              inputDecorationTheme: const InputDecorationTheme(
                focusColor: Colors.black,
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black26,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueGrey,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              )),
          routes: {
            '/': (context) => const LoadingPage(),
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage()
          },
        );
      }),
    );
  }
}

//Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  await Firebase.initializeApp();
//  FlutterAppBadger.updateBadgeCount(1);
//}

statusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
    statusBarBrightness: Brightness.dark, //status bar brigtness
    statusBarIconBrightness: Brightness.dark,
  ));
}
