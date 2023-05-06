import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_from_provider.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../interface/input_decorations.dart';
import '../providers/user_list_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context,
                  'admin'); // Replace 'login' with the name of your desired route
            },
            child: const Text(
              'Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      )),
    ));
  }
}

class _LoginFrom extends StatelessWidget {
  const _LoginFrom({super.key});

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
                keyboardType: TextInputType.emailAddress,
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
                      //TODO: VALIDAR SI EL LOGIN ES CORRECTO BACKEND
                      print(loginFrom);
                      print(loginFrom.email);
                      print(loginFrom.contrasena);

                      UserListProvider provider = UserListProvider();
                      bool userExists = await provider.checkUserExists(
                          email: loginFrom.email,
                          contrasena: loginFrom.contrasena);
                      print(userExists);

                      if (userExists) {
                        loginFrom.isLoading = false;

                        Future<int?> logedId =
                            provider.getIdByEmail(loginFrom.email);
                        provider.idUser = await logedId;
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        loginFrom.isLoading = false;
                        print('El usuario no existe');
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
