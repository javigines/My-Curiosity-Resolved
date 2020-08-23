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

  QuestionEntity({
    this.id,
    this.question,
    this.questionDetails,
  });
  toString() =>
      "QuestionEntity{id: $id, question: $question, questionDetails: $questionDetails}";

  factory QuestionEntity.fromJson(Map<String, dynamic> json) => QuestionEntity(
        id: json["resId"] == null ? null : json["resId"],
        question: json["question"] == null ? null : json["question"],
        questionDetails:
            json["questionDetails"] == null ? null : json["questionDetails"],
      );

  Map<String, dynamic> toJson() => {
        "resId": id == null ? null : id,
        "question": question == null ? null : question,
        "questionDetails": questionDetails == null ? null : questionDetails,
      };
}
