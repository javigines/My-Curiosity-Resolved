import 'package:flutter/material.dart';
import '../entities/questionEntity.dart';
import 'package:my_curiosity_resolved/entities/entitiesBoxes.dart';

class QuestionDetailPage extends StatefulWidget {
  final QuestionEntity edittingQuestion;
  QuestionDetailPage({this.edittingQuestion});

  @override
  _QuestionDetailPage createState() =>
      _QuestionDetailPage(edittingQuestion: this.edittingQuestion);
}

class _QuestionDetailPage extends State<QuestionDetailPage> {
  final QuestionEntity edittingQuestion;
  _QuestionDetailPage({this.edittingQuestion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Detail"),
      ),
      body: _FormComponent(edittingQuestion: this.edittingQuestion),
    );
  }
}

class _FormComponent extends StatefulWidget {
  final QuestionEntity edittingQuestion;
  _FormComponent({this.edittingQuestion});

  @override
  _FormComponentState createState() =>
      _FormComponentState(edittingQuestion: this.edittingQuestion);
}

class _FormComponentState extends State<_FormComponent> {
  final QuestionEntity edittingQuestion;
  _FormComponentState({this.edittingQuestion});

  final questionController = TextEditingController();
  final questionAdditionalController = TextEditingController();
  final answerController = TextEditingController();

  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    questionController.addListener(() {
      _onQuestionTextChange();
    });
    questionAdditionalController.addListener(() {
      _onQuestionTextChange();
    });
    answerController.addListener(() {
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

  @override
  initState() {
    if (this.edittingQuestion == null) return;

    this.questionController.text = this.edittingQuestion.question;
    this.questionAdditionalController.text =
        this.edittingQuestion.questionDetails;
    this.answerController.text = this.edittingQuestion.answer;
  }

  _onQuestionTextChange() {
    setState(() {
      _isButtonDisabled = questionController.text.isEmpty;

      if (_isButtonDisabled || this.edittingQuestion == null) return;

      _isButtonDisabled =
          this.questionController.text == this.edittingQuestion.question &&
              this.questionAdditionalController.text ==
                  this.edittingQuestion.questionDetails &&
              this.answerController.text == this.edittingQuestion.answer;
    });
  }

  _saveQuestionData(BuildContext context) {
    QuestionEntity question;
    if (this.edittingQuestion != null) {
      this.edittingQuestion.question = questionController.text.trim();
      this.edittingQuestion.questionDetails =
          questionAdditionalController.text.trim();
      this.edittingQuestion.answer = answerController.text.trim();
      question = this.edittingQuestion;
      
    } else {
      question = new QuestionEntity(
          question: questionController.text.trim(),
          questionDetails: questionAdditionalController.text.trim(),
          answer: answerController.text.trim());
    }

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
