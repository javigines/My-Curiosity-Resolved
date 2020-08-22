import 'package:flutter/material.dart';

class QuestionDetailPage extends StatefulWidget {
  @override
  _QuestionDetailPage createState() => _QuestionDetailPage();
}

class _QuestionDetailPage extends State<QuestionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Detail"),
      ),
      body: _formComponent(),
    );
  }
}

class _formComponent extends StatefulWidget {
  @override
  __formComponentState createState() => __formComponentState();
}

class __formComponentState extends State<_formComponent> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              new TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "I'm asking myself...",
                ),
              ),
              SizedBox(height: 10),
              new TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText:
                      "To be precise, with my question I'm taking about...",
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: RaisedButton(
                    color: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    onPressed: () => {
                      Navigator.of(context).pop(true)
                    },
                    child: Text("Save my question"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
