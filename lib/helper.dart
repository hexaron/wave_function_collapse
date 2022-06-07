/// Input: {1, 2}, {3, 4, 5}.
/// Output: [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5].
Iterable<List<T>> cartesianProduct<T>(Iterable<Set<T>> lists) sync* {
  if (lists.isEmpty) {
    yield* [];
  } else if (lists.length == 1) {
    yield* lists.first.map((e) => [e]);
  } else {
    for (T head in lists.first) {
      for (List<T> tail in cartesianProduct(lists.skip(1))) {
        yield [head, ...tail];
      }
    }
  }
}
