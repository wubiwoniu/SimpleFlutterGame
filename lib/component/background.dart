import 'dart:ui';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flutter/material.dart';

class BackGround extends Component with Resizable {
  final DinosaurRun game;
  Rect rect;
  Paint paint;
  BackGround(this.game);

  void render(Canvas c) {
    rect = Rect.fromLTWH(0, 0, game.screenSize.width, game.screenSize.height);
    paint = Paint();
    paint.color = Colors.white;
    c.drawRect(rect, paint);
  }

  void update(double t) {}
}
