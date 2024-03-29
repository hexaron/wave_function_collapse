class SuperpositionField<T> {
  Set<T> values;

  final String? name;

  SuperpositionField({
    required this.values,
    this.name,
  });

  bool get isCollapsed => values.length == 1;

  int get entropy => values.length;

  T get collapsedValue {
    assert(
      isCollapsed,
      'Can only get [collapsedValue] on a [collapsed] [SuperpositionField]: $this',
    );

    return values.first;
  }

  void collapseTo(T value) {
    values = {value};
  }

  void constrainTo(Set<T> values) {
    if (values.isEmpty) {
      throw WaveFunctionCollapseException();
    }

    this.values = values;
  }

  @override
  String toString() {
    String nameString = name == null ? '' : '$name: ';

    if (isCollapsed) {
      return '$nameString$collapsedValue';
    }

    int length = values.length;

    if (length <= 5) {
      return '$nameString$values';
    }

    return '$nameString{${values.elementAt(0)}, ${values.elementAt(1)}, ..., ${values.elementAt(length - 2)}, ${values.elementAt(length - 1)}}';
  }
}

/// Gets thrown, when the algorithm arrived at a situation, where there is a
/// [SuperpositionField] for which no value can be chosen, because each would
/// contradict a [Constraint].
class WaveFunctionCollapseException implements Exception {}
