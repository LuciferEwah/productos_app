import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/plan_list_provider.dart';



class PlanFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PlanModel plan;
  bool isUpdating = false;
  PlanFromProvider(this.plan);

  Future<void> updatePlan() async {
    if (formKey.currentState!.validate()) {
      await PlanListProvider().update(plan);
    }
  }
}
