import 'package:custome_camera/camera_screen.dart';
import 'package:flutter/material.dart';

class homescreen extends StatelessWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CameraScreen()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
