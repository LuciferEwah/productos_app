import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

import 'package:productos_app/providers/product_list_provider.dart';

class ProductFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProductModel product;
  bool isUpdating = false;
  ProductFromProvider(this.product);

  Future<void> updateProduct() async {
    if (formKey.currentState!.validate()) {
      await ProductListProvider().update(product);

      // Notificar a los listeners
    }
  }
}
