/// Input: {1, 2}, {3, 4, 5}.
/// Output: [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5].
Iterable<List<T>> cartesianProduct<T>(Iterable<Set<T>> sets) sync* {
  if (sets.isEmpty) {
    yield* [];
  } else if (sets.length == 1) {
    yield* sets.first.map((e) => [e]);
  } else {
    for (T head in sets.first) {
      for (List<T> tail in cartesianProduct(sets.skip(1))) {
        yield [head, ...tail];
      }
    }
  }
}
