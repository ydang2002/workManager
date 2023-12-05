import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    //jsonEncode giúp bạn biến đổi cấu trúc dữ liệu Dart thành một chuỗi JSON
    // hợp lệ để có thể được gửi đi thông qua request.
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String title;
//constructor và một factory constructor để tạo đối tượng Album từ dữ liệu JSON.
  const Album({required this.id, required this.title});
//Factory constructor này được sử dụng để tạo một đối tượng Album từ một đối tượng JSON (Map<String, dynamic>).
// Trong trường hợp này, nó thực hiện việc chuyển đổi dữ liệu từ dạng JSON sang đối tượng Dart.
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();//TextEditingController để quản lý dữ liệu đầu vào từ TextField.
  Future<Album>? _futureAlbum;//_futureAlbum để theo dõi kết quả của việc tạo mới album.
//buildColumn được gọi khi _futureAlbum là null (khi chưa có album nào được tạo mới),
// ngược lại sẽ gọi buildFutureBuilder.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }
//Khi nút được nhấn, _futureAlbum sẽ được cập nhật và gọi lại build để cập nhật giao diện.
  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_controller.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }
//Nếu có dữ liệu, hiển thị tiêu đề của album. Nếu có lỗi, hiển thị thông báo lỗi.
// Nếu đang chờ, hiển thị một CircularProgressIndicator.
  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
//_futureAlbum là một biến kiểu Future<Album> được cập nhật khi một album mới được tạo và dữ liệu được đọc từ server.
//snapshot: Một đối tượng AsyncSnapshot<T> chứa thông tin về trạng thái của Future.