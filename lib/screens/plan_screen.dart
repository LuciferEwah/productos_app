import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart';
import '../widgets/widgets.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final planListProvider = Provider.of<PlanListProvider>(context);
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
