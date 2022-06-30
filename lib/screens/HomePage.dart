import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../chat/message.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var textEditingController = TextEditingController();

  String prompt =
      "The following is a conversation with an AI Assistant. The assistant is helpfull"
      "Human: Hello, who are you?\n"
      "AI : I am an AI created by openAI. How can I help you today";

  List<Message> messages = [];

  void sendMessage(String message) async{

    prompt +="\n"
        "Human: $message\n"
        "AI:";

    textEditingController.text = "";

    setState(() {
      messages.add(Message(message, true));
    });

    var result = await http.post(
        Uri.parse("https://api.openai.com/v1/engines/davinci/completions"),
        headers: {
          "Authorization": "Bearer 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",
          "Accept":"application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "prompt":prompt,
          "max_tokens":1000,
          "temperature":0,
          // "top_p":1,
          "stop":"Human:",
        })
    );
    print(result.body);

    var body = jsonDecode(result.body);
    var text = body["choices"][0]["text"];

    prompt += text;

    setState(() {
      messages.add(Message(text.trim(), false));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bgi.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child:Column(
            children: [
              Expanded(
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.all(20),
                  children: messages.reversed.map((message){
                    return Bubble(
                      child: Text(message.text,style: TextStyle(color: Colors.black),),
                      color: message.byMe ? Colors.yellowAccent : Colors.grey,
                      nip: message.byMe ? BubbleNip.rightBottom : BubbleNip.leftBottom,
                      alignment: message.byMe? Alignment.topRight : Alignment.topLeft,
                      margin: BubbleEdges.symmetric(vertical: 5),
                    );
                  }).toList(),
                ),
              ),
              Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Message",
                        ),
                        onSubmitted: sendMessage,
                        controller: textEditingController,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: (){
                        sendMessage(textEditingController.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),// This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
