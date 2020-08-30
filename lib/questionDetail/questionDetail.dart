import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      _FormComponentState(questionObject: this.edittingQuestion);
}

class _FormComponentState extends State<_FormComponent> {
  QuestionEntity questionObject;
  _FormComponentState({this.questionObject});

  final questionController = TextEditingController();
  final questionAdditionalController = TextEditingController();
  final answerController = TextEditingController();

  bool _isButtonDisabled = true;
  bool _isFinalAnswerDisabled = true;
  bool finalAnswerCheckboxHasChange = false;

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
          SizedBox(height: 10),
          CheckboxListTile(
              title: Text("Are you happy with your answer?"),
              value:
                  _isFinalAnswerDisabled ? false : questionObject.finalAnswer,
              onChanged:
                  _isFinalAnswerDisabled ? null : _onQuestionStatusChange),
          Expanded(child: _retrieveFooter()),
        ],
      ),
    ));
  }

  Widget _retrieveFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RaisedButton(
          color: Colors.deepPurpleAccent,
          textColor: Colors.white,
          onPressed:
              _isButtonDisabled ? null : () => {_saveQuestionData(context)},
          child: Text("Save my question"),
        ),
        SizedBox(height: 10),
        questionObject.creationDate == null
            ? SizedBox(height: 0)
            :Text(
          "Created: ${DateFormat.yMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(questionObject.creationDate))}",
          style: TextStyle(color: Colors.blueGrey.shade200),
        ),
        questionObject.modifiedDate == null
            ? SizedBox(height: 0)
            : Text(
                "Last Modified: ${DateFormat.yMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(questionObject.modifiedDate))}",
                style: TextStyle(color: Colors.blueGrey.shade200),
              ),
      ],
    );
  }

  @override
  initState() {
    if (this.questionObject == null) {
      this.questionObject =
          QuestionEntity();
      return;
    }

    this.questionController.text = this.questionObject.question;
    this.questionAdditionalController.text =
        this.questionObject.questionDetails;
    this.answerController.text = this.questionObject.answer;
    if (this.questionObject.answer.isNotEmpty) {
      _isFinalAnswerDisabled = false;
    }

    super.initState();
  }

  _onQuestionTextChange() {
    setState(() {
      _isFinalAnswerDisabled = this.answerController.text.trim().isEmpty;
      if (this.answerController.text != this.questionObject.answer) {
        this.questionObject.finalAnswer = false;
      }
      _setupSaveButton();
    });
  }

  _onQuestionStatusChange(bool isFinal) {
    finalAnswerCheckboxHasChange = true;
    _setupSaveButton();
    setState(() {
      this.questionObject.finalAnswer = isFinal;
      if (isFinal) {
        this.questionObject.answer = this.answerController.text.trim();
      }
    });
  }

  _setupSaveButton() {
    _isButtonDisabled = questionController.text.isEmpty;
    if (_isButtonDisabled) return;

    _isButtonDisabled =
        this.questionController.text == this.questionObject.question &&
            this.questionAdditionalController.text ==
                this.questionObject.questionDetails &&
            this.answerController.text == this.questionObject.answer &&
            !finalAnswerCheckboxHasChange;
  }

  _saveQuestionData(BuildContext context) {
    var time = DateTime.now().millisecondsSinceEpoch;
    if (this.questionObject.creationDate == null) this.questionObject.creationDate = time;
    
    this.questionObject.question = questionController.text.trim();
    this.questionObject.questionDetails =
        questionAdditionalController.text.trim();
    this.questionObject.answer = answerController.text.trim();
    this.questionObject.modifiedDate = time;

    questionObject.id = entitiesBoxesInstance.questionBox.put(questionObject);
    Navigator.of(context).pop(questionObject);
  }

  @override
  void dispose() {
    questionController.dispose();
    questionAdditionalController.dispose();
    super.dispose();
  }
}
