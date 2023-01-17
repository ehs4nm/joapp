import 'package:flutter/material.dart';

class PositionedCancelBtn extends StatelessWidget {
  const PositionedCancelBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Positioned(
        bottom: 5,
        right: width * 0.046,
        height: height * 0.075,
        child: Material(
            color: Colors.transparent,
            child: TextButton.icon(label: const Text(''), onPressed: () => {Navigator.of(context).pop()}, icon: Image.asset('assets/home/btn-cancel.png', width: width * 0.28))));
  }

  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Are you sure?'),
  //           content: const Text('Do you want to exit the App'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
  //               child: const Text('No'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pushReplacement(
  //                   //< this
  //                   PageRouteBuilder(
  //                     transitionDuration: const Duration(milliseconds: 1000),
  //                     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
  //                       return const NewHomePage();
  //                     },
  //                   ),
  //                 );
  //                 // SystemNavigator.pop();
  //                 // Navigator.of(context).pop(true); // <-- SEE HERE
  //               }, // <-- SEE HERE
  //               child: const Text('Yes'),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  // }
}
