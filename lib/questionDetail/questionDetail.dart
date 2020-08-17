
import 'package:flutter/material.dart';


class QuestionDetailPage extends StatefulWidget {
  @override
  _QuestionDetailPage createState() =>
      _QuestionDetailPage();
}

class _QuestionDetailPage extends State<QuestionDetailPage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Question Detail"),
      ),
      body: Text("New Screen"),
    );

  }

}