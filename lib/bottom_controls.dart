import 'package:flutter/material.dart';
import 'theme.dart';
import 'dart:math';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'songs.dart';

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
              AudioPlaylistComponent(
                playlistBuilder: (BuildContext context, Playlist playlist, Widget child){
                  final songTitle= demoPlaylist.songs[playlist.activeIndex].songTitle;
                  final artistName =demoPlaylist.songs[playlist.activeIndex].artist;

                  return RichText(
                  text: TextSpan(
                    text: '',
                    children: [
                      TextSpan(
                          text: '${songTitle.toUpperCase()}\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0, //Espaciado de letras
                            height: 1.5,
                          )),
                      TextSpan(
                        text: '${artistName.toUpperCase()}',
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
                  textAlign: TextAlign.center,
                );
                },
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

//Aqui se cambia y se usa el Audio Component pues permite el uso de Widget Audio y manejar los eventos del mismo
//ya que es el boton de play y pause
  @override
  Widget build(BuildContext context) {
    return new AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayerState,
        //Aqui se actualiza el widget de audio pues el contructor se crea una sola vez
        //Si se quita este update entonces no se tiene control del boton (RawMaterialButton)
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon = Icons.music_note;
        Color buttonColor = lightAccentColor;
        Function onPressed;

        if (player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = player.pause;
          buttonColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          icon = Icons.play_arrow;
          onPressed = player.play;
          buttonColor = Colors.white;
        }

        return RawMaterialButton(
          shape: StadiumBorder(), //Forma circular
          fillColor: buttonColor, //Relleno
          splashColor: lightAccentColor, //Color Splash al pulsar el boton
          highlightColor: lightAccentColor.withOpacity(0.5),
          //Acento del color cuando llega al tope de pulsar el boton
          elevation: 20, //Para darle sombra
          highlightElevation: 5,
          //Cierta animacion de hasta donde puede elevarse
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: darkAccentColor,
              size: 35,
            ),
          ),
        );
      },
      child: Container(),
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 35,
          ),
          onPressed: playlist.previous,
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return new IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: new Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: playlist.next,
        );
      },
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
