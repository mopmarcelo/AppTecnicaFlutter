import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdi_marcelo/model/store_model.dart';
import 'package:pdi_marcelo/model/user_model.dart';
import 'package:pdi_marcelo/pages/card_store.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'pages/login_page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  //HttpOverrides.global = new MyHttpOverrides();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            return ScopedModel<StoreModel>(
              model: StoreModel(model),
              child: MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate
                ],
                supportedLocales: [
                  const Locale('pt'),
                ],
                title: 'PDI Marcelo',
                theme: ThemeData(
                  hintColor: Colors.grey,
                  backgroundColor: Colors.white,
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141),
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    labelStyle: TextStyle(color: Colors.grey),
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixStyle: TextStyle(color: Colors.grey, fontSize: 25),
                  ),
                ),
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor: Colors.white,
                  body: LoginPage(),
                ),
              ),
            );
          },
        )
    );
  }
}
