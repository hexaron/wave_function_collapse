import 'dart:math';

import 'package:wave_function_collapse/constraint.dart';
import 'package:wave_function_collapse/superposition_board.dart';
import 'package:wave_function_collapse/superposition_field.dart';
import 'package:wave_function_collapse/wave_function_collapse.dart';

void main(List<String> arguments) {
  // First we define all of our [SuperpositionField]s we need for the
  // experiment.

  // We store them in our own representation of the data.
  List<List<SuperpositionField<int>>> sudoku4By4 = [
    for (int i = 0; i < 4; i++)
      [
        for (int j = 0; j < 4; j++)
          SuperpositionField(values: {1, 2, 3, 4}, name: '($i,$j)')
      ]
  ];

  // Next we define all the [Constraints] on the data.

  bool contains1Through4(List<int> values) =>
      values.contains(1) &&
      values.contains(2) &&
      values.contains(3) &&
      values.contains(4);

  List<Constraint<int>> rowConstraints = [
    for (int i = 0; i < 4; i++)
      Constraint(
        fields: [for (int j = 0; j < 4; j++) sudoku4By4[i][j]],
        isValid: (collapsedFields) => contains1Through4(collapsedFields),
      )
  ];

  List<Constraint<int>> columnConstraints = [
    for (int j = 0; j < 4; j++)
      Constraint(
        fields: [for (int i = 0; i < 4; i++) sudoku4By4[i][j]],
        isValid: contains1Through4,
      )
  ];

  List<SuperpositionField<int>> blockAt(int i, int j) => [
        sudoku4By4[i][j],
        sudoku4By4[i][j + 1],
        sudoku4By4[i + 1][j],
        sudoku4By4[i + 1][j + 1]
      ];

  List<Constraint<int>> blockConstraints = [
    Constraint(
      fields: blockAt(0, 0),
      isValid: contains1Through4,
    ),
    Constraint(
      fields: blockAt(2, 0),
      isValid: contains1Through4,
    ),
    Constraint(
      fields: blockAt(0, 2),
      isValid: contains1Through4,
    ),
    Constraint(
      fields: blockAt(2, 2),
      isValid: contains1Through4,
    )
  ];

  // Next we construct the [SuperpositionBoard].

  SuperpositionBoard<int> board = SuperpositionBoard(
    fields: [
      for (List<SuperpositionField<int>> row in sudoku4By4)
        for (SuperpositionField<int> field in row) field
    ],
    constraints: rowConstraints + columnConstraints + blockConstraints,
  );

  // Finally we initialize the [WaveFunctionCollapse] algorithm.

  WaveFunctionCollapse<int> waveFunctionCollapse = WaveFunctionCollapse(
    board: board,
    random: Random(123),
  );

  // The last thing to do, is to run the algorithm as many times as needed, to
  // find a solution.

  bool foundSolution = false;

  while (!foundSolution) {
    try {
      waveFunctionCollapse.run();

      foundSolution = true;
    } on WaveFunctionCollapseException {
      print('The algorithm took a wrong turn. Trying again...');
    }
  }

  // We visualize the data

  for (int i = 0; i < 4; i++) {
    print(
        '${sudoku4By4[i][0].collapsedValue} ${sudoku4By4[i][1].collapsedValue} | ${sudoku4By4[i][2].collapsedValue} ${sudoku4By4[i][3].collapsedValue}');

    if (i == 1) {
      print('----+----');
    }
  }
}
