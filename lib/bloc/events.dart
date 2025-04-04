// BLoC Events
import '../model/diamond.dart';

abstract class DiamondFilterEvent {}

class LoadDataEvent extends DiamondFilterEvent {}

class ApplyFilterEvent extends DiamondFilterEvent {
  final String lab;
  final String shape;
  final String color;
  final String clarity;

  ApplyFilterEvent({
    required this.lab,
    required this.shape,
    required this.color,
    required this.clarity,
  });
}

// BLoC State
class DiamondFilterState {
  final List<Diamond> diamonds;
  final List<Diamond> filteredDiamonds;

  DiamondFilterState({
    this.diamonds = const [],
    this.filteredDiamonds = const [],
  });
}
