import 'dart:ui' as ui;
import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:dinosaur/config.dart';

class Clouds extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  final DinosaurRun game;

  int sum;

  Sprite sprite;
  SpriteComponent last;

  ui.Image img;
  double maxHeight, minHeight;
  double currentSpeed;

  Clouds(this.game, this.img) {
    maxHeight = game.screenSize.height - HorizonConfig.h - CloudConfig.h;
    minHeight = CloudConfig.h;
    currentSpeed = game.startSpeed;
    sprite = Sprite.fromImage(img,
        x: CloudConfig.x,
        y: CloudConfig.y,
        width: CloudConfig.w,
        height: CloudConfig.h);
    sum = (game.screenSize.width / CloudConfig.w).ceil();
    for (int i = 0; i < sum; i++) {
      int isHave = Random().nextInt(2);
      if (isHave == 1) {
        double x = i * CloudConfig.w;
        double y = Random().nextDouble() * game.screenSize.height;
        if (y > maxHeight) y = maxHeight;
        if (y < minHeight) y = minHeight;
        last = getRandom(x, y);
        add(last);
      }
    }
  }
  SpriteComponent getRandom(double x, double y) {
    SpriteComponent spriteComponent =
        SpriteComponent.fromSprite(CloudConfig.w, CloudConfig.h, sprite);
    spriteComponent.x = x;
    spriteComponent.y = y;
    return spriteComponent;
  }

  void update(double t) {
    if (game.isplay) {
      double x = t * 8 * currentSpeed;
      currentSpeed += game.accSpeed;
      if (currentSpeed > game.maxSpeed) {
        currentSpeed = game.maxSpeed;
      }
      for (final c in components) {
        SpriteComponent component = c;
        component.x -= x;
        if (component.x + CloudConfig.w <= 0) {
          components.remove(component);
          int isHave = Random().nextInt(2);
          if (isHave == 1) {
            double x = (sum - 1) * CloudConfig.w;
            double y = Random().nextDouble() * game.screenSize.height;
            if (y > maxHeight) y = maxHeight;
            if (y < minHeight) y = minHeight;
            last = getRandom(x, y);
            add(last);
          }
        }
      }
      if (components.isEmpty) {
        double x = (sum - 1) * CloudConfig.w;
        double y = Random().nextDouble() * game.screenSize.height;
        if (y > maxHeight) y = maxHeight;
        if (y < minHeight) y = minHeight;
        last = getRandom(x, y);
        add(last);
      }
    }
  }
}
