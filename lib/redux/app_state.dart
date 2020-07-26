class AppState {
  final int counter;

  AppState({
    this.counter = 0,
  });

  @override
  String toString() => 'AppState(counter: $counter)';

  AppState copyWith({
    int counter,
  }) {
    return AppState(
      counter: counter ?? this.counter,
    );
  }
}
