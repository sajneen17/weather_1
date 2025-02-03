import 'package:flutter/material.dart';

class SunriseSunsetWidget extends StatelessWidget {
  final String sunrise;
  final String sunset;
  final String dayLength;
  final String remainingDaylight;

  SunriseSunsetWidget({
    required this.sunrise,
    required this.sunset,
    required this.dayLength,
    required this.remainingDaylight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SUNRISE & SUNSET",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sunrise",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                "Sunset",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    sunrise,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Image.asset("assets/Line_one.png"),

                ],
              ),
              Column(
                children: [
                  Text(
                    sunset,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Image.asset("assets/Line_one.png"),
                ],
              ),
            ],
          ),
          Image.asset("assets/line_two.png"),
          SizedBox(height: 60),
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text: "Length of day: ",
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: dayLength,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text: "Remaining daylight: ",
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: remainingDaylight,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
