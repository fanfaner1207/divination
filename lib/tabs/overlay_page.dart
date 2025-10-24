import 'package:flutter/material.dart';

class DrawingOverlay extends StatefulWidget {
  final VoidCallback onDrawingComplete;
  final Function(List<double>) onValuesUpdated;

  const DrawingOverlay({
    super.key,
    required this.onDrawingComplete,
    required this.onValuesUpdated,
  });

  @override
  State<DrawingOverlay> createState() => _DrawingOverlayState();
}

class _DrawingOverlayState extends State<DrawingOverlay> {
  List<Offset> points = [];
  double _startProduct = 0.0;
  double _panSumOfProducts = 0.0;
  double _endProduct = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          points.clear(); // 開始新的繪製時清空點
          _panSumOfProducts = 0.0; // 重置總和
          Offset point = details.localPosition;
          points.add(point);
          _startProduct = point.dx * point.dy;
          _panSumOfProducts += _startProduct; // 將起始點也加入總和
        });
      },
      onPanUpdate: (details) {
        setState(() {
          Offset point = details.localPosition;
          points.add(point);
          _panSumOfProducts += point.dx * point.dy;
        });
      },
      onPanEnd: (details) {
        if (points.isNotEmpty) {
          _endProduct = points.last.dx * points.last.dy;
        }
        widget.onDrawingComplete(); //關閉繪製層
        widget.onValuesUpdated([_startProduct, _panSumOfProducts, _endProduct]); // 傳遞三個值
      },
      //CustomPaint 繪製軌跡
      //DrawingPainter 負責具體繪製邏輯

      //RepaintBoundary 包裹 CustomPaint，隔離繪製層的重繪範圍：
      child: CustomPaint(painter: DrawingPainter(points), child: Container()),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset> points;
  DrawingPainter(this.points);

  //paint()：遍歷所有點，用 drawLine 繪製連續線段。
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint() //Paint用於繪圖。
          ..color = Colors.red
          ..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round;
    // color 設定為紅色 (Colors.red)。
    // strokeWidth 設定為 5.0，表示線條的寬度。
    // strokeCap 設定為 StrokeCap.round，表示線條的端點是圓形的。

    for (int i = 0; i < points.length - 1; i++) {
      // for迴圈points 列表中的所有點
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  //shouldRepaint()：永遠返回 true，表示每次重繪時都更新。
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
