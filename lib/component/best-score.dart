import 'dart:ui' as ui;
import 'dart:io';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dinosaur/config.dart';

class BestScore extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent {
  int bestScore;

  ui.Image img;
  Storage storage;
  List<int> scoreSplit;

  double x, y;

  BestScore(this.img) {
    initionalized();
  }

  void initionalized() async {
    x = 0;
    y = 2;
    scoreSplit = List<int>();
    storage = Storage();
    bestScore = await storage.readCounter();
  }

  void getScore() {
    components.clear();
    scoreSplit.clear();
    String str = bestScore.toString();
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
    int i = 0;
    for (final n in scoreSplit) {
      add(setScore(n, x + i * ScoreConfig.w, y));
      i++;
    }
  }
}

class Storage {
  Future<String> get _localPath async {
    final _path = await getApplicationDocumentsDirectory();
    return _path.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    File file = new File('$path/score.txt');

    if (!file.existsSync()) {
      file.createSync();
      writeInit(file);
    }
    return file;
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      var contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeInit(File file) async {
    int score = 123;
    return file.writeAsString('$score');
  }

  Future<File> writeCounter(score) async {
    final file = await _localFile;

    return file.writeAsString('$score');
  }
}
