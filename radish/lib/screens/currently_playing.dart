import 'package:flutter/material.dart';

class CurrentlyPlaying extends StatefulWidget {
  const CurrentlyPlaying({Key? key}) : super(key: key);

  @override
  State<CurrentlyPlaying> createState() => _CurrentlyPlayingState();
}

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Text(
                      'Currently playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14)
                    ),
                    Text(
                      "Absolute Radio",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)
                    ),
                  ],
                )
              ),
              Expanded(
                flex: 2, 
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(60, 0, 60, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          'https://i.scdn.co/image/ab67616d00001e029b95ca5babfa8f869f87e026',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          'Innocent',
                          style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold)
                        ),
                        Text(
                          'Mike Oldfield',
                          style: TextStyle(color: Colors.grey, fontSize: 18)
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.stop_rounded,
                      color: Colors.grey,
                      size: 36,
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white10,
                      size: 60,
                    ),
                    Icon(
                      Icons.keyboard_control,
                      color: Colors.grey,
                      size: 36,
                    )
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }
}