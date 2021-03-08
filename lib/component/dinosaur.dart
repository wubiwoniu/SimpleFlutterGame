import 'dart:ui' as ui;
import 'dart:math';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:dinosaur/status.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/position.dart';
import 'package:dinosaur/config.dart';
import 'package:flame/sprite.dart';
import 'package:flame/animation.dart';

class Dinosaur extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  final DinosaurRun game;
  ui.Image img;

  Status status;

  bool isUp;
  bool isDown;
  bool isQuick;

  double currentSpeed;

  double upVelocity;
  double lowerBound;
  double pos;

  List<PositionComponent> diffStatus;
  PositionComponent nowStatus;

  Dinosaur(this.game, this.img) {
    status = Status.run;
    isDown = false;
    isUp = false;
    isQuick = false;
    upVelocity = 0;
    currentSpeed = game.startSpeed;
    pos = (game.screenSize.width) / 8;
    lowerBound = game.screenSize.height - DinoConfig.h - HorizonConfig.h + 20;
    diffStatus = List<PositionComponent>(5);
    setComponents();
    nowStatus = diffStatus[status.index];
  }
  void setComponents() {
    //wait,run,jump,down,die
    diffStatus[0] = SpriteComponent.fromSprite(
        DinoWaitConfig.w,
        DinoConfig.h,
        Sprite.fromImage(img,
            x: DinoWaitConfig.x,
            y: DinoConfig.y,
            width: DinoWaitConfig.w,
            height: DinoConfig.h));

    List<Sprite> spritelist = List<Sprite>();

    for (int i = 0; i < 2; i++) {
      spritelist.add(Sprite.fromImage(img,
          width: DinoRunConfig.w,
          height: DinoConfig.h,
          x: 1336.5 + (i + 2) * 88,
          y: DinoConfig.y));
    }
    diffStatus[1] = AnimationComponent(DinoRunConfig.w, DinoConfig.h,
        Animation.spriteList(spritelist, stepTime: 0.1, loop: true));

    diffStatus[2] = SpriteComponent.fromSprite(
        DinoJumpConfig.w,
        DinoConfig.h,
        Sprite.fromImage(img,
            width: DinoJumpConfig.w,
            height: DinoConfig.h,
            x: DinoJumpConfig.x,
            y: DinoConfig.y));

    spritelist.clear();
    for (int i = 0; i < 2; i++) {
      spritelist.add(Sprite.fromImage(img,
          width: DinoDownConfig.w,
          height: DinoConfig.h,
          x: 1866.0 + i * 118,
          y: DinoConfig.y));
    }
    diffStatus[3] = AnimationComponent(DinoDownConfig.w, DinoConfig.h,
        new Animation.spriteList(spritelist, stepTime: 0.1, loop: true));

    diffStatus[4] = SpriteComponent.fromSprite(
        DinoDieConfig.w,
        DinoConfig.h,
        Sprite.fromImage(img,
            width: DinoDieConfig.w,
            height: DinoConfig.h,
            x: DinoDieConfig.x,
            y: DinoConfig.y));

    for (int i = 0; i < 5; i++) {
      diffStatus[i].x = 10;
      diffStatus[i].y = lowerBound;
    }
  }

  void setJump(bool isHandle) {
    if (status == Status.run && isHandle) {
      status = Status.jump;
      nowStatus = diffStatus[status.index];
      isUp = true;
      upVelocity = -17;
    } else {
      isUp = false;
    }
  }

  void setDown(bool isHandle) {
    if (status == Status.run && isHandle) {
      status = Status.down;
    } else if (status == Status.down && !isHandle) {
      status = Status.run;
    }
    nowStatus = diffStatus[status.index];
    isDown = isHandle;
  }

  void setDie() {
    if (status == Status.down) {
      x = x + (DinoDownConfig.w - DinoDieConfig.w);
      status = Status.die;
    } else {
      status = Status.die;
    }
  }

  void render(ui.Canvas c) {
    nowStatus.render(c);
  }

  void update(double t) {
    if (game.isplay) {
      if (status == Status.run && x < pos) {
        x += t * 50 * currentSpeed;
      }
      currentSpeed += game.accSpeed;
      if (status == Status.jump) {
        nowStatus.y += upVelocity;
        upVelocity += 0.7;
        if (nowStatus.y > lowerBound) {
          status = Status.run;
          nowStatus.y = lowerBound;
          setJump(isUp);
          setDown(isDown);
        }
      }
      nowStatus.update(t);
    }
  }
}
