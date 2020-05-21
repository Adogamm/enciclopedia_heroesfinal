import 'package:flutter/material.dart';
import 'package:jsonsh/main.dart';
import 'package:splashscreen/splashscreen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SplashScreen(
        title: Text(
          "Cargando...",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        photoSize: 120,
        seconds: 5,
        backgroundColor: Colors.blueGrey,
        image: Image.network(
            'https://e00-marca.uecdn.es/promociones/dccomics/images/superheroes.png?crc=4225367149'),
        navigateAfterSeconds: HomePage());
  }
}
