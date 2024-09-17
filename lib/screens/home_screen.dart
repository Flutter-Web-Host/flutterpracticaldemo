import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicle/infrastructure/constants/app_constant.dart';
import 'package:flutter_practicle/infrastructure/extensions/string_extension.dart';
import 'package:flutter_practicle/infrastructure/providers/home_provider.dart';
import 'package:flutter_practicle/infrastructure/providers/provider_registration.dart';
import 'package:flutter_practicle/screens/product_details_screen.dart';
import 'package:flutter_practicle/screens/widgets/category_tile.dart';
import 'package:flutter_practicle/screens/widgets/product_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(homeProvider).currentBookingApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeRead = ref.read(homeProvider);
    final homeWatch = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          AppConstant.productList,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context, homeWatch, () {
                Navigator.pop(context);
                homeRead.filterProductsByMultipleBrands();
              });
            },
          ),
        ],
      ),
      body: homeWatch.isLoading ?? false
          ? const Center(
              child: CupertinoActivityIndicator(
                color: Colors.deepPurple,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Horizontal scrollable categories
                  homeWatch.categoriesList.isNotEmpty
                      ? SizedBox(
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: homeWatch.categoriesList.length,
                            itemBuilder: (context, index) {
                              return CategoryButton(
                                  label:
                                      (homeWatch.categoriesList[index].name ??
                                              '')
                                          .capitalize(),
                                  isSelected: homeWatch.selectedCategories
                                      .contains(
                                          homeWatch.categoriesList[index].name),
                                  onPressed: () => homeRead
                                      .filterProductsByMultipleCategory(index));
                            },
                          ),
                        )
                      : const SizedBox.shrink(),

                  const SizedBox(height: 10),
                  // Vertical scrollable products
                  homeWatch.isListLoading ?? false
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 1.2,
                          child: const CupertinoActivityIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                      : homeWatch.productListData.isNotEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height / 1.2,
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    final data =
                                        homeWatch.productListData[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                              productName: data.title ?? '',
                                              image: data.images?.first ?? '',
                                              description:
                                                  data.description ?? '',
                                              reviews: data.reviews ?? [],
                                            ),
                                          ),
                                        );
                                      },
                                      child: ProductCard(
                                        productName: data.title ?? '',
                                        brandName: data.brand ?? '',
                                        imageUrl: data.images?.first ?? '',
                                        discount:
                                            data.discountPercentage.toString(),
                                        price: data.price.toString(),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemCount: homeWatch.productListData.length),
                            )
                          : const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }

// Filter Dialog for selecting brands
  void _showFilterDialog(
      BuildContext context, HomeProvider homeWatch, VoidCallback onApplyTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            AppConstant.selectBrand,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    homeWatch.brandList.length,
                    (index) => CheckboxListTile(
                      title: Text(homeWatch.brandList[index].name ?? ''),
                      value: homeWatch.selectedBrands
                          .contains(homeWatch.brandList[index].name),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            homeWatch.selectedBrands
                                .add(homeWatch.brandList[index].name ?? '');
                          } else {
                            homeWatch.selectedBrands
                                .remove(homeWatch.brandList[index].name ?? '');
                          }
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppConstant.cancel),
            ),
            TextButton(
              onPressed: onApplyTap,
              child: const Text(AppConstant.apply),
            ),
          ],
        );
      },
    );
  }
}
