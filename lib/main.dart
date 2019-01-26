import 'package:flutter/material.dart';
import 'theme.dart';
import 'songs.dart';
import 'dart:math';
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
                    fit: BoxFit.cover, //fit para usar cierto tamaño, en este caso el espacio disponible
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
          Container(
            color: accentColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 50),
              child: Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: '',
                      children: [
                        TextSpan(
                            text: 'Song title\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.0, //Espaciado de letras
                              height: 1.5,
                            )),
                        TextSpan(
                          text: 'Artist Name',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.0, //Espaciado de letras
                            height: 1.5,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      // Aui para que se vea simetrico usaré un expanded
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        //Boton realizado a medida con RawMAterialButton
                        RawMaterialButton(
                          shape: CircleBorder(), //Forma circular
                          fillColor: Colors.white, //Relleno
                          splashColor:
                              lightAccentColor, //Color Splash al pulsar el boton
                          highlightColor: lightAccentColor.withOpacity(
                              0.5), //Acento del color cuando llega al tope de pulsar el boton
                          elevation: 20, //Para darle sombra
                          highlightElevation:
                              5, //Cierta animacion de hasta donde puede elevarse
                          onPressed: () {
                            // TODO:
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.play_arrow,
                              color: darkAccentColor,
                              size: 35,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


// Esta clase me permitira crear un nuevo widget circular para la imagen
// circular de la caratulal del album
class CircleClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    // Rect --> Sirve para corregir un circulo
    return Rect.fromCircle(
      //Desplazamiento del ovalo Customizado, actua como una ventana que deja ver lo que se desea mas no cambia la imagen 
      center: Offset(size.width/2, size.height/2), 
      radius: min(size.width,size.height)/2,
    );
  }
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}