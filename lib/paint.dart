import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Vẽ đường thẳng trong Flutter'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(200, 200),//kích thước của khu vực có thể vẽ
          painter: MyPainter(),//đảm nhiệm vẽ đối tượng trên màn hình.
        ),
      ),
    ),
  ));
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5;//độ dày đường vẽ

    final startPoint = Offset(50, 50);//điểm bắt đầu với tọa độ(50, 50)
    final endPoint = Offset(150, 150);//điểm kết thúc với tọa độ (150, 150)

    canvas.drawLine(startPoint, endPoint, paint);//drawLine là phương thức của đối tượng canvas, được sử dụng để vẽ một đường thẳng trên màn hình.
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
  //shouldRepaint xác định xem có cần vẽ lại khi có sự thay đổi hay không. Trong trường hợp này, nó trả về false, có nghĩa là không cần vẽ lại khi có thay đổi.
}

