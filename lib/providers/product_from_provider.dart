import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFromProvider extends ChangeNotifier {
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  ProductFromProvider(this.product);
  ProductModel product;

  bool isValidFor() {
    return fromKey.currentState?.validate() ?? false;
  }
}
