import 'package:flutter/material.dart';
import 'theme.dart';
import 'dart:math';
class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
        shadowColor: Colors.green,
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
                    new PreviousButton(),
                    Expanded(
                      child: Container(),
                    ),
                    //Boton realizado a medida con RawMAterialButton
                    new PlayPauseButton(),
                    Expanded(
                      child: Container(),
                    ),
                    new NextButton(),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
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
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: Icon(
        Icons.skip_previous,
        color: Colors.white,
        size: 40,
      ),
      onPressed: () {},
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      icon: Icon(
        Icons.skip_next,
        color: Colors.white,
        size: 40,
      ),
      onPressed: () {},
    );
  }
}

// Esta clase me permitira crear un nuevo widget circular para la imagen
// circular de la caratulal del album
class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    // Rect --> Sirve para corregir un circulo
    return Rect.fromCircle(
      //Desplazamiento del ovalo Customizado, actua como una ventana que deja ver lo que se desea mas no cambia la imagen
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
