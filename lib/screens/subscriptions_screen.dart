import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/providers/provider.dart';
import 'package:productos_app/services/services.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final planListProvider = Provider.of<PlanListProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => PlanFromProvider(planListProvider.selectedPlan),
      child: _PlanScreenBody(planListProvider: planListProvider),
    );
  }
}

class _PlanScreenBody extends StatelessWidget {
  _PlanScreenBody({
    required this.planListProvider,
  });

  final PlanListProvider planListProvider;
  final syncPlanToFirebase = PlanService();
  @override
  Widget build(BuildContext context) {
    final planFrom = Provider.of<PlanFromProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Details'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const SingleChildScrollView(
        child: _PlanForm(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () async {
                if (planListProvider.selectedPlan.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Por el momento no se puede eliminar el plano, intente en otro momento'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                } else {
                  planListProvider
                      .deleteById(planListProvider.selectedPlan.id!);
                  await syncPlanToFirebase.syncPlansToFirebase();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              heroTag: null,
              child: const Icon(
                Icons.delete_outline,
              ),
            ),
            FloatingActionButton(
              onPressed: () async {
                planListProvider.update(planFrom.plan);
                await syncPlanToFirebase.syncPlansToFirebase();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              heroTag: null,
              child: const Icon(Icons.save_outlined),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class _PlanForm extends StatelessWidget {
  const _PlanForm();

  @override
  Widget build(BuildContext context) {
    final planFrom = Provider.of<PlanFromProvider>(context);
    final plan = planFrom.plan;
    final screenHeight =
        MediaQuery.of(context).size.height; // Obtén la altura de la pantalla
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: screenHeight *
            0.15, // 10% de padding desde la parte superior e inferior
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: planFrom.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            const SizedBox(height: 10),
            TextFormField(
              initialValue: plan.nombre,
              onChanged: (value) => plan.nombre = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: 'nombre del plan', labelText: 'nombre'),
            ),
            const SizedBox(height: 30),
            TextFormField(
                initialValue: '${plan.precioMensual}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    plan.precioMensual = 0;
                  } else {
                    plan.precioMensual = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Precio Mensual del plan', labelText: 'precio')),
            const SizedBox(height: 30),
            TextFormField(
                initialValue: '${plan.duracionMeses}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+$'))
                ],
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    plan.duracionMeses = 0;
                  } else {
                    plan.duracionMeses = int.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'duracion en meses del plan',
                    labelText: 'duracion')),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5),
        ],
      );
}
