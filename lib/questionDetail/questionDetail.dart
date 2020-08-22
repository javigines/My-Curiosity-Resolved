import 'package:flutter/material.dart';
import '../entities/questionEntity.dart';

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
  final questionController = TextEditingController();
  final questionAdditionalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          new TextField(
            controller: questionController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "I'm asking myself...",
            ),
          ),
          SizedBox(height: 10),
          new TextField(
            controller: questionAdditionalController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "To be precise, with my question I'm taking about...",
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: RaisedButton(
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                onPressed: () => {_saveQuestionData(context)},
                child: Text("Save my question"),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _saveQuestionData(BuildContext context) {
    QuestionEntity question = new QuestionEntity(
        id: new DateTime.now().millisecondsSinceEpoch,
        question: questionController.text,
        questionDetails: questionAdditionalController.text);
    Navigator.of(context).pop(question);
  }
}
