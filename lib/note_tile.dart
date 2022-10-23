import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: 100,
            child: Container(
              color: Colors.white,
            ),
          ),
          const Text(
            'This is a very long text mimimim lolo',
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          const Text('11:40')
        ],
      ),
    );
  }
}
