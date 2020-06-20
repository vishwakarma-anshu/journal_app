import 'package:flutter/material.dart';

class MoodIcon {
  final String title;
  final Color color;
  final IconData icon;
  final double rotation;

  const MoodIcon({
    this.color,
    this.icon,
    this.rotation,
    this.title,
  });

  IconData getMoodIcon(String mood) {
    return _moodIconList[
            _moodIconList.indexWhere((element) => element.title == mood)]
        .icon;
  }

  Color getMoodColor(String mood) {
    return _moodIconList[
            _moodIconList.indexWhere((element) => element.title == mood)]
        .color;
  }

  double getMoodRotation(String mood) {
    return _moodIconList[
            _moodIconList.indexWhere((element) => element.title == mood)]
        .rotation;
  }

  List<MoodIcon> getMoodList() {
    return _moodIconList;
  }
}

const List<MoodIcon> _moodIconList = <MoodIcon>[
  const MoodIcon(
      title: 'Very Satisfied',
      color: Colors.amber,
      icon: Icons.sentiment_very_satisfied,
      rotation: 0.4),
  const MoodIcon(
      title: 'Satisfied',
      color: Colors.green,
      icon: Icons.sentiment_satisfied,
      rotation: 0.2),
  const MoodIcon(
      title: 'Neutral',
      color: Colors.grey,
      icon: Icons.sentiment_neutral,
      rotation: 0.0),
  const MoodIcon(
      title: 'Dissatisfied',
      color: Colors.cyan,
      icon: Icons.sentiment_dissatisfied,
      rotation: -0.2),
  const MoodIcon(
      title: 'Very Dissatisfied',
      color: Colors.red,
      icon: Icons.sentiment_very_dissatisfied,
      rotation: -0.4),
];
