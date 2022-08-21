import 'package:flutter/material.dart';
import 'package:flutter_ui_learning/studies/double_indicator/component/double_indicator.dart';
import 'package:flutter_ui_learning/studies/double_indicator/state/double_indicator_state.dart';
import 'package:flutter_ui_learning/studies/double_indicator/state/double_indicator_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final doubleIndicatorStateNotifierFamilyProvider =
    StateNotifierProvider.autoDispose.family<
        DoubleIndicatorStateNotifier,
        DoubleIndicatorState,
        DoubleIndicatorStateNotifier
            Function()>((ref, initialProcess) => initialProcess());

final doubleIndicatorStateNotifierProvider = StateNotifierProvider.autoDispose<
    DoubleIndicatorStateNotifier,
    DoubleIndicatorState>((ref) => throw UnimplementedError());

class DoubleIndicatorScreen extends StatefulWidget {
  const DoubleIndicatorScreen({Key? key}) : super(key: key);

  @override
  State<DoubleIndicatorScreen> createState() => _DoubleIndicatorScreenState();
}

class _DoubleIndicatorScreenState extends State<DoubleIndicatorScreen>
    with TickerProviderStateMixin {
  DoubleIndicatorStateNotifier _initialProcess() {
    final activeScaleTextSizeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    final activeScaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final initialState = DoubleIndicatorState(
      activeScaleTextSizeController: activeScaleTextSizeController,
      activeScaleController: activeScaleController,
      activeScaleTextSizeTween: Tween<double>(begin: 1.0, end: 3.0),
      activeScaleTween: Tween<double>(begin: 0.0, end: 0.0),
      scales: [0, 10, 20, 30, 40, 50],
    );

    return DoubleIndicatorStateNotifier(initialState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ProviderScope(
        overrides: [
          doubleIndicatorStateNotifierProvider.overrideWithProvider(
            doubleIndicatorStateNotifierFamilyProvider(_initialProcess),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._buttons(),
              _indicator(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buttons() {
    return [
      Consumer(
        builder: (context, ref, child) {
          return TextButton(
            onPressed: () {
              ref
                  .read(doubleIndicatorStateNotifierProvider.notifier)
                  .textOnTap(1);
            },
            child: const Text(
              '+',
              style: TextStyle(
                fontSize: 48.0,
              ),
            ),
          );
        },
      ),
      Consumer(
        builder: (context, ref, child) {
          return TextButton(
            onPressed: () {
              ref
                  .read(doubleIndicatorStateNotifierProvider.notifier)
                  .textOnTap(-1);
            },
            child: const Text(
              '-',
              style: TextStyle(
                fontSize: 48.0,
              ),
            ),
          );
        },
      ),
    ];
  }

  Widget _indicator() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.read(doubleIndicatorStateNotifierProvider);
        final activeScaleTextSizeController =
            state.activeScaleTextSizeController;
        final activeScaleController = state.activeScaleController;

        final activeScaleTextSizeTween = ref.watch(
            doubleIndicatorStateNotifierProvider
                .select((value) => value.activeScaleTextSizeTween));
        final activeScaleTween = ref.watch(doubleIndicatorStateNotifierProvider
            .select((value) => value.activeScaleTween));
        final scales = ref.watch(doubleIndicatorStateNotifierProvider
            .select((value) => value.scales));
        final currentValue = ref.watch(doubleIndicatorStateNotifierProvider
            .select((value) => value.currentValue));

        return AnimatedBuilder(
          animation: Listenable.merge(
            [activeScaleTextSizeController, activeScaleController],
          ),
          builder: (context, snapshot) {
            return DoubleIndicator(
              width: double.infinity,
              indicatorLineHeight: 8.0,
              indicatorLineBorderRadius: 4.0,
              indicatorLineBorderColor: Colors.black38,
              indicatorLineBackgroundColor: Colors.black12,
              indicatorLineActiveScaleColor: Colors.lightBlue.shade300,
              indicatorScales: scales,
              indicatorScalesTextStyle: const TextStyle(
                color: Colors.black12,
              ),
              indicatorActiveScale: activeScaleTween.end ?? 0.0,
              indicatorActiveScaleAnimationValue:
                  activeScaleTween.animate(activeScaleController).value,
              indicatorActiveScaleTextStyle: TextStyle(
                color: Colors.lightBlue,
                fontSize: 14.0 *
                    activeScaleTextSizeTween
                        .animate(activeScaleTextSizeController)
                        .value,
                fontWeight: FontWeight.bold,
              ),
              indicatorLineCurrentValueColor: Colors.blue.shade900,
              indicatorCurrentValue: currentValue.toDouble(),
              indicatorCurrentValueTextStyle: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
              indicatorDotRadius: 6.0,
              indicatorDotColor: Colors.blue.shade900,
              spaceBetweenTopRowAndIndicator: 4.0,
              spaceBetweenIndicatorAndBottomRow: 4.0,
            );
          },
        );
      },
    );
  }
}
