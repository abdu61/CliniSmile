import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
          child: SpinKitCubeGrid(
        color: Color.fromARGB(255, 136, 164, 255),
        size: 50.0,
      )),
    );
  }
}
