import 'package:wave_function_collapse/constraint.dart';
import 'package:wave_function_collapse/superposition_field.dart';

class SuperpositionBoard<T> {
  final List<SuperpositionField<T>> fields;
  final List<Constraint<T>> constraints;

  SuperpositionBoard({
    required this.fields,
    required this.constraints,
  });

  bool get isCollapsed => fields.every((field) => field.isCollapsed);

  /// Running this method will run every [Constrain].
  ///
  /// This is needed in the case that your board is naively filled with fields,
  /// i.e. there are values, which actually contradict some [Constraint]s.
  ///
  /// You only need to call this method once, right before the
  /// [WaveFunctionCollapse.run()].
  ///
  /// If you are not overly concerned with performance, you can run this method
  /// just to be sure.
  /// If your values are already properly restricted, this method is unnecessary
  /// and can be skipped.
  void initialConstrain() {
    for (Constraint<T> constraint in constraints) {
      constraint.constrain();
    }
  }

  Iterable<SuperpositionField<T>> getFieldsWithMinimalEntropy() {
    // We have to restrict ourselves to the not collapsed fields, because they
    // have an entropy of 1, which is always minimal.
    Iterable<SuperpositionField<T>> notCollapsedFields =
        fields.where((field) => !field.isCollapsed);

    if (notCollapsedFields.isEmpty) {
      return [];
    }

    int minimalEntropy = notCollapsedFields
        .map<int>((field) => field.entropy)
        .reduce((minEntropy, entropy) =>
            entropy < minEntropy ? entropy : minEntropy);

    return fields.where((field) => field.entropy == minimalEntropy);
  }

  Set<SuperpositionField<T>> constrain(SuperpositionField<T> lastAction) {
    Set<SuperpositionField<T>> changed = {};

    for (Constraint<T> constraint in constraints) {
      if (constraint.appliesTo(lastAction)) {
        changed.addAll(constraint.constrain());
      }
    }

    return changed;
  }

  @override
  String toString() {
    return '''
SuperpositionBoard(
  $fields
)
''';
  }
}
