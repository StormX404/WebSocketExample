import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TimeCard extends StatelessWidget {
  const TimeCard({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    if (time.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 80.0,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(.3),
            highlightColor: Colors.grey[50]!.withOpacity(.7),
            child: Container(
              color: Colors.black.withOpacity(.2),
            ),
          ),
        ),
      );
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: const BorderSide(color: Colors.white10),
      ),
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric( vertical: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                SizedBox(width: 4),
                Text(
                  time.isEmpty ? 'Loading...' : time,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              'Execution time',
              style: TextStyle(fontSize: 14, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
