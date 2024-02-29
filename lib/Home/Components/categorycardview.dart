import 'package:dainik_media_newsapp/Colors.dart';
import 'package:flutter/material.dart';

class Categorycardview extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imglink;
  final String author;
  final String date;
  final VoidCallback ontap;

  const Categorycardview({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imglink,
    required this.ontap,
    required this.author,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return InkWell(
      onTap: ontap,
      child: IconButton(
        onPressed: ontap,
        icon: Text(
          title,
          style: TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),

      // child: Container(
      //   height: 20,
      //   decoration: BoxDecoration(
      //       color: AppColors.backgroundColor,
      //       borderRadius: BorderRadius.circular(10)),
      //   child: Center(
      //     child: Padding(
      //       padding: EdgeInsets.only(left: 10, right: 10),
      //       child: Text(
      //         title,
      //         style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 10,
      //             fontWeight: FontWeight.w700),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
