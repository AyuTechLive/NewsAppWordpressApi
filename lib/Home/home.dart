import 'package:flutter/material.dart';

class Newscardview extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imglink;
  final String author;
  final String date;
  final VoidCallback ontap;
  const Newscardview(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imglink,
      required this.ontap,
      required this.author,
      required this.date});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Padding(
      padding:
          EdgeInsets.fromLTRB(width * 0.055, height * 0.0125, width * 0.060, 0),
      child: InkWell(
        onTap: ontap,
        child: Container(
          width: width * 0.95,
          //height: height * 0.6,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                  height: height * 0.25,
                  width: width * 0.91,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imglink,
                      scale: 1.0,
                      fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.02, height * 0.01, width * 0.01, 0),
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  softWrap: true,
                  maxLines: 4,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.06, height * 0.01, width * 0.05, 0),
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 14),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  Text(
                    author,
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    date,
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
