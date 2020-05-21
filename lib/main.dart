import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jsonsh/splashScreen.dart';
import 'tarjetasHeroes.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  homePageState createState() => new homePageState();
}

class homePageState extends State<HomePage> {
  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/superheroes');
  }

  Future<List<dcHeroes>> _getHeroes() async {
    String jsonString = await _loadAsset();
    var jsonData = jsonDecode(jsonString);

    List<dcHeroes> heroes = [];
    for (var i in jsonData) {
      dcHeroes he = dcHeroes(i["img"], i["superheroe"], i["identidad_secreta"],
          i["edad"], i["altura"], i["genero"], i["descripcion"]);
      heroes.add(he);
    }
    return heroes;
  }

  String searchString = "";
  bool _isSearching = false;
  final searchController = TextEditingController();

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  final audioname = "audio.mp3";

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioCache = AudioCache();
    var loop = 1;

    setState(() {
      audioCache.play(audioname);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                decoration: InputDecoration(
                    hintText: "Buscando un superheroe",
                    icon: Icon(Icons.search)),
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                  });
                },
                controller: searchController,
              )
            : Text("Superheroes"),
        actions: <Widget>[
          !_isSearching
              ? IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      searchString = "";
                      this._isSearching = !this._isSearching;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this._isSearching = !this._isSearching;
                    });
                  },
                )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: FutureBuilder(
            future: _getHeroes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Cargando..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data[index].superheroe
                            .contains(searchString)
                        ? ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data[index].img.toString()),
                            ),
                            title: Text(snapshot.data[index].superheroe
                                .toString()
                                .toUpperCase()),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MostrarTarjetas(
                                          snapshot.data[index])));
                            },
                          )
                        : Container();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class dcHeroes {
  final String img;
  final String superheroe;
  final String identidad_secreta;
  final String edad;
  final String altura;
  final String genero;
  final String descripcion;

  dcHeroes(this.img, this.superheroe, this.identidad_secreta, this.edad,
      this.altura, this.genero, this.descripcion);
}
