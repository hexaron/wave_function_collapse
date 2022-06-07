import 'dart:math';

import 'package:test/test.dart';
import 'package:wave_function_collapse/constraint.dart';
import 'package:wave_function_collapse/superposition_board.dart';
import 'package:wave_function_collapse/superposition_field.dart';
import 'package:wave_function_collapse/wave_function_collapse.dart';

/// For an explanation of this test, see _bin/wave_function_collapse.dart_
void main() {
  test(
    'should generate the correct sudoku',
    () async {
      // Arrange

      List<List<SuperpositionField<int>>> sudoku4By4 = [
        for (int i = 0; i < 4; i++)
          [
            for (int j = 0; j < 4; j++)
              SuperpositionField(values: {1, 2, 3, 4}, name: '($i,$j)')
          ]
      ];

      bool contains1Through4(List<int> values) {
        return values.contains(1) &&
            values.contains(2) &&
            values.contains(3) &&
            values.contains(4);
      }

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

      List<SuperpositionField<int>> blockAt(int i, int j) {
        return [
          sudoku4By4[i][j],
          sudoku4By4[i][j + 1],
          sudoku4By4[i + 1][j],
          sudoku4By4[i + 1][j + 1]
        ];
      }

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

      SuperpositionBoard<int> board = SuperpositionBoard(
        fields: [
          for (List<SuperpositionField<int>> row in sudoku4By4)
            for (SuperpositionField<int> field in row) field
        ],
        constraints: rowConstraints + columnConstraints + blockConstraints,
      );

      WaveFunctionCollapse<int> waveFunctionCollapse = WaveFunctionCollapse(
        board: board,
        random: Random(123),
      );

      // Act

      bool foundSolution = false;

      while (!foundSolution) {
        try {
          waveFunctionCollapse.run();

          foundSolution = true;
        } on EmptySuperpositionFieldException catch (e) {
          print('The algorithm took a wrong turn. Trying again...');
        }
      }

      List<List<int>> result = [
        for (int i = 0; i < 4; i++)
          [for (int j = 0; j < 4; j++) sudoku4By4[i][j].collapsedValue]
      ];

      // Assert

      expect(result, [
        [1, 3, 2, 4],
        [2, 4, 1, 3],
        [3, 1, 4, 2],
        [4, 2, 3, 1]
      ]);
    },
  );
}
