mixin Transformable<T> {
  T transform();
}

extension TransformableList<T> on List<Transformable<T>> {
  List<T> transform() => map((item) => item.transform()).toList();
}
