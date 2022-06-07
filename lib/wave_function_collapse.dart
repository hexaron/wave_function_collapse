import 'dart:math';

import 'package:wave_function_collapse/superposition_board.dart';
import 'package:wave_function_collapse/superposition_field.dart';

class WaveFunctionCollapse<T> {
  final SuperpositionBoard<T> board;
  final Random random;

  WaveFunctionCollapse({
    required this.board,
    required this.random,
  });

  SuperpositionBoard<T> run() {
    while (!board.isCollapsed) {
      step();
    }

    return board;
  }

  void step() {
    List<SuperpositionField<T>> minimalEntropyFields =
        board.getFieldsWithMinimalEntropy().toList();

    if (minimalEntropyFields.isEmpty) {
      return;
    }

    SuperpositionField<T> randomField = _chooseRandom(minimalEntropyFields);

    assert(randomField.entropy >= 2);

    T randomValue = _chooseRandom(randomField.values.toList());

    randomField.collapseTo(randomValue);

    propagate(randomField);
  }

  void propagate(SuperpositionField<T> collapsedField) {
    Set<SuperpositionField<T>> stack = {collapsedField};

    while (stack.isNotEmpty) {
      SuperpositionField<T> field = stack.first;
      stack.remove(field);

      stack.addAll(board.constrain(field));
    }
  }

  T _chooseRandom<T>(List<T> list) {
    return list[random.nextInt(list.length)];
  }
}
