import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PriceData extends StatelessWidget {
  const PriceData({
    super.key,
    required this.price,
  });

  final String price;

  @override
  Widget build(BuildContext context) {
    if (price.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 100.0,
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
    return Column(
      children: [
        price.isEmpty
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${double.tryParse(price)?.toStringAsFixed(2) ?? '0.00'} ',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'USDT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFafc170),
                ),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 15),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: Color(0xFFafc170).withOpacity(.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0xFFafc170).withOpacity(.1)),
          ),
          child: Center(
            child: Text(
              'Price per 1 BTC',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFafc170)),
            ),
          ),
        ),
      ],
    );
  }
}
