import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import '';


const task = 'firstTask';//khởi tạo tên công việc nền
//Hàm này được sử dụng để xử lý công việc nền khi nó được kích hoạt.
// Trong trường hợp này, nó kiểm tra tên công việc và thực hiện một số công việc cụ thể nếu tên công việc là 'firstTask'
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    switch (taskName) {
      case 'firstTask':
      // do something
        break;
      default:
    }
    return Future.value(true);
  });
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();//Đảm bảo rằng các widget đã được khởi tạo.
  Workmanager().initialize(//khởi tạo workmanager
    callbackDispatcher,
    isInDebugMode: true,//Đặt chế độ debug
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
//Khi nút được nhấn, nó tạo một uniqueId dựa trên thời gian hiện tại và sử dụng Workmanager().registerOneOffTask(...)
// để đăng ký một công việc nền có tên là firstTask sẽ được thực hiện sau 1 giây, với ràng buộc là chỉ khi có kết nối mạng.
class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async{
          var uniqueId = DateTime.now().second.toString();
          await Workmanager().registerOneOffTask(uniqueId, task,
              initialDelay: Duration(seconds: 1),
              constraints: Constraints(networkType: NetworkType.connected));
        }, child: Text("SHEDULE TASK")),
      ),
    );
  }
}



