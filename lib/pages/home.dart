
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_2_audio_excercise/pages/play.dart';

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
    _load();
  }

  Future<void> _load() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var text = prefs.getString(storeKey);
    debugPrint('text is $text ');
    if (text != null) {
      textController.text = text;
    }
  }

  Future<void> _save() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint("saving text ${textController.text} ");
    prefs.setString(storeKey, textController.text);
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
                onPressed: _load,
              ),
              TextButton.icon(
                label: const Text("Save"),
                icon: const Icon(Icons.save),
                onPressed: _save,
              ),
            ],
          ),
          TextField(
            controller: textController,
            maxLines: null,
            minLines: 8,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
                hintText:
                    "Express your excercise in the pattern below\nRounds TimeInSeconds Name\n\nExample below,\n3 20 Planks\n3 20 Child Pose"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var text = textController.text;
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPage(text: text)));
        },
        tooltip: "Play",
        child: const Icon(Icons.play_arrow),
      ), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
