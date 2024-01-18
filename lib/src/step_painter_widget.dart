import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stepper_theme_data.dart';

class StepPainterWidget extends StatelessWidget {
  final PreferredSizeWidget stepperAvatar;
  final Widget stepperContent;
  final bool isLast;
  final PreferredSizeWidget stepperWidget;

  const StepPainterWidget({
    required this.stepperAvatar,
    required this.stepperContent,
    required this.isLast,
    super.key,
    required this.stepperWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomPaint(
            painter: RootPainter(
              stepperAvatar.preferredSize,
              context.watch<StepperThemeData>().lineColor,
              context.watch<StepperThemeData>().lineWidth,
              Directionality.of(context),
              isLast,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                stepperAvatar,
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                          right: 5,
                        ),
                        child: stepperWidget,
                      ),
                      stepperContent,
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RootPainter extends CustomPainter {
  Size? avatar;
  late Paint _paint;
  Color? pathColor;
  double? strokeWidth;
  final TextDirection textDecoration;
  final bool isLast;

  RootPainter(this.avatar, this.pathColor, this.strokeWidth, this.textDecoration, this.isLast) {
    _paint = Paint()
      ..color = pathColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (textDecoration == TextDirection.rtl) {
      canvas.translate(size.width, 0);
    }
    double dx = avatar!.width / 2;
    if (textDecoration == TextDirection.rtl) {
      dx *= -1;
    }
    if (!isLast) {
      _drawDashedLine(canvas, Offset(dx, avatar!.height), Offset(dx, size.height));
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, {double startPadding = 20.0, double endPadding = 00.0}) {
    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    double distance = end.dy - start.dy;
    double currentDistance = 0.0;

    double drawingDistance = distance - startPadding - endPadding;
    if (drawingDistance <= 0) return;

    currentDistance += startPadding;

    while (currentDistance + dashWidth < drawingDistance) {
      final double x = start.dx;
      final double y = start.dy + currentDistance;
      canvas.drawLine(Offset(x, y), Offset(x, y + dashWidth), _paint);
      currentDistance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
