import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutterpracticaldemo/infrastructure/constants/api_constant.dart';
import 'package:flutterpracticaldemo/infrastructure/models/product_list_response_model.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  List<Products> get productListData => _productListData;
  List<Products> _productListData = [];

  List<CommonSelectionModel> get brandList => _brandList;
  List<CommonSelectionModel> _brandList = [];

  List<CommonSelectionModel> get categoriesList => _categoriesList;
  List<CommonSelectionModel> _categoriesList = [];

  bool? get isLoading => _isLoading;
  bool? _isLoading = false;

  bool? get isListLoading => _isListLoading;
  bool? _isListLoading = false;

  List<String> get selectedBrands => _selectedBrands;
  List<String> _selectedBrands = [];

  List<String> get selectedCategories => _selectedCategories;
  List<String> _selectedCategories = [];

  List<Products> tempProductList = [];

  void changeLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void changeListLoading(bool value) {
    _isListLoading = value;
    notifyListeners();
  }

  void filterProductsByMultipleBrands() {
    if (_selectedBrands.isNotEmpty) {
      _productListData = tempProductList
          .where((product) => _selectedBrands.contains(product.brand))
          .toList();
    } else {
      _productListData = tempProductList;
    }
    notifyListeners();
  }

  void filterProductsByMultipleCategory(int index) {
    changeListLoading(true);
    if (_selectedCategories.contains(_categoriesList[index].name)) {
      _selectedCategories.remove(_categoriesList[index].name);
    } else {
      _selectedCategories.add(_categoriesList[index].name ?? '');
    }

    Future.delayed(const Duration(seconds: 1)).then((value) {
      changeListLoading(false);
    });
    if (_selectedCategories.isNotEmpty) {
      _productListData = tempProductList
          .where((product) => _selectedCategories.contains(product.category))
          .toList();
    } else {
      _productListData = tempProductList;
    }

    notifyListeners();
  }

  void removeFilter() {
    _selectedBrands.clear();
  }

  Future<void> getProductDataApi() async {
    changeLoading(true);

    final response = await http.get(Uri.parse(ApiConstant.productList));

    changeLoading(false);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      ProductListResponse responseModel = ProductListResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);

      if (responseModel.products != null &&
          (responseModel.products?.isNotEmpty ?? false)) {
        _productListData.addAll(responseModel.products ?? []);
        tempProductList.addAll(responseModel.products ?? []);

        for (var element in _productListData) {
          if (!(_brandList.any((value) => value.name == element.brand))) {
            _brandList.add(
                CommonSelectionModel(name: element.brand));
          }

          if (!(_categoriesList
              .any((value) => value.name == element.category))) {
            _categoriesList
                .add(CommonSelectionModel(name: element.category ?? ''));
          }
        }
        notifyListeners();
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
