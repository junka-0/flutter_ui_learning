import 'package:flutter/animation.dart';
import 'package:flutter_ui_learning/studies/double_indicator/state/double_indicator_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DoubleIndicatorStateNotifier extends StateNotifier<DoubleIndicatorState> {
  DoubleIndicatorStateNotifier(DoubleIndicatorState state) : super(state);

  void textOnTap(int value) {
    final currentValue = state.currentValue + value;
    final scales = state.scales;

    if (currentValue < 0 || currentValue > scales.last) return;

    final length = scales.length;
    var newActiveScale = state.activeScaleTween.end;

    for (var i = 0; i < length; i++) {
      final currentScale = scales[i];
      final lastScale = i == 0 ? currentScale - 1 : scales[i - 1];
      if (currentValue > lastScale && currentValue <= currentScale) {
        newActiveScale = currentScale.toDouble();
        break;
      }
    }

    final oldActiveScale = state.activeScaleTween.end;
    if (oldActiveScale == newActiveScale) {
      state = state.copyWith(currentValue: currentValue);
      return;
    }

    state = state.copyWith(
      activeScaleTween:
          Tween<double>(begin: oldActiveScale, end: newActiveScale),
      currentValue: currentValue,
    );

    state.activeScaleController.reset();
    state.activeScaleController.forward();
    state.activeScaleTextSizeController.forward().then(
          (_) => state.activeScaleTextSizeController.reverse(),
        );
  }

  void sliderOnChanged(double value) {
    final scales = state.scales;
    final length = scales.length;
    var newActiveScale = state.activeScaleTween.end;
    for (var i = 0; i < length; i++) {
      final last = i == 0 ? 0 : scales[i - 1];
      final current = scales[i];
      if (value > last && value <= current) {
        newActiveScale = current.toDouble();
        break;
      }
    }

    final oldActiveScale = state.activeScaleTween.end;

    state = state.copyWith(
      activeScaleTween:
          Tween<double>(begin: oldActiveScale, end: newActiveScale),
      currentValue: value.toInt(),
    );

    if (oldActiveScale != newActiveScale) {
      Future.microtask(() => state.activeScaleTextSizeController.forward())
          .then(((_) => state.activeScaleTextSizeController.reverse()));
      state.activeScaleController.forward();
    }
  }

  @override
  void dispose() {
    state.activeScaleTextSizeController.dispose();
    state.activeScaleController.dispose();
    super.dispose();
  }
}
