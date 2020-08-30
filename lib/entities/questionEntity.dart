import 'dart:convert';

import 'package:objectbox/objectbox.dart';

QuestionEntity questionFromJson(String str) =>
    QuestionEntity.fromJson(json.decode(str));

String questionToJson(QuestionEntity data) => json.encode(data.toJson());

@Entity()
class QuestionEntity {
  @Id()
  int id;

  String question;
  String questionDetails;
  String answer;
  bool finalAnswer;

  QuestionEntity({
    this.id,
    this.question,
    this.questionDetails,
    this.answer,
    this.finalAnswer,
  });
  toString() =>
      "QuestionEntity{id: $id, question: $question, questionDetails: $questionDetails, answer: $answer, finalAnswer: $finalAnswer}";

  factory QuestionEntity.fromJson(Map<String, dynamic> json) => QuestionEntity(
        id: json["resId"] == null ? null : json["resId"],
        question: json["question"] == null ? null : json["question"],
        questionDetails:
            json["questionDetails"] == null ? null : json["questionDetails"],
        answer:
            json["answer"] == null ? null : json["answer"],
        finalAnswer:
            json["finalAnswer"] == null ? null : json["finalAnswer"],
      );

  Map<String, dynamic> toJson() => {
        "resId": id == null ? null : id,
        "question": question == null ? null : question,
        "questionDetails": questionDetails == null ? null : questionDetails,
        "answer": answer == null ? null : answer,
        "finalAnswer": finalAnswer == null ? null : finalAnswer,
      };
}
