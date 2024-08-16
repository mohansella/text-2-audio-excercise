import 'package:flutter/material.dart';
import 'package:text_2_audio_excercise/utils/notify.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key, required this.text});

  final String text;

  @override
  State<StatefulWidget> createState() {
    return _PlayPageState();
  }
}

class _PlayPageState extends State<PlayPage> {
  int currExcerciseNum = 0;
  int round = 0;
  List<_ExcerciseEntry> excercises = [];
  bool isPlaying = false;
  bool isRest = false;
  int uniqueId = 0;

  _ExcerciseEntry get currExcercise {
    return excercises[currExcerciseNum];
  }

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
        if (match != null) {
          try {
            int repeats = int.tryParse(match[1] ?? "1") ?? 1;
            int seconds = int.tryParse(match[2] ?? "10") ?? 10;
            int interval = int.tryParse(match[3] ?? "10") ?? 10;
            String name = match[4]!;
            excercises.add(_ExcerciseEntry(
                rounds: repeats,
                duration: seconds,
                interval: interval,
                name: name));
          } catch (err) {
            debugPrint("error while parsing the line:$line error:$err");
          }
        }
      }
    });
  }

  bool emptyNotified = false;
  Future<void> _notifyEmpty(BuildContext context) async {
    if (emptyNotified) {
      return;
    }
    emptyNotified = true;
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      NotifyUtil.notifyInfo(context, "No valid inputs found");
    }
    await Future.delayed(const Duration(milliseconds: 2000));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _back() async {
    debugPrint("back clicked");
    setState(() {
      uniqueId++;
      isPlaying = false;
      isRest = false;
      round = 0;
      if (currExcerciseNum > 0) {
        currExcerciseNum--;
      }
    });
  }

  Future<void> _next() async {
    debugPrint("back clicked");
    setState(() {
      uniqueId++;
      isPlaying = false;
      isRest = false;
      round = 0;
      if (currExcerciseNum + 1 < excercises.length) {
        currExcerciseNum++;
      }
    });
  }

  Future<void> _playpause(BuildContext context) async {
    debugPrint("playpause clicked");
    uniqueId++;
    if (isPlaying) {
      setState(() {
        isPlaying = false;
      });
    } else {
      setState(() {
        isPlaying = true;
      });
      var currId = uniqueId;

      try {
        for (int i = currExcerciseNum; i < excercises.length; i++) {
          await _say(currExcercise.name, currId);
          for (int j = round; j < currExcercise.rounds; j++) {
            if (currId == uniqueId) {
              setState(() {
                round = j;
              });
            }
            var said = _say("round ${j + 1}", currId);
            await Future.delayed(Duration(seconds: currExcercise.duration));
            await said;
            said = _say("rest", currId);
            await Future.delayed(Duration(seconds: currExcercise.interval));
            await said;
          }
          if (currId == uniqueId) {
            setState(() {
              round = 0;
              if (currExcerciseNum + 1 < excercises.length) {
                currExcerciseNum++;
              }
            });
          }
          await _say("next", currId);
          await Future.delayed(const Duration(seconds: 1));
        }

        await _say("congrats. all excercise completed", currId);
        if (currId == uniqueId) {
          setState(() {
            isPlaying = false;
            isRest = true;
          });
        }
      } catch (err) {
        debugPrint("error: $err ");
      }
    }
  }

  Future<void> _say(String text, int currUniqueId) async {
    if (uniqueId != currUniqueId) {
      throw "uniqueId invalidated";
    }
    debugPrint("saying: $text");
  }

  @override
  Widget build(BuildContext context) {
    if (excercises.isEmpty) {
      _notifyEmpty(context);
      return Scaffold(
          appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("No valid inputs found", textAlign: TextAlign.center),
      ));
    }

    const iconSize = 100.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(isPlaying ? "Playing excercise" : "Play excercise",
            textAlign: TextAlign.center),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(currExcercise.name,
                      style: const TextStyle(fontSize: 40)),
                  Text(
                      isRest
                          ? "Rest"
                          : (isPlaying ? "Round ${round + 1}" : "Paused"),
                      style: const TextStyle(fontSize: 30)),
                  Text("duration:${currExcercise.duration} seconds")
                ],
              ))),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () => {_back()},
                        child: const Icon(Icons.skip_previous_rounded,
                            size: iconSize))),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () => {_playpause(context)},
                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                            size: iconSize))),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () => {_next()},
                        child: const Icon(Icons.skip_next_rounded,
                            size: iconSize))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExcerciseEntry {
  const _ExcerciseEntry(
      {required this.name,
      required this.duration,
      required this.rounds,
      required this.interval});
  final String name;
  final int interval;
  final int duration;
  final int rounds;
}
