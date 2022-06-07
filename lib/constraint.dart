import 'package:collection/collection.dart';
import 'package:wave_function_collapse/superposition_field.dart';

import 'helper.dart';

class Constraint<T> {
  final List<SuperpositionField<T>> fields;
  final bool Function(List<T> collapsedFields) isValid;

  Constraint({
    required this.fields,
    required this.isValid,
  });

  /// Check if this constraint is relevant for this [field].
  bool appliesTo(SuperpositionField<T> field) {
    return fields.contains(field);
  }

  /// For each field in [fields], take the subset of the values, such that each
  /// value is justified, with regards to [isValid].
  ///
  /// Returns all the fields, where a proper subset was taken.
  /// I.e. all the fields, whose values were actually restricted.
  List<SuperpositionField<T>> constrain() {
    // The list of justified field values.
    List<Set<T>> fieldValues = List<Set<T>>.generate(fields.length, (_) => {});

    for (List<T> collapsedFields
        in cartesianProduct(fields.map((field) => field.values))) {
      if (isValid(collapsedFields)) {
        // We add the values from the valid [collapsedFields] to our
        // [fieldValues].
        for (int i = 0; i < fields.length; i++) {
          fieldValues[i].add(collapsedFields[i]);
        }
      }
    }

    // Now [fieldValues] contains all justified values.
    // Next we update all of our fields if necessary and return the ones, we
    // needed to change.

    List<SuperpositionField<T>> changedFields = [];

    for (int i = 0; i < fields.length; i++) {
      // Use a constant [SetEquality] to check whether the values have changed.
      if (!(const SetEquality()).equals(fields[i].values, fieldValues[i])) {
        fields[i].constrainTo(fieldValues[i]);

        changedFields.add(fields[i]);
      }
    }

    return changedFields;
  }
}
