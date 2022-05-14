import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  EventCard({this.imgURL, this.title, this.date, this.press});
  final String? imgURL, title, date;
  final void Function()? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.only(top: 30),
        decoration: BoxDecoration(),
        width: 350,
        child: Column(
          children: [
            Container(
              height: 250,
              width: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                child: imgURL != null || imgURL == ""
                    ? Image.network(
                        imgURL!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/noimage.png'),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "$title",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$date",
                    style: TextStyle(
                        color: Colors.white60, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
