import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProductModel product;
  ProductFromProvider(this.product);

  bool isValidFor() {
    print(product.nombre);
    print(product.precio);
    print(product.stock);
    return formKey.currentState?.validate() ?? false;
  }
}
