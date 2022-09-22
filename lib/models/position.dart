class Position {
  final double x;
  final double y;

  const Position(this.x, this.y);

  factory Position.start() {
    return const Position(0, 0);
  }

  Position goUp() {
    return Position(x, y - 10);
  }

  Position goDown() {
    final pos = Position(x, y + 10);
    print(pos);
    return pos;
  }

  @override
  String toString() {
    return 'Position(x: $x, y: $y)';
  }
}
