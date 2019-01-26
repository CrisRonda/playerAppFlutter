import 'package:flutter/material.dart';
import 'bottom_controls.dart';
import 'songs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false, //Para quitar el debug en el render
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xffdddddd),
          onPressed: () {},
        ),
        title: Text(""),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
            ),
            color: Color(0xffdddddd),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          //Expanded es un widget que usa toda la pantalla disponible
          Expanded(
            child: Center(
              child: Container(
                width: 125,
                height: 125,
                child: ClipOval(
                  clipper: CircleClipper(),
                  child: Image.network(
                    demoPlaylist.songs[0].albumArtUrl,
                    fit: BoxFit
                        .cover, //fit para usar cierto tamaño, en este caso el espacio disponible
                  ),
                ),
              ),
            ),
          ),
          //Visualizador
          Container(
            width: double.infinity,
            height: 125.0,
          ),
          //Titulo y nombre del artista y los controles
          //Aqui se cambia el Agrega MAterial para que los IconButtons tenga "animacion" al presionarlos
          //ESTO SUCEDE PORQUE APARA USAR LAS PROPIEDADES SPLAScOLOR Y HIGHTLIGHCOLOR
          //NECESITA UN PADRE QUE TENGA LAS PROPIEDADES DE MATERIAL.
          new BottomControls()
        ],
      ),
    );
  }
}

