import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({
    Key key,
    @required this.distance,
  }) : super(key: key);

  final double distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black, blurRadius: 5, offset: Offset(0.7, 0.7))
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                distance.toStringAsFixed(2) + " KM ",
                style: TextStyle(color: Colors.grey),
              ),
              Text(" : المسافة"),
              Icon(Icons.arrow_left),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: Colors.black)),
            child: Text("تم التحديد" , style: TextStyle(color: Colors.blue,fontSize: 20),),
            ),
          )
        ],
      ),
    );
  }
}
