import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpracticaldemo/infrastructure/constants/app_constant.dart';
import 'package:flutterpracticaldemo/infrastructure/models/product_list_response_model.dart';
import 'package:flutterpracticaldemo/infrastructure/extensions/string_extension.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productName;
  final String image;
  final String description;
  final List<Reviews> reviews;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.image,
    required this.description,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(productName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: image,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const CupertinoActivityIndicator(color: Colors.deepPurple),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    AppConstant.reviews,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            '${review.reviewerName.toString()} on ${(review.date?.convertDate())}',
                            maxLines: 3,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${review.rating} ${AppConstant.stars}',
                              ),
                              Text(
                                review.comment ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
