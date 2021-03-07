import 'dart:ui' as ui;
import 'dart:math';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:dinosaur/config.dart';

class Ground extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {
  final DinosaurRun game;
  ui.Image img;
  SpriteComponent last;
  double currentSpeed;

  Ground(this.game, this.img) {
    currentSpeed = game.startSpeed;
    double x = 0;
    for (int i = 0;
        i < (game.screenSize.width / HorizonConfig.w).ceil() + 1;
        i++) {
      SpriteComponent temp = getRandom(x);
      last = temp;
      x += temp.x;
      add(temp);
    }
  }
  SpriteComponent getRandom(double x) {
    Sprite sprite = Sprite.fromImage(img,
        width: HorizonConfig.w,
        height: HorizonConfig.h,
        y: HorizonConfig.y,
        x: HorizonConfig.w * Random().nextInt(3) + HorizonConfig.x);
    SpriteComponent spriteComponent =
        SpriteComponent.fromSprite(HorizonConfig.w, HorizonConfig.h, sprite);
    spriteComponent.x = x;
    spriteComponent.y = game.screenSize.height - HorizonConfig.h;
    return spriteComponent;
  }

  void update(double t) {
    if (game.isplay) {
      currentSpeed += game.accSpeed;
      if (currentSpeed > game.maxSpeed) {
        currentSpeed = game.maxSpeed;
      }
      for (final c in components) {
        final component = c as SpriteComponent;
        if (component.x + HorizonConfig.w <= 0) {
          components.remove(component);
          SpriteComponent sprite = getRandom(last.x + HorizonConfig.w);
          last = sprite;
          add(sprite);
        } else {
          component.x -= t * 50 * currentSpeed;
        }
      }
    }
  }
}
