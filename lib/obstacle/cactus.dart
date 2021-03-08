import 'dart:math';
import 'dart:ui' as ui;
import 'package:dinosaur/dinosaur-run.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:dinosaur/config.dart';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:flame/util.dart';
import 'package:flutter/cupertino.dart';

class Cactus extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  final DinosaurRun game;
  ui.Image img;
  SpriteComponent last;

  double currentSpeed;
  double lowerBound;

  Cactus(this.game, this.img) {
    lowerBound = game.screenSize.height - DinoConfig.h - HorizonConfig.h + 40;
    currentSpeed = game.startSpeed;
    last = null;
  }

  double getRandomNum(double a, double b) =>
      (Random().nextDouble() * (b - a + 1)).floor() + a;

  SpriteComponent getRandom(double x, int hard) {
    int rnd = Random().nextInt(hard);
    Sprite temp = Sprite.fromImage(img,
        x: CactusConfig.list[rnd].x,
        y: CactusConfig.list[rnd].y,
        width: CactusConfig.list[rnd].w,
        height: CactusConfig.list[rnd].h);
    SpriteComponent res = SpriteComponent.fromSprite(
        CactusConfig.list[rnd].w, CactusConfig.list[rnd].h, temp);
    res.x = x + CactusConfig.list[rnd].w;
    res.y = lowerBound;
    return res;
  }

  void update(double t) {
    if (game.isplay) {
      double x = t * 50 * currentSpeed;
      for (final c in components) {
        SpriteComponent component = c;
        if (component.x + component.width < 0) {
          components.remove(component);
        } else {
          component.x -= x;
        }
      }
      double hard = (game.maxSpeed - game.startSpeed) / 3;
      double nowhard = currentSpeed - game.startSpeed;
      int indexChoose = (nowhard < hard) ? 2 : ((nowhard < 2 * hard) ? 3 : 4);
      double distance = getRandomNum(
          CactusConfig.minDistance, game.screenSize.width * (5 - indexChoose));
      if (last == null) {
        double x = game.screenSize.width + distance;
        SpriteComponent sprite = getRandom(x, Random().nextInt(indexChoose));
        last = sprite;
        add(sprite);
      } else {
        int rnd;
        if (nowhard < hard) {
          rnd = Random().nextInt(10);
        } else if (nowhard < 2 * hard) {
          rnd = Random().nextInt(6);
        } else {
          rnd = Random().nextInt(3);
        }
        if (rnd == 0) {
          double x = last.x + last.width + distance;
          SpriteComponent sprite = getRandom(x, indexChoose);
          last = sprite;
          add(sprite);
        }
      }
    }
  }
}
