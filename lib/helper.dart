/// Input: {1, 2}, {3, 4, 5}.
/// Output: [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5].
Iterable<List<int>> cartesianProduct(Iterable<Set<int>> lists) sync* {
  if (lists.isEmpty) {
    yield* [];
  } else if (lists.length == 1) {
    yield* lists.first.map((e) => [e]);
  } else {
    for (int head in lists.first) {
      for (List<int> tail in cartesianProduct(lists.skip(1))) {
        yield [head, ...tail];
      }
    }
  }
}
