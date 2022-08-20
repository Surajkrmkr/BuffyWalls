import 'dart:math';

class RandomWalls {
  final maxcount = 10;
  bringRandomWalls(int length) {
    return List.generate(maxcount, (_) => Random().nextInt(length));
  }
}
