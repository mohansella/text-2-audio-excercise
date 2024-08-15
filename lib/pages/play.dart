import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key, required this.text});

  final String text;

  @override
  State<StatefulWidget> createState() {
    return _PlayPageState();
  }
}

class _ExcerciseEntry {
  const _ExcerciseEntry({required this.name, required this.seconds, required this.repeats, required this.interval});
  final String name;
  final int interval;
  final int seconds;
  final int repeats;
}

class _PlayPageState extends State<PlayPage> {
  int lineNumber = 0;
  List<_ExcerciseEntry> entries = [];

  @override
  void initState() {
    _parse();
    super.initState();
  }

  void _parse() {
    var text = widget.text;
    text.split("\n").forEach((line) {
      line = line.trim();
      if (line != "") {
        var regx = RegExp(r'^(?:(\d+)r\s+)?(?:(\d+)s\s+)?(?:(\d+)i\s+)?(.+?)$');
        var match = regx.matchAsPrefix(line);
        if(match != null) {
          try {
            int repeats = int.tryParse(match[1] ?? "1") ?? 1;
            int seconds = int.tryParse(match[2] ?? "10") ?? 10;
            int interval = int.tryParse(match[3] ?? "10") ?? 10;
            String name = match[4]!;
            entries.add(_ExcerciseEntry(repeats: repeats, seconds: seconds, interval: interval, name: name));
          } catch(err) {
            debugPrint("error while parsing the line:$line error:$err");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("excercises found: ${entries.length}"),
    );
  }
}
