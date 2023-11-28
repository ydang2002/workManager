import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Tạo và lưu trữ VideoPlayerController. Bộ điều khiển VideoPlayer
    // cung cấp một số hàm tạo khác nhau để phát video từ nội dung, tệp,
    // hoặc internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    // Khởi động lại controller và lưu trữ tương lai để sử dụng sau.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Dùng controller để lặp video
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Đảm bảo loại bỏ VideoPlayerController để giải phóng tài nguyên.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Video'),
      ),
      // Sử dụng FutureBuilder để hiển thị vòng quay một loading spinner trong khi chờ
      // VideoPlayerController để hoàn tất quá trình khởi tạo.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Nếu VideoPlayerController đã khởi tạo xong, hãy sử dụng
            // dữ liệu nó cung cấp để giới hạn tỷ lệ khung hình của video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // Nếu VideoPlayerController vẫn đang khởi chạy, hãy hiển thị
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Kết thúc quá trình phát hoặc tạm dừng trong lệnh gọi tới `setState`. Điều này đảm bảo
          // biểu tượng đúng được hiển thị.
          setState(() {
           //nếu video đang phát hãy tạm dừng
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // nếu video dừng hãy phát nó
              _controller.play();
            }
          });
        },
        // Hiển thị biểu tượng chính xác tùy theo trạng thái của palyer.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}