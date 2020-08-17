
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import '../questionDetail/questionDetail.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() =>
      _MyHomePageState(savedQuestions: List.generate(20, (i) {
        return generateWordPairs().take(5).join(" ") + "?";
      }));
}


class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.savedQuestions}) : super();

  final List<String> savedQuestions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Questions"),
      ),
      body: _buildQuestionList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => QuestionDetailPage())
          );
        },
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
        savedQuestions[actualIndex],
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold
        ),
        maxLines: 3,
        
      ),
    );
  }
}