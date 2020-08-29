import 'package:flutter/material.dart';
import '../entities/questionEntity.dart';
import 'package:my_curiosity_resolved/entities/entitiesBoxes.dart';

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
      body: _FormComponent(),
    );
  }
}

class _FormComponent extends StatefulWidget {
  @override
  _FormComponentState createState() => _FormComponentState();
}

class _FormComponentState extends State<_FormComponent> {
  final questionController = TextEditingController();
  final questionAdditionalController = TextEditingController();
  final answerController = TextEditingController();

  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    questionController.addListener(() {
      _onQuestionTextChange();
    });

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
          SizedBox(height: 48),
          new TextField(
            controller: answerController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "The best answer I could find to this question is...",
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: RaisedButton(
                color: Colors.deepPurpleAccent,
                textColor: Colors.white,
                onPressed: _isButtonDisabled
                    ? null
                    : () => {_saveQuestionData(context)},
                child: Text("Save my question"),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _onQuestionTextChange() {
    setState(() {
      _isButtonDisabled = questionController.text.isEmpty;
    });
  }

  _saveQuestionData(BuildContext context) {
    QuestionEntity question = new QuestionEntity(
        question: questionController.text.trim(),
        questionDetails: questionAdditionalController.text.trim(),
        answer: answerController.text.trim());

    question.id = entitiesBoxesInstance.questionBox.put(question);
    Navigator.of(context).pop(question);
  }

  @override
  void dispose() {
    questionController.dispose();
    questionAdditionalController.dispose();
    super.dispose();
  }
}
