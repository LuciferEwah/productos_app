import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_from_provider.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../interface/input_decorations.dart';
import '../providers/subscription_list_provider.dart';
import '../providers/user_list_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SuscriptionListProvider>(context, listen: false)
          .startUpdatingSubscriptionStatus();
    });
  }

  // The closing bracket for initState() was removed here, as it was extra.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          CardContainer(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 30,
              ),
              ChangeNotifierProvider(
                create: (_) => LoginFromProvider(),
                child: const _LoginFrom(),
              )
            ]),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context,
                  'register'); // Replace 'login' with the name of your desired route
            },
            child: const Text(
              'Registrarme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      )),
    ));
  }
}

class _LoginFrom extends StatelessWidget {
  const _LoginFrom();

  @override
  Widget build(BuildContext context) {
    final loginFrom = Provider.of<LoginFromProvider>(context);
    return Form(
        key: loginFrom.fromKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecotaration(
                  hintText: 'Armando@tamponi.com',
                  labelText: 'Correo Electronico',
                  prefixIcon: Icons.alternate_email),
              onChanged: (value) => loginFrom.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : 'Formato invalido';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                autofillHints:
                    null, // Agrega esta línea para desactivar las sugerencias de autocompletado
                decoration: InputDecorations.authInputDecotaration(
                    hintText: '*******',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline),
                onChanged: (value) => loginFrom.contrasena = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe ser minimo de 6 caracteres';
                }),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.orange[700],
              elevation: 0,
              color: Colors.orange,
              onPressed: loginFrom.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!loginFrom.isValidFrom()) return;

                      loginFrom.isLoading = true;
                      Future.delayed(const Duration(seconds: 2));

                      // Accede al UserListProvider
                      final userListProvider =
                          Provider.of<UserListProvider>(context, listen: false);

                      bool userExists = await userListProvider.checkUserExists(
                          email: loginFrom.email,
                          contrasena: loginFrom.contrasena);

                      if (userExists) {
                        loginFrom.isLoading = false;

                        Future<int?> logedId =
                            userListProvider.getIdByEmail(loginFrom.email);
                        userListProvider.idUser = await logedId;

                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        loginFrom.isLoading = false;

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario o contraseña incorrectos'),
                          ),
                        );
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                child: Text(
                  loginFrom.isLoading ? 'Espere' : 'Ingresar',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}
