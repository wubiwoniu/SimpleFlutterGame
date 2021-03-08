import 'dart:ui' as ui;

import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:dinosaur/config.dart';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:flame/sprite.dart';

class NowScore extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  final ui.Image img;
  final DinosaurRun game;
  int score;
  double x, y;
  List<int> scoreSplit;

  NowScore(this.game, this.img) {
    score = 0;
    x = 0;
    y = 5;
    scoreSplit = List<int>();
  }

  void getScore() {
    components.clear();
    scoreSplit.clear();
    String str = score.toString();
    for (int i = 0; i < str.length; i++) {
      scoreSplit.add(int.parse(str[i]));
    }
  }

  SpriteComponent setScore(int number, double x, double y) {
    double num_x = ScoreConfig.x + number * ScoreConfig.w;
    Sprite sprite = Sprite.fromImage(img,
        x: num_x,
        y: ScoreConfig.y,
        width: ScoreConfig.w,
        height: ScoreConfig.h);
    SpriteComponent scoreNum =
        SpriteComponent.fromSprite(ScoreConfig.w, ScoreConfig.h, sprite);
    scoreNum.x = x;
    scoreNum.y = y;
    return scoreNum;
  }

  void update(double t) {
    getScore();
    score++;
    int i = 0;
    for (final n in scoreSplit) {
      add(setScore(n, x + i * ScoreConfig.w, y));
      i++;
    }
  }
}
