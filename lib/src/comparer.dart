import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

extension MapEx<K, V> on Map<K, V> {
  String toNormalizeString() => toString().replaceAll(RegExp(r'^{|}$'), '');
}

extension ListEx<E> on List<E> {
  String toNormalizeString() => toString().replaceAll(RegExp(r'^\[|\]$'), '');
}

abstract class Comparer<T> {
  T get equals;

  @override
  int get hashCode;

  @override
  bool operator ==(Object other);

  @override
  String toString();

  @protected
  static const DeepCollectionEquality _equality = DeepCollectionEquality();

  bool compareLists<T>(List<T> list1, List<T> list2) {
    if (identical(list1, list2)) return true;
    if (list1 == null || list2 == null) return false;
    final int length = list1.length;
    if (length != list2.length) return false;

    for (int i = 0; i < length; i++) {
      final dynamic unit1 = list1[i];
      final dynamic unit2 = list2[i];

      if (unit1 is Iterable || unit1 is Map) {
        if (!_equality.equals(unit1, unit2)) return false;
      } else if (unit1?.runtimeType != unit2?.runtimeType) {
        return false;
      } else if (unit1 != unit2) {
        return false;
      }
    }
    return true;
  }

  int genHash(Iterable<Object> values) {
    return _finish(values?.fold(0, _combine) ?? 0);
  }

  @nonVirtual
  int _combine(int hash, dynamic object) {
    if (object is Map) {
      object.forEach((dynamic key, dynamic value) {
        hash = hash ^ _combine(hash, <dynamic>[key, value]);
      });
      return hash;
    }
    if (object is Iterable) {
      for (final dynamic value in object) {
        hash = hash ^ _combine(hash, value);
      }
      return hash ^ object.length;
    }

    hash = 0x1fffffff & (hash + object.hashCode);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  @nonVirtual
  int _finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class ComparerList with Comparer<List<Object>> {
  @override
  List<Object> get equals;

  @override
  int get hashCode => runtimeType.hashCode ^ super.genHash(equals);

  @override
  bool operator ==(Object other) =>
      (identical(this, other)) ||
      other is ComparerList && runtimeType == other.runtimeType && compareLists(other.equals.toList(), equals.toList());

  @override
  String toString() => '$runtimeType(${equals.toNormalizeString()})';
}

abstract class ComparerMap with Comparer<Map<String, Object>> {
  Map<String, Object> get equals;

  @override
  int get hashCode => runtimeType.hashCode ^ genHash(equals.values);

  @override
  bool operator ==(Object other) =>
      (identical(this, other)) ||
      other is ComparerMap &&
          runtimeType == other.runtimeType &&
          compareLists(other.equals.values.toList(), equals.values.toList());

  @override
  String toString() => '$runtimeType(${equals.toNormalizeString()})';
}
