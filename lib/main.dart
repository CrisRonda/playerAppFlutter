import 'package:flutter/material.dart';
import 'bottom_controls.dart';
import 'songs.dart';
import 'theme.dart';
import 'dart:math';
import 'package:fluttery_dart2/gestures.dart';
import 'package:fluttery_audio/fluttery_audio.dart';

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
    return Audio(
      audioUrl: demoPlaylist.songs[0].audioUrl,
      playbackState: PlaybackState.playing,
      child: Scaffold(
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
              onPressed: () {
                print("holaMundo!");
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            //Expanded es un widget que usa toda la pantalla disponible
            Expanded(
              //Aqui agregamos un Container para darle la opcion que dentro de todo el espacio vacio
              //se adelante o se atrase la cancion
              child: new AudioRadialSeekBar(),
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
      ),
    );
  }
}

class AudioRadialSeekBar extends StatefulWidget {

  @override
  AudioRadialSeekBarState createState() {
    return new AudioRadialSeekBarState();
  }
}

class AudioRadialSeekBarState extends State<AudioRadialSeekBar> {
  double _seekPercent;

  @override
  Widget build(BuildContext context) {
    return AudioComponent(
        //El updateMe revisaremos el playhead y el seeking nos da los valores para que el widget
        //RadialSeekBar vaya dibujando todo
        updateMe: [
          WatchableAudioProperties.audioPlayhead,
          WatchableAudioProperties.audioSeeking
        ],
        playerBuilder:
            (BuildContext context, AudioPlayer player, Widget child) {
          double playbackProgress = 0.0;
          if (player.audioLength != null && player.position != null) {
            playbackProgress = player.position.inMilliseconds /
                player.audioLength.inMilliseconds;
          }
          // revisamos si esta buscando(?) y se settea el valor que se necesite
          _seekPercent= player.isSeeking?_seekPercent:null; 
          return RadialSeekBar(
            progress: playbackProgress,
            seekPercent: _seekPercent,
            onSeekRequested: (double seekPercent){
             setState(()=> _seekPercent=seekPercent);
             //Valor recuperado para que se vaya actualizando al mm:ss de la cancion que queremos
             final seekMillis= (player.audioLength.inMilliseconds*seekPercent).round();
             player.seek(Duration(milliseconds: seekMillis));
            },
          );
        },
        child: new RadialSeekBar());
  }
}

class RadialSeekBar extends StatefulWidget {
  final double progress;
  final double seekPercent;
  final Function(double) onSeekRequested; //Funcion para cuando jalemos el thumb (punto)
  RadialSeekBar({
    this.seekPercent = 0.0,
    this.progress = 0.0,
    this.onSeekRequested,
  });
  @override
  RadialSeekBarState createState() {
    return new RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {
  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDreagPercent;
  double _currentDragPercent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  void _onDragStart(PolarCoord coord) {
    print("hola desde el inicio");
    _startDragCoord = coord;
    _startDreagPercent = _progress;
  }

  void _onDragUpdate(PolarCoord coord) {
    print("hola desde el update");
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);
    setState(() {
      //%sirve para poner un poner porcentaje (normalizar)
      _currentDragPercent = ((_startDreagPercent + dragPercent) % 1.0);
    });
  }

  void _onDragEnd() {
    //manejador del arrastre del tum para que la cancion continue en lo que el % que el usuario decida
    if(widget.onSeekRequested !=null){
      widget.onSeekRequested(_currentDragPercent);
    }
    print("hola desde el final");
    setState(() {
      // _progress = _currentDragPercent;
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDreagPercent = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double thumbPosition = _progress;
    if(_currentDragPercent!=null){
       thumbPosition=_currentDragPercent;
    }else if(widget.seekPercent!=null){
      thumbPosition=widget.seekPercent;
    }
    return new RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        //Es muy importante el poner el transparente pues asi se esconde el contenedor para poder arrastarar
        child: Center(
          child: Container(
            width: 200.0,
            height: 200.0,
            child: new RadialProgressBar(
              trackColor: Color(0xFFdddddd),
              progressPercent: _progress, 
              //Aqui cambiamos pues el progreso de la cancion continua reproduciondose
              progressColor: accentColor,
              thumbPosition: thumbPosition, 
              //Al jalar solo este se actualizara y jalaremos solo el thumb no elprogreso de la cancion pero se prodia hacer con los dos
              thumbColor: lightAccentColor,
              innerPadding: const EdgeInsets.all(7.0),
              outerPadding: const EdgeInsets.all(7.0),
              child: ClipOval(
                clipper: CircleClipper(),
                child: Image.network(
                  demoPlaylist.songs[1].albumArtUrl,
                  fit: BoxFit.cover,
                  //fit para usar cierto tamaño, en este caso el espacio disponible
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Esta clase se utiliza para mapear los componentes que tendra el SeekBar
//Para que sea una barra progresiva la vamos a cambiar a un RadialProgressBar
class RadialProgressBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;

  final double
      thumbPosition; //Valores para el avance de la pista y colores para esa funcion
  final Widget
      child; //Es el hijo que se dibuja dentro en este caso es la imagen del album

  RadialProgressBar({
    this.trackWidth = 5,
    this.trackColor = Colors.grey,
    this.progressWidth = 5,
    this.progressColor = Colors.black,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.progressPercent = 0.0,
    this.thumbPosition = 0.0,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });
  _RadialProgressBarState createState() => _RadialProgressBarState();
}

//Esta clase maneja los estados y ademas utiliza RadialSeekBarPainter para pintar el SeekBar
class _RadialProgressBarState extends State<RadialProgressBar> {
  //Variable para controlar que cuando la imagen del album sea grande se recorte entonces controlamos el padding
  EdgeInsets _insetsForPainter() {
    //Variable para el calculo de cual es el mas gruezo en base a eso le envia el padding correspondiente
    final maximoValor =
        max(widget.trackWidth, max(widget.progressWidth, widget.thumbSize)) / 2;
    return EdgeInsets.all(maximoValor);
  }

  @override
  Widget build(BuildContext context) {
    //Widget para crear una pintura customizada y ademas que sera una busqueda radial
    return Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        //painter --> dibuja el Paint detras del hijo que tenga para que se vea mejor y sea encima del mismo
        //se usa foregroundPainter para que se dibuje enfrente

        foregroundPainter: RadialSeekBarPainter(
            trackWidth: widget.trackWidth,
            trackColor: widget.trackColor,
            progressWidth: widget.progressWidth,
            progressColor: widget.progressColor,
            progressPercent: widget.progressPercent,
            thumbSize: widget.thumbSize,
            thumbColor: widget.thumbColor,
            thumbPosition: widget.thumbPosition),
        child: Padding(
          padding: _insetsForPainter() + widget.innerPadding,
          child: widget.child,
        ),
      ),
    );
  }
}

//Esta clase se usa para pintar la el SeekBar es por eso que usamos Paint para cada color
//Ya que cuenta con el thumb que muestra lo que falta y el progress para la pista
class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final Paint progressPaint;
  final Paint trackPaint; //pintará el avance de la cancion
  final Paint thumbPain; //Pintara un puntito para ver donde esta la cancion
  //Como a esta clase se le va a pasar los datos a pintar no es necesario settear sus valores
  //require -->es que se debe definir nada mas
  RadialSeekBarPainter({
    @required this.trackWidth,
    @required this.trackColor,
    @required this.progressWidth,
    @required this.progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required this.thumbColor,
    @required this.thumbPosition,
  })  : trackPaint = new Paint()
          ..color = trackColor
          ..style = PaintingStyle
              .stroke //Estamos dibujando el exterior del contorno (trazo) en este caso es redonda
          ..strokeWidth = trackWidth, //el ancho del contorno
        progressPaint = new Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap
              .round, //es para los bordes afilados en este caso son redondos
        thumbPain = new Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;
// esta forma de uso de .. es devolver el objeto y encadenar llmadas y devolver el valor final
  @override
  void paint(Canvas canvas, Size size) {
    //Revisa los valores mas altos para centrar bien y que nunca la imagen se salga
    final maximovalor = max(trackWidth, max(progressWidth, thumbSize));
    Size automaticSize = Size(
      size.width - maximovalor,
      size.height - maximovalor,
    );
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(automaticSize.width, automaticSize.height) / 2;
    //Pintamos la pista
    canvas.drawCircle(
        center, radius, trackPaint); //Dibuja el circulo alrededor de Oval
    //Pintar el progreso
    final progressAngle = 2 * pi * progressPercent;
    //Aqui se dibuja eñ arco al rededor del canvas anterior
    //EL ANGULO DE INICIO EN UNA CIRCUNFERENCIA DESDE ARRIBA ES -PI/2, ES CONTRARIO A LA LEY DE LA MANO DERECHA
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        progressAngle, false, progressPaint);
    //Pintando el thumb
    final thumbAngle = 2 * pi * thumbPosition -
        (pi /
            2); //Rescata el valor del angulo actual Recordar que los angulos EMPIEZAN en CERP no cumple la ley de la mano derecha
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) *
        radius; //Obtenemos los valores en X e Y para dibujar el thumb de acuerdo al teorema de pitagoras
    final thumbCenter = Offset(thumbX, thumbY) +
        center; //el centro del la imagen mas el offset que le demos para dar la perspectiva de que estaa moviendose
    final thumbRadius = thumbSize / 2;
    canvas.drawCircle(thumbCenter, thumbRadius,
        thumbPain); // Este circulo es pequeño y solo se verá la mitad, para verlo mejor aumentar thumbRadius=50
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //Siempre debe repintar
    return true;
  }
}
