import 'dart:math';

import 'package:wave_function_collapse/superposition_board.dart';
import 'package:wave_function_collapse/superposition_field.dart';

class WaveFunctionCollapse {
  final SuperpositionBoard board;
  final Random random;

  WaveFunctionCollapse({
    required this.board,
    required this.random,
  });

  SuperpositionBoard run() {
    while (!board.isCollapsed) {
      step();
    }

    return board;
  }

  void step() {
    List<SuperpositionField> minimalEntropyFields =
        board.getFieldsWithMinimalEntropy().toList();

    if (minimalEntropyFields.isEmpty) {
      return;
    }

    SuperpositionField randomField = _chooseRandom(minimalEntropyFields);

    assert(randomField.entropy >= 2);

    int randomValue = _chooseRandom(randomField.values.toList());

    randomField.collapseTo(randomValue);

    propagate(randomField);
  }

  void propagate(SuperpositionField collapsedField) {
    Set<SuperpositionField> stack = {collapsedField};

    while (stack.isNotEmpty) {
      SuperpositionField field = stack.first;
      stack.remove(field);

      stack.addAll(board.constrain(field));
    }
  }

  T _chooseRandom<T>(List<T> list) {
    return list[random.nextInt(list.length)];
  }
}
