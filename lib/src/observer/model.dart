part of 'observer.dart';

@immutable
abstract class Model extends ComparerList {
  Model copyWith();

  @override
  List<Object> get equals => [];
}