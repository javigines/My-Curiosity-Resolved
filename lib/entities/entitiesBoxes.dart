import 'package:my_curiosity_resolved/app/singleton.dart';
import 'package:my_curiosity_resolved/entities/questionEntity.dart';
import '../objectbox.g.dart';

final EntitiesBoxes entitiesBoxesInstance =
    new EntitiesBoxes._privateConstructor();

class EntitiesBoxes {
  EntitiesBoxes._privateConstructor();

  Box<QuestionEntity> questionBox =
      Box<QuestionEntity>(singletonInstance.objectBoxStore);
}
