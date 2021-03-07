import 'dart:ui' as ui;
import 'dart:math';
import 'dart:typed_data';
import 'package:dinosaur/dinosaur-run.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:dinosaur/obstacle/cactus.dart';

class HitCheckHelper {
  static Future<Uint8List> image2ByteList(ui.Image img) async {
    ByteData byteData = await img.toByteData();
    return byteData.buffer.asUint8List();
  }

  static Future<ui.Image> imageInBox(
      PositionComponent component, ui.Rect hitbox) async {
    Sprite sprite;
    if (component.runtimeType == SpriteComponent) {
      SpriteComponent temp = component;
      sprite = temp.sprite;
    } else if (component.runtimeType == AnimationComponent) {
      AnimationComponent temp = component;
      sprite = temp.animation.getSprite();
    }
    final ui.Rect rect = component.toRect();
    final recorder = new ui.PictureRecorder();
    final canvas = new ui.Canvas(recorder);
    final dst = ui.Rect.fromLTWH(0, 0, hitbox.width, hitbox.height);
    final src = ui.Rect.fromLTWH(
        sprite.src.right - (rect.right - hitbox.left),
        sprite.src.bottom - (rect.bottom - hitbox.top),
        hitbox.width,
        hitbox.height);
    final paint = ui.Paint();
    canvas.drawImageRect(sprite.image, src, dst, paint);
    final picture = recorder.endRecording();
    final image =
        await picture.toImage(hitbox.width.ceil(), hitbox.height.ceil());
    return image;
  }

  static isHit(
      PositionComponent component1, PositionComponent component2) async {
    final ui.Rect rect1 = component1.toRect();
    final ui.Rect rect2 = component2.toRect();
    if (rect1.overlaps(rect2)) {
      /*
          ---------
      */
      //左上角为0,0
      ui.Rect hitbox = ui.Rect.fromLTRB(
          max(rect1.left, rect2.left),
          max(rect1.top, rect2.top),
          min(rect1.right, rect2.right),
          min(rect1.bottom, rect2.bottom));
      final ui.Image img1 = await imageInBox(component1, hitbox);
      final ui.Image img2 = await imageInBox(component2, hitbox);
      final List<int> l1 = await image2ByteList(img1);
      final List<int> l2 = await image2ByteList(img2);
      for (int i = 0; i < l1.length; i++) {
        if (l1[i] > 0 && l2[i] > 0) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  Future<bool> checkHit(PositionComponent component, Cactus cactus) async {
    for (final n in cactus.components) {
      if (await isHit(component, n)) {
        return true;
      }
    }
    return false;
  }
}
