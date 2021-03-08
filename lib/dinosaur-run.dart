import 'dart:ui' as ui;
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:dinosaur/component/background.dart';
import 'package:dinosaur/component/ground.dart';
import 'package:dinosaur/component/clouds.dart';
import 'package:dinosaur/status.dart';
import 'package:dinosaur/component/dinosaur.dart';
import 'package:dinosaur/button/jump-button.dart';
import 'package:dinosaur/button/down-button.dart';
import 'package:dinosaur/obstacle/cactus.dart';
import 'package:dinosaur/controller/check-hit.dart';
import 'package:dinosaur/component/now-score.dart';
import 'package:dinosaur/component/best-score.dart';

class DinosaurRun extends BaseGame with HasWidgetsOverlay, TapDetector {
  Size screenSize;
  ui.Image img;
  BackGround bg;
  Ground ground;
  Clouds clouds;
  Cactus cactus;
  Dinosaur dinosaur;
  JumpButton jumpbutton;
  DownButton downbutton;
  NowScore nowScore;
  BestScore bestScore;

  HitCheckHelper hitcheck;

  double startSpeed;
  double maxSpeed;
  double accSpeed;
  double dashSpeed;

  bool isplay;

  DinosaurRun(this.img) {
    initialize();
  }
  void initialize() async {
    resize(await Flame.util.initialDimensions());
    startSpeed = 6.5;
    maxSpeed = 13;
    accSpeed = 0.001;
    dashSpeed = 26;
    isplay = true;
    nowScore = NowScore(this, img);
    bestScore = BestScore(img);
    bg = BackGround(this);
    ground = Ground(this, img);
    clouds = Clouds(this, img);
    cactus = Cactus(this, img);
    dinosaur = Dinosaur(this, img);
    jumpbutton = JumpButton(dinosaur);
    downbutton = DownButton(dinosaur);
    hitcheck = HitCheckHelper();
    add(bg);
    add(ground);
    add(clouds);
    add(cactus);
    add(dinosaur);
    add(nowScore);
    add(bestScore);
    addWidgetOverlay(
        'JumpButton',
        jumpbutton.setJumpButton(
            onHighlightChanged: (isOn) => dinosaur.setJump(isOn)));
    addWidgetOverlay(
        'DownButton',
        downbutton.setDownButton(
            onHighlightChanged: (isOn) => dinosaur.setDown(isOn)));
  }

  @override
  void resize(ui.Size size) {
    // TODO: implement resize
    screenSize = size;
    super.resize(size);
  }

  void update(double t) async {
    if (isplay) {
      ground.update(t);
      clouds.update(t);
      dinosaur.update(t);
      cactus.update(t);
      nowScore.update(t);
      bestScore.update(t);
      if (await hitcheck.checkHit(dinosaur.nowStatus, cactus)) {
        isplay = false;
        dinosaur.setDie();
      }
    }
  }
}
