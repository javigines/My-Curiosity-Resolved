import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Curiosity Resolved',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

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
