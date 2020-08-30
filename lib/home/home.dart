import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_curiosity_resolved/app/singleton.dart';
import 'package:my_curiosity_resolved/entities/entitiesBoxes.dart';
import 'package:my_curiosity_resolved/entities/questionEntity.dart';
import 'package:my_curiosity_resolved/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

import '../questionDetail/questionDetail.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() : super();

  List<QuestionEntity> savedQuestions = List();
  Offset _tapPosition;
  int _tapIndex;

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((dir) {
      singletonInstance.objectBoxStore =
          Store(getObjectBoxModel(), directory: dir.path + "/objectbox");

      setState(() {
        this.savedQuestions = entitiesBoxesInstance.questionBox.getAll().reversed.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Questions"),
      ),
      body: savedQuestions.isEmpty
          ? _buildEmptyQuestionListLayout()
          : _buildQuestionList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _newQuestionButtonClick(context);
        },
      ),
    );
  }

  _newQuestionButtonClick(BuildContext context) async {
    QuestionEntity newQuestion = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QuestionDetailPage()));

    print(newQuestion.toString());
    if (newQuestion == null) return;

    setState(() {
      savedQuestions.insert(0, newQuestion);
    });
  }

  Widget _buildEmptyQuestionListLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: FractionalOffset.center,
            child: Image.asset(
              'assets/no_questions_found.png',
              width: 180,
              height: 150,
              alignment: Alignment.centerRight,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          Text(
            "No Questions Found",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildQuestionList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final actualIndex = i ~/ 2;
        return _buildRowQuestionList(actualIndex);
      },
      itemCount: savedQuestions.length * 2,
    );
  }

  Widget _buildRowQuestionList(int actualIndex) {
    QuestionEntity questionObject = savedQuestions[actualIndex];

    return GestureDetector(
      onTapDown: (details) {
        _storeTapQuestionPosition(details, actualIndex);
      },
      child: ListTile(
        title: Text(
          questionObject.question,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          maxLines: 2,
        ),
        dense: true,
        subtitle: _retrieveSubtitleWidget(questionObject),
        trailing: Text(
          questionObject.answer.isEmpty
              ? "❓"
              : (questionObject.finalAnswer ? "👌" : "🤔"),
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        onTap: () {
          _editQuestionScreen(context, actualIndex);
        },
        onLongPress: _showCustomMenu,
      ),
    );
  }

  Widget _retrieveSubtitleWidget(QuestionEntity question) {

    return Column(
      children: [
        Align( 
          alignment: Alignment.centerLeft,
          child: _retrieveSubtitleText(question),
        ),
        SizedBox(height: 4),
        Align( 
          alignment: Alignment.centerLeft,
         child: 
         Text(
           "${DateFormat.yMEd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(question.creationDate))}",
           style: TextStyle(
             fontSize: 11,
             color: Colors.blueGrey.shade200
           ),
           ),
        ),
      ],
    );
  }

  Widget _retrieveSubtitleText(QuestionEntity question) {
    if (question.answer.isNotEmpty)
      return Text(
        question.answer,
        style: TextStyle(
          color: Colors.greenAccent.shade400,
          fontSize: 13
          ),
        maxLines: 5,
      );
    else if (question.questionDetails.isNotEmpty)
      return Text(
        question.questionDetails,
        maxLines: 2,
      );
    else
      return SizedBox(height: 0);

    // Text(
    //     questionObject.questionDetails,
    //     //style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    //     maxLines: 2,
    //   ),
  }

  _editQuestionScreen(BuildContext context, int index) async {
    QuestionEntity actualQuestion = savedQuestions[index];

    QuestionEntity edittedQuestion =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuestionDetailPage(
                  edittingQuestion: actualQuestion,
                )));

    print(edittedQuestion.toString());
    if (edittedQuestion == null) return;

    setState(() {
      savedQuestions.replaceRange(index, index + 1, [edittedQuestion]);
    });
  }

  _removeQuestion(int index) {
    QuestionEntity question = savedQuestions[index];

    setState(() {
      entitiesBoxesInstance.questionBox.remove(question.id);
      savedQuestions.remove(question);
    });
  }

  _storeTapQuestionPosition(TapDownDetails details, int index) {
    _tapPosition = details.globalPosition;
    _tapIndex = index;
  }

  _showCustomMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    final delta = await showMenu(
        context: context,
        items: <PopupMenuEntry<int>>[ContextualMenuEntry()],
        position: RelativeRect.fromRect(
            _tapPosition & const Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay.size // Bigger rect, the entire screen
            ));

    // This is how you handle user selection
    // delta would be null if user taps on outside the popup menu
    // (causing it to close without making selection)
    if (delta == null) return;

    switch (delta) {
      //Edit
      case 0:
        _editQuestionScreen(context, this._tapIndex);
        break;
      //Remove
      case 1:
        _removeQuestion(this._tapIndex);
        break;
    }
  }
}

class ContextualMenuEntry extends PopupMenuEntry<int> {
  @override
  final double height = 80;
  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(int n) => n == 1 || n == -1;

  @override
  ContextualMenuEntryState createState() => ContextualMenuEntryState();
}

class ContextualMenuEntryState extends State<ContextualMenuEntry> {
  void _edit() {
    // This is how you close the popup menu and return user selection.
    Navigator.pop<int>(context, 0);
  }

  void _remove() {
    // This is how you close the popup menu and return user selection.
    Navigator.pop<int>(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: FlatButton(onPressed: _edit, child: Text('Edit'))),
        Expanded(
            child: FlatButton(
                onPressed: _remove,
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ))),
      ],
    );
  }
}
