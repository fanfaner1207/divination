import 'package:flutter/material.dart';

class DrawingOverlay extends StatefulWidget {
  final VoidCallback onDrawingComplete;
  final Function(double) onSumOfProductsUpdated;

  const DrawingOverlay({
    super.key,
    required this.onDrawingComplete,
    required this.onSumOfProductsUpdated,
  });

  @override
  State<DrawingOverlay> createState() => _DrawingOverlayState();
}

class _DrawingOverlayState extends State<DrawingOverlay> {
  List<Offset> points = [];
  double sumOfProducts = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          Offset point = details.localPosition;
          points.add(point);
          sumOfProducts = point.dx * point.dy;
        });
      },
      onPanEnd: (details) {
        widget.onDrawingComplete(); //關閉繪製層
        widget.onSumOfProductsUpdated(sumOfProducts); // 傳遞 sumOfProducts 的值
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

// class OverlayPage extends StatefulWidget {
//   final Function(double) onSumOfProductsUpdated;
//   const OverlayPage({super.key, required this.onSumOfProductsUpdated});

//   @override
//   State<OverlayPage> createState() => OverlayPageState();
// }

// // 管理覆蓋層的顯示與隱藏，並將 sumOfProducts 傳遞給父組件。
// class OverlayPageState extends State<OverlayPage> {
//   OverlayEntry? overlayEntry;

//   void showOverlay(BuildContext context) {
//     overlayEntry = OverlayEntry(
//       builder:
//           (context) => Positioned(
//             // top: 200,
//             // bottom: 200,
//             // left: 100,
//             // right: 100,
//             top: MediaQuery.of(context).size.height * 0.1,
//             bottom: MediaQuery.of(context).size.height * 0.1,
//             left: MediaQuery.of(context).size.width * 0.1,
//             right: MediaQuery.of(context).size.width * 0.1,
//             child: Container(
//               // color: Colors.white.withValues(),
//               color: Colors.white.withOpacity(0.8),
//               child: DrawingOverlay(
//                 onDrawingComplete: () {
//                   overlayEntry?.remove();
//                 },
//                 onSumOfProductsUpdated: widget.onSumOfProductsUpdated,
//               ),
//             ),
//           ),
//     );

//     Overlay.of(context).insert(overlayEntry!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox.shrink(); // 此頁面僅用於控制覆蓋層
//   }
// }
