import 'package:flutter/material.dart';

class SelectChildPage extends StatefulWidget {
  const SelectChildPage({super.key});

  @override
  State<SelectChildPage> createState() => _SelectChildPageState();
}

class _SelectChildPageState extends State<SelectChildPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/home/bg-home.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 280,
                  width: 200,
                ),
                Image.asset(
                  'assets/home/bg-choose-child.png',
                  width: MediaQuery.of(context).size.width * 0.7,
                  // width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
