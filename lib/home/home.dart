import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((dir) {
      singletonInstance.objectBoxStore =
          Store(getObjectBoxModel(), directory: dir.path + "/objectbox");

      setState(() {
        this.savedQuestions = entitiesBoxesInstance.questionBox.getAll();
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
      savedQuestions.add(newQuestion);
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
    return ListTile(
      title: Text(
        savedQuestions[actualIndex].question,
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        maxLines: 3,
      ),
      onTap: () {
        _editQuestionScreen(context, actualIndex);
      },
    );
  }

  _editQuestionScreen(BuildContext context, int index) async {
    QuestionEntity actualQuestion = savedQuestions[index];

    QuestionEntity edittedQuestion = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QuestionDetailPage(edittingQuestion: actualQuestion,)));

    print(edittedQuestion.toString());
    if (edittedQuestion == null) return;

    setState(() {
      savedQuestions.replaceRange(index, index+1, [edittedQuestion]);
    });
  }
}
