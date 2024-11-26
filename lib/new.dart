import 'dart:ui';

import 'package:flutter/material.dart';

import 'widget.dart';

class AnimatedDock extends StatefulWidget {
  const AnimatedDock({super.key});

  @override
  State<AnimatedDock> createState() => _AnimatedDockState();
}

class _AnimatedDockState extends State<AnimatedDock> {
  int? hoveredIndex;
  int? draggedIndex;
  late double baseItemHeight;
  late double baseTranslationY;
  late double verticalItemsPadding;

  @override
  void initState() {
    super.initState();
    hoveredIndex = null;
    draggedIndex = null;
    baseItemHeight = 70;
    verticalItemsPadding = 20;
    baseTranslationY = 0.0;
  }

  double getScaledSize(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseItemHeight,
      maxValue: 90,
      nonHoveredMaxValue: 60,
    );
  }

  double getTranslationY(int index) {
    return getPropertyValue(
      index: index,
      baseValue: baseTranslationY,
      maxValue: -20,
      nonHoveredMaxValue: -10,
    );
  }

  double getPropertyValue({
    required int index,
    required double baseValue,
    required double maxValue,
    required double nonHoveredMaxValue,
  }) {
    if (hoveredIndex == null) return baseValue;

    final difference = (hoveredIndex! - index).abs();
    const itemsAffected = 2;

    if (difference == 0) {
      return maxValue;
    } else if (difference <= itemsAffected) {
      final ratio = (itemsAffected - difference + 1) / (itemsAffected + 1);
      return lerpDouble(baseValue, nonHoveredMaxValue, ratio)!;
    } else {
      return baseValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              height: baseItemHeight + 20,
              left: 0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(verticalItemsPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  items.length,
                  (index) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        if (hoveredIndex != index) {
                          setState(() => hoveredIndex = index);
                        }
                      },
                      onExit: (_) {
                        if (hoveredIndex != null) {
                          setState(() => hoveredIndex = null);
                        }
                      },
                      child: DragTarget<int>(
                        onWillAcceptWithDetails: (data) => data.data != index,
                        onAcceptWithDetails: (draggedItemIndex) {
                          setState(() {
                            final item = items.removeAt(draggedItemIndex.data);
                            items.insert(index, item);
                          });
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Draggable<int>(
                            data: index,
                            onDragStarted: () =>
                                setState(() => draggedIndex = index),
                            onDragCompleted: () =>
                                setState(() => draggedIndex = null),
                            onDraggableCanceled: (_, __) =>
                                setState(() => draggedIndex = null),
                            feedback: Material(
                              color: Colors.transparent,
                              child: Transform.scale(
                                scale: 1.2,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: items[index],
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: const SizedBox.shrink(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              transform: Matrix4.identity()
                                ..translate(
                                  0.0,
                                  getTranslationY(index),
                                  0.0,
                                ),
                              height: getScaledSize(index),
                              width: getScaledSize(index),
                              alignment: AlignmentDirectional.bottomCenter,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: items[index],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<IconContainer> items = [
  const IconContainer(image: 'assets/images/app finder.png'),
  const IconContainer(image: 'assets/images/google chrome.png'),
  const IconContainer(image: 'assets/images/itunes apple music.png'),
  const IconContainer(image: 'assets/images/android studio.png'),
  const IconContainer(image: 'assets/images/apple app store.png'),
];
