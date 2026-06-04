import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TetrisPage extends StatefulWidget {
  const TetrisPage({super.key});

  @override
  State<TetrisPage> createState() => _TetrisPageState();
}

class _TetrisPageState extends State<TetrisPage> {
  static const int boardWidth = 10;
  static const int boardHeight = 20;

  final Random _random = Random();
  late List<List<int?>> _board;
  late _Piece _piece;
  Timer? _timer;
  int _score = 0;
  int _lines = 0;
  bool _isRunning = false;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetGame() {
    _timer?.cancel();
    _board = List.generate(
      boardHeight,
      (_) => List<int?>.filled(boardWidth, null),
    );
    _score = 0;
    _lines = 0;
    _isRunning = false;
    _isGameOver = false;
    _piece = _newPiece();
    setState(() {});
  }

  _Piece _newPiece() {
    final type = _random.nextInt(_pieceShapes.length);
    return _Piece(type: type, rotation: 0, x: 3, y: 0);
  }

  void _toggleRunning() {
    if (_isGameOver) {
      _resetGame();
    }

    setState(() => _isRunning = !_isRunning);
    _timer?.cancel();

    if (_isRunning) {
      _timer = Timer.periodic(const Duration(milliseconds: 520), (_) {
        _tick();
      });
    }
  }

  void _tick() {
    if (!_tryMove(dx: 0, dy: 1)) {
      _lockPiece();
      _clearLines();
      setState(() => _piece = _newPiece());

      if (!_canPlace(_piece)) {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
          _isGameOver = true;
        });
      }
    }
  }

  bool _tryMove({required int dx, required int dy}) {
    final moved = _piece.copyWith(x: _piece.x + dx, y: _piece.y + dy);
    if (!_canPlace(moved)) {
      return false;
    }
    setState(() => _piece = moved);
    return true;
  }

  void _rotate() {
    final rotated = _piece.copyWith(
      rotation: (_piece.rotation + 1) % _pieceShapes[_piece.type].length,
    );
    if (_canPlace(rotated)) {
      setState(() => _piece = rotated);
    }
  }

  void _drop() {
    while (_tryMove(dx: 0, dy: 1)) {}
    _tick();
  }

  bool _canPlace(_Piece piece) {
    for (final point in piece.cells) {
      if (point.x < 0 || point.x >= boardWidth) {
        return false;
      }
      if (point.y < 0 || point.y >= boardHeight) {
        return false;
      }
      if (_board[point.y][point.x] != null) {
        return false;
      }
    }
    return true;
  }

  void _lockPiece() {
    for (final point in _piece.cells) {
      if (point.y >= 0 && point.y < boardHeight) {
        _board[point.y][point.x] = _piece.type;
      }
    }
  }

  void _clearLines() {
    final remainingRows = _board
        .where((row) => row.any((cell) => cell == null))
        .map((row) => List<int?>.from(row))
        .toList();
    final cleared = boardHeight - remainingRows.length;

    if (cleared == 0) {
      setState(() {});
      return;
    }

    final newRows = List.generate(
      cleared,
      (_) => List<int?>.filled(boardWidth, null),
    );

    setState(() {
      _board = [...newRows, ...remainingRows];
      _lines += cleared;
      _score += cleared * cleared * 100;
    });
  }

  int? _cellValue(int x, int y) {
    for (final point in _piece.cells) {
      if (point.x == x && point.y == y) {
        return _piece.type;
      }
    }
    return _board[y][x];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final content = [
          _BoardView(cellValue: _cellValue),
          const SizedBox(width: 20, height: 20),
          _ControlPanel(
            score: _score,
            lines: _lines,
            isRunning: _isRunning,
            isGameOver: _isGameOver,
            onStartPause: _toggleRunning,
            onReset: _resetGame,
            onLeft: () => _tryMove(dx: -1, dy: 0),
            onRight: () => _tryMove(dx: 1, dy: 0),
            onRotate: _rotate,
            onDrop: _drop,
          ),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: content,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: content,
                ),
        );
      },
    );
  }
}

class _BoardView extends StatelessWidget {
  const _BoardView({required this.cellValue});

  final int? Function(int x, int y) cellValue;

  @override
  Widget build(BuildContext context) {
    final boardWidth = min(360.0, MediaQuery.sizeOf(context).width - 40);

    return SizedBox(
      width: boardWidth,
      child: AspectRatio(
        aspectRatio: _TetrisPageState.boardWidth / _TetrisPageState.boardHeight,
        child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF101828),
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _TetrisPageState.boardWidth * _TetrisPageState.boardHeight,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _TetrisPageState.boardWidth,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemBuilder: (context, index) {
            final x = index % _TetrisPageState.boardWidth;
            final y = index ~/ _TetrisPageState.boardWidth;
            final value = cellValue(x, y);

            return DecoratedBox(
              decoration: BoxDecoration(
                color: value == null
                    ? const Color(0xFF1D2939)
                    : _pieceColors[value],
                borderRadius: BorderRadius.circular(3),
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({
    required this.score,
    required this.lines,
    required this.isRunning,
    required this.isGameOver,
    required this.onStartPause,
    required this.onReset,
    required this.onLeft,
    required this.onRight,
    required this.onRotate,
    required this.onDrop,
  });

  final int score;
  final int lines;
  final bool isRunning;
  final bool isGameOver;
  final VoidCallback onStartPause;
  final VoidCallback onReset;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onRotate;
  final VoidCallback onDrop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tetris Workshop',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A playable mini game. Team members can improve rules, UI, themes, or scoring.',
                ),
                if (isGameOver) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Game over',
                    style: TextStyle(
                      color: Color(0xFFB42318),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          _PanelCard(
            child: Row(
              children: [
                Expanded(child: _ScoreItem(label: 'Score', value: '$score')),
                Expanded(child: _ScoreItem(label: 'Lines', value: '$lines')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onStartPause,
                  icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow),
                  label: Text(isRunning ? 'Pause' : 'Start'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Reset',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PanelCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      onPressed: onRotate,
                      icon: const Icon(Icons.rotate_right_rounded),
                      tooltip: 'Rotate',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      onPressed: onLeft,
                      icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      tooltip: 'Move left',
                    ),
                    const SizedBox(width: 16),
                    IconButton.filledTonal(
                      onPressed: onDrop,
                      icon: const Icon(Icons.keyboard_double_arrow_down_rounded),
                      tooltip: 'Drop',
                    ),
                    const SizedBox(width: 16),
                    IconButton.filledTonal(
                      onPressed: onRight,
                      icon: const Icon(Icons.keyboard_arrow_right_rounded),
                      tooltip: 'Move right',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E7EF)),
      ),
      child: child,
    );
  }
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(label),
      ],
    );
  }
}

class _Piece {
  const _Piece({
    required this.type,
    required this.rotation,
    required this.x,
    required this.y,
  });

  final int type;
  final int rotation;
  final int x;
  final int y;

  List<Point<int>> get cells {
    return _pieceShapes[type][rotation]
        .map((point) => Point<int>(point.x + x, point.y + y))
        .toList();
  }

  _Piece copyWith({
    int? type,
    int? rotation,
    int? x,
    int? y,
  }) {
    return _Piece(
      type: type ?? this.type,
      rotation: rotation ?? this.rotation,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}

const _pieceColors = [
  Color(0xFF2E90FA),
  Color(0xFFF04438),
  Color(0xFFFDB022),
  Color(0xFF12B76A),
  Color(0xFF7A5AF8),
  Color(0xFF06AED4),
  Color(0xFFEE46BC),
];

const _pieceShapes = [
  [
    [Point(0, 1), Point(1, 1), Point(2, 1), Point(3, 1)],
    [Point(2, 0), Point(2, 1), Point(2, 2), Point(2, 3)],
  ],
  [
    [Point(0, 0), Point(1, 0), Point(0, 1), Point(1, 1)],
  ],
  [
    [Point(1, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
    [Point(1, 0), Point(1, 1), Point(2, 1), Point(1, 2)],
    [Point(0, 1), Point(1, 1), Point(2, 1), Point(1, 2)],
    [Point(1, 0), Point(0, 1), Point(1, 1), Point(1, 2)],
  ],
  [
    [Point(1, 0), Point(2, 0), Point(0, 1), Point(1, 1)],
    [Point(1, 0), Point(1, 1), Point(2, 1), Point(2, 2)],
  ],
  [
    [Point(0, 0), Point(1, 0), Point(1, 1), Point(2, 1)],
    [Point(2, 0), Point(1, 1), Point(2, 1), Point(1, 2)],
  ],
  [
    [Point(0, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
    [Point(1, 0), Point(2, 0), Point(1, 1), Point(1, 2)],
    [Point(0, 1), Point(1, 1), Point(2, 1), Point(2, 2)],
    [Point(1, 0), Point(1, 1), Point(0, 2), Point(1, 2)],
  ],
  [
    [Point(2, 0), Point(0, 1), Point(1, 1), Point(2, 1)],
    [Point(1, 0), Point(1, 1), Point(1, 2), Point(2, 2)],
    [Point(0, 1), Point(1, 1), Point(2, 1), Point(0, 2)],
    [Point(0, 0), Point(1, 0), Point(1, 1), Point(1, 2)],
  ],
];
