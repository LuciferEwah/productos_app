import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/planes_model.dart';
import '../providers/provider.dart';
import '../widgets/widgets.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final planListProvider = Provider.of<PlanListProvider>(context);
    final plans = planListProvider.plans;
    final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, _) {
          return IndexedStack(
            index: index,
            children: [
              ListView.builder(
                itemCount: planListProvider.plans.length,
                itemBuilder: (context, i) => GestureDetector(
                  child: PlanCard(
                      plan: planListProvider.plans[i],
                      planListProvider: planListProvider),
                  onTap: () {
                    planListProvider.selectedPlan =
                        planListProvider.plans[i].copy();
                    Navigator.pushNamed(context, 'suscripciones');
                    print('ES ESTE');
                  },
                ),
              ),

            ],
          );
        },
      ),
    ); // se agrega la coma faltante
  }
}