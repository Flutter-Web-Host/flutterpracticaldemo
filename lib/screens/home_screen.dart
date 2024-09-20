import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicle/infrastructure/constants/app_constant.dart';
import 'package:flutter_practicle/infrastructure/extensions/string_extension.dart';
import 'package:flutter_practicle/infrastructure/providers/home_provider.dart';
import 'package:flutter_practicle/screens/product_details_screen.dart';
import 'package:flutter_practicle/screens/widgets/category_tile.dart';
import 'package:flutter_practicle/screens/widgets/product_tile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeProvider>().getProductDataApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeRead = context.read<HomeProvider>();

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
              _showFilterDialog(context, () {
                Navigator.pop(context);
                homeRead.filterProductsByMultipleBrands();
              });
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          if (value.isLoading ?? false) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: Colors.deepPurple,
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                // Horizontal scrollable categories
                value.categoriesList.isNotEmpty
                    ? SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.categoriesList.length,
                          itemBuilder: (context, index) {
                            return CategoryButton(
                                label: (value.categoriesList[index].name ?? '')
                                    .capitalize(),
                                isSelected: value.selectedCategories
                                    .contains(value.categoriesList[index].name),
                                onPressed: () => homeRead
                                    .filterProductsByMultipleCategory(index));
                          },
                        ),
                      )
                    : const SizedBox.shrink(),

                const SizedBox(height: 10),
                // Vertical scrollable products
                Consumer<HomeProvider>(
                  builder: (BuildContext context, HomeProvider value,
                      Widget? child) {
                    if (value.isListLoading ?? false) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: const CupertinoActivityIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    }
                    if (value.productListData.isNotEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              final data = value.productListData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        productName: data.title ?? '',
                                        image: data.images?.first ?? '',
                                        description: data.description ?? '',
                                        reviews: data.reviews ?? [],
                                      ),
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  productName: data.title ?? '',
                                  brandName: data.brand ?? '',
                                  imageUrl: data.images?.first ?? '',
                                  discount: data.discountPercentage.toString(),
                                  price: data.price.toString(),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: value.productListData.length),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

// Filter Dialog for selecting brands
  void _showFilterDialog(BuildContext context, VoidCallback onApplyTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<HomeProvider>(
          builder: (BuildContext context, value, Widget? child) {
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
                        value.brandList.length,
                        (index) => CheckboxListTile(
                          title: Text(value.brandList[index].name ?? ''),
                          value: value.selectedBrands
                              .contains(value.brandList[index].name),
                          onChanged: (bool? data) {
                            setState(() {
                              if (data == true) {
                                value.selectedBrands
                                    .add(value.brandList[index].name ?? '');
                              } else {
                                value.selectedBrands
                                    .remove(value.brandList[index].name ?? '');
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
      },
    );
  }
}
