
import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {

  const PlayPage({super.key, required this.text});

  final String text;


  @override
  State<StatefulWidget> createState() {
    return _PlayPageState();
  }

}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    return Scaffold(
      body: Text("play page $text"),
    );
  }

}