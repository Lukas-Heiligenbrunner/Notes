import 'package:flutter/material.dart';

class WIPToast extends StatelessWidget {
  const WIPToast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color(0xff252525),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.warning_amber,
            color: Color(0xffe5e5e5),
          ),
          SizedBox(
            width: 12.0,
          ),
          Text('Not Implemented!', style: TextStyle(color: Color(0xffe5e5e5))),
        ],
      ),
    );
  }
}
