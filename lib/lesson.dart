import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson extends Equatable {
  final String id;
  final String title;
  final String text;

  /// Audio url
  final String? audio;

  const Lesson(this.id, this.title, this.text, this.audio);

  @override
  List<Object?> get props => [id];

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
