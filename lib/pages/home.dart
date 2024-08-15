import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_2_audio_excercise/pages/play.dart';
import 'package:text_2_audio_excercise/utils/notify.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = 'Text2Audio Excercise';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textController = TextEditingController();
  final String storeKey = "text";

  @override
  void initState() {
    super.initState();
    _load(null);
  }

  Future<void> _load(BuildContext? context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var text = prefs.getString(storeKey);
    debugPrint('loaded text: $text ');
    if (text != null) {
      textController.text = text;
      if (context != null && context.mounted) {
        NotifyUtil.notifyInfo(context, "loaded text successfully");
      }
    }
  }

  Future<void> _save(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("saving text: ${textController.text} ");
    prefs.setString(storeKey, textController.text);
    if (context.mounted) {
      NotifyUtil.notifyInfo(context, "saved text successfully");
    }
  }

  String _hint() {
    return "Express your excercise in the pattern below\n"
        "Rounds TimeInSeconds Name\n"
        "\n"
        "Example below\n"
        "3r 30s 30i Planks\n"
        "3r 30s 10i Child Pose\n";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, textAlign: TextAlign.center),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                label: const Text("Load"),
                icon: const Icon(Icons.open_in_browser),
                onPressed: () => {_load(context)},
              ),
              TextButton.icon(
                label: const Text("Save"),
                icon: const Icon(Icons.save),
                onPressed: () => {_save(context)},
              ),
            ],
          ),
          TextField(
            controller: textController,
            maxLines: null,
            minLines: 8,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(hintText: _hint()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var text = textController.text;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PlayPage(text: text)));
        },
        tooltip: "Play",
        child: const Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
