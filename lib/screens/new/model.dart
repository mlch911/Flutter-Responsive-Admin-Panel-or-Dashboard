import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Result {
  String text;
  List<Section> sections;

  Result({required this.text, required this.sections});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);

  int score() {
    return sections
            .map((e) => e.score())
            .reduce((value, element) => value + element) ~/
        sections.length;
  }
}

@JsonSerializable()
class Section {
  String name;
  List<Item> items;

  Section({required this.name, required this.items});
  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
  Map<String, dynamic> toJson() => _$SectionToJson(this);

  List<Item> get validItems {
    return items
        .where((e) => e.commentType() != ItemCommentType.ignore)
        .toList();
  }

  int score() {
    return validItems
            .map((e) => e.commentScore())
            .reduce((value, element) => value + element) ~/
        validItems.length;
  }
}

@JsonSerializable()
class Item {
  String name;
  int score;

  int commentScore() {
    switch (score) {
      case 1:
        return 100;
      case 0:
        return 60;
      case -1:
        return 30;
      default:
        return 0;
    }
  }

  ItemCommentType commentType() {
    switch (score) {
      case 1:
        return ItemCommentType.like;
      case 0:
        return ItemCommentType.normal;
      case -1:
        return ItemCommentType.dislike;
      default:
        return ItemCommentType.ignore;
    }
  }

  Item({required this.name, required this.score});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

enum ItemCommentType {
  like,
  normal,
  dislike,
  ignore,
}
