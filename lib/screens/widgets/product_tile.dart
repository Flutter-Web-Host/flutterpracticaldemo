// Product Card Widget
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String discount;
  final String productName;
  final String brandName;
  final String price;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.discount,
    required this.productName,
    required this.brandName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Card(
        child: Row(
          children: [
            // Image with discount overlay
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 100,
                  height: 100,
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(
                          color: Colors.deepPurple),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  child: Transform.rotate(
                    angle: -0.785,
                    // 45 degrees in radians (pi/4)
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.deepPurple.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          discount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      brandName,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
