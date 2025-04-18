import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FundingRateCard extends StatelessWidget {
  const FundingRateCard({
    super.key,
    required this.rate,
  });

  final String rate;

  @override
  Widget build(BuildContext context) {
    if (rate.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 180.0,
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

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.blueAccent.withOpacity(.4),
                  ],
                ),
              ),
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white10),
          ),
          color: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Funding Rate',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Divider(
                        color: Colors.white10,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${double.tryParse(rate)?.toStringAsFixed(2) ?? '0.00'}%',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Current funding rate for the pair',
                      style: TextStyle(fontSize: 14, color: Colors.white60),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
