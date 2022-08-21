import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'double_indicator_state.freezed.dart';

@freezed
class DoubleIndicatorState with _$DoubleIndicatorState {
  factory DoubleIndicatorState({
    required AnimationController activeScaleTextSizeController,
    required AnimationController activeScaleController,
    required Tween<double> activeScaleTextSizeTween,
    required Tween<double> activeScaleTween,
    @Default([]) List<int> scales,
    @Default(0) int currentValue,
  }) = _DoubleIndicatorState;
}
