import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart'as stt;
import 'package:avatar_glow/avatar_glow.dart';
class SpeechScreen extends StatefulWidget {
  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String,HighlightedWord>_highlights ={
    "Like":HighlightedWord(onTap: ()=>print("like"),textStyle: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
    ),
    "flutter":HighlightedWord(onTap: ()=>print("flutter"),textStyle: const TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
    ),
    ),
    "Abdelaziz":HighlightedWord(onTap: ()=>print("Abdelaziz"),textStyle: const TextStyle(
      color: Colors.orange,
      fontWeight: FontWeight.bold,
    ),
    ),
  };
  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text="press";
  double _confidence=1;

  void _listen()async {
    if (!_isListening){
      bool ?available = await _speech!.initialize(
        onStatus: (val)=>print("onStatus: $val"),
        onError: (val)=>print("onError: $val"),
      );
      if(available){
        setState(()=> _isListening = true);
        _speech?.listen(
          onResult: (val)=> setState(() {
            _text=val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence>0){
              _confidence=val.confidence;
            }
          }),
        );
      }else{
        setState(()=> _isListening = false);
        _speech?.stop();
      }
    }
  }
  @override
  void initState() {
    _speech=stt.SpeechToText();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Voice To Text App'),
      ),
      floatingActionButton: AvatarGlow(
        animate: _isListening,
          glowColor: Colors.red,
          endRadius: 70,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds:100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child:  Icon(_isListening?Icons.mic:Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: TextHighlight(
              text: _text,
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              words: _highlights,
          ),
        ),
      ),
    );
  }
}
