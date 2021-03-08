class HorizonConfig {
  static double w = 2400 / 3;
  static double h = 38.0;
  static double y = 104.0;
  static double x = 2.0;
}

class CloudConfig {
  static double w = 92.0;
  static double h = 28.0;
  static double y = 2.0;
  static double x = 166.0;
}

class DinoConfig {
  static double h = 94.0;
  static double y = 2.0;
}

class DinoJumpConfig {
  static double w = 88.0;
  static double x = 1336.5;
}

class DinoWaitConfig {
  static double w = 88.0;
  static double x = 1336.5 + 88;
}

class DinoRunConfig {
  static double w = 88;
  static List<double> x = [1336.5 + (88 * 2), 1336.5 + (88 * 3)];
}

class DinoDieConfig {
  static double w = 88;
  static double x = 1336.5 + (88 * 4);
}

class DinoDownConfig {
  static double w = 118;
  static List<double> x = [1866.0, 1866.0 + 118];
}

class CactusConfig {
  static double minDistance = 281;

  final double w;
  final double h;
  final double y;
  final double x;

  const CactusConfig._internal({
    this.w,
    this.h,
    this.y,
    this.x,
  });

  static List<CactusConfig> list = [
    CactusConfig._internal(w: 68, h: 70, y: 2, x: 446),
    CactusConfig._internal(w: 136, h: 70, y: 2, x: 514),
    CactusConfig._internal(w: 98, h: 100, y: 2, x: 752),
    CactusConfig._internal(w: 200, h: 100, y: 2, x: 752),
  ];
}
