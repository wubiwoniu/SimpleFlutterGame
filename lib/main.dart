import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.landscapeLeft);

  ui.Image image = await Flame.images.load('source.png');

  DinosaurRun game = DinosaurRun(image);
  runApp(game.widget);
}
