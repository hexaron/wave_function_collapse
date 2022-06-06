import 'package:test/test.dart';
import 'package:wave_function_collapse/helper.dart';

void main() {
  group('_cartesianProduct', () {
    test(
      'should return no tuple for no set',
      () async {
        // Arrange
        List<Set<int>> sets = [];

        // Act
        Iterable<List<int>> result = cartesianProduct(sets);

        // Assert
        expect(result, []);
      },
    );

    test(
      'should return no tuple for empty set',
      () async {
        // Arrange
        List<Set<int>> sets = [{}];

        // Act
        Iterable<List<int>> result = cartesianProduct(sets);

        // Assert
        expect(result, []);
      },
    );

    test(
      'should return single tuples for single set',
      () async {
        // Arrange
        List<Set<int>> sets = [
          {1, 2, 3}
        ];
        // Act
        Iterable<List<int>> result = cartesianProduct(sets);

        // Assert
        expect(result, [
          [1],
          [2],
          [3]
        ]);
      },
    );

    test(
      'should return the cartesian product of two single sets',
      () async {
        // Arrange
        List<Set<int>> sets = [
          {1},
          {2}
        ];

        // Act
        Iterable<List<int>> result = cartesianProduct(sets);

        // Assert
        expect(result.toList(), [
          [1, 2]
        ]);
      },
    );

    test(
      'should return all tuples from the cartesian product',
      () async {
        // Arrange
        List<Set<int>> sets = [
          {1, 2},
          {3, 4, 5}
        ];

        // Act
        Iterable<List<int>> result = cartesianProduct(sets);

        // Assert
        expect(result.toList(), [
          [1, 3],
          [1, 4],
          [1, 5],
          [2, 3],
          [2, 4],
          [2, 5]
        ]);
      },
    );
  });
}
