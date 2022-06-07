import 'dart:math';

import 'package:test/test.dart';
import 'package:wave_function_collapse/constraint.dart';
import 'package:wave_function_collapse/superposition_board.dart';
import 'package:wave_function_collapse/superposition_field.dart';
import 'package:wave_function_collapse/wave_function_collapse.dart';

/// For an explanation of this test, see *bin/wave_function_collapse.dart*
void main() {
  late List<List<SuperpositionField<int>>> sudoku4By4;

  late bool Function(List<int> values) contains1Through4;

  late List<Constraint<int>> rowConstraints;
  late List<Constraint<int>> columnConstraints;
  late List<Constraint<int>> blockConstraints;

  late SuperpositionBoard<int> board;

  late WaveFunctionCollapse<int> waveFunctionCollapse;

  List<SuperpositionField<int>> blockAt(int i, int j) => [
        sudoku4By4[i][j],
        sudoku4By4[i][j + 1],
        sudoku4By4[i + 1][j],
        sudoku4By4[i + 1][j + 1]
      ];

  setUp(() {
    sudoku4By4 = [
      for (int i = 0; i < 4; i++)
        [
          for (int j = 0; j < 4; j++)
            SuperpositionField(values: {1, 2, 3, 4}, name: '($i,$j)')
        ]
    ];

    contains1Through4 = (values) =>
        values.contains(1) &&
        values.contains(2) &&
        values.contains(3) &&
        values.contains(4);

    rowConstraints = [
      for (int i = 0; i < 4; i++)
        Constraint(
          fields: [for (int j = 0; j < 4; j++) sudoku4By4[i][j]],
          isValid: (collapsedFields) => contains1Through4(collapsedFields),
        )
    ];

    columnConstraints = [
      for (int j = 0; j < 4; j++)
        Constraint(
          fields: [for (int i = 0; i < 4; i++) sudoku4By4[i][j]],
          isValid: contains1Through4,
        )
    ];

    blockConstraints = [
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

    board = SuperpositionBoard(
      fields: [
        for (List<SuperpositionField<int>> row in sudoku4By4)
          for (SuperpositionField<int> field in row) field
      ],
      constraints: rowConstraints + columnConstraints + blockConstraints,
    );

    waveFunctionCollapse = WaveFunctionCollapse(
      board: board,
      random: Random(123),
    );
  });

  test(
    'should generate a correct sudoku',
    () async {
      // Arrange

      // Act

      bool foundSolution = false;

      while (!foundSolution) {
        try {
          waveFunctionCollapse.runRandom();

          foundSolution = true;
        } on WaveFunctionCollapseException {
          print('The algorithm took a wrong turn. Trying again...');
        }
      }

      List<List<int>> result = [
        for (int i = 0; i < 4; i++)
          [for (int j = 0; j < 4; j++) sudoku4By4[i][j].collapsedValue]
      ];

      // Assert

      // We can expect this sudoku because of the fixed seed.
      expect(result, [
        [1, 3, 2, 4],
        [2, 4, 1, 3],
        [3, 1, 4, 2],
        [4, 2, 3, 1]
      ]);
    },
  );

  test(
    'should solve the sudoku',
    () async {
      // Arrange

      // The sudoku to solve is:
      // 2   |
      //   1 |   2
      // ----+----
      //     | 3
      //     |   4
      sudoku4By4[0][0].collapseTo(2);
      sudoku4By4[1][1].collapseTo(1);
      sudoku4By4[1][3].collapseTo(2);
      sudoku4By4[2][2].collapseTo(3);
      sudoku4By4[3][3].collapseTo(4);

      // Act

      waveFunctionCollapse.runUnique();

      List<List<int>> result = [
        for (int i = 0; i < 4; i++)
          [for (int j = 0; j < 4; j++) sudoku4By4[i][j].collapsedValue]
      ];

      // Assert

      expect(result, [
        [2, 4, 1, 3],
        [3, 1, 4, 2],
        [4, 2, 3, 1],
        [1, 3, 2, 4]
      ]);
    },
  );
}
