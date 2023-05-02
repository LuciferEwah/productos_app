import 'package:flutter/material.dart';
import 'package:productos_app/providers/register_from_provider.dart'; //TODO can
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../interface/input_decorations.dart';
import '../models/user_model.dart';
import '../providers/user_list_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userListProvider = Provider.of<UserListProvider>(context);
    final users = userListProvider.users;
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
                'Registro',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 30,
              ),
              ChangeNotifierProvider(
                create: (_) => RegisterFromProvider(),
                child: const _RegisterFrom(),
              )
            ]),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context,
                  'login'); // Replace 'login' with the name of your desired route
            },
            child: const Text(
              'Ya tengo cuenta',
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

class _RegisterFrom extends StatelessWidget {
  const _RegisterFrom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final registrationForm = Provider.of<RegisterFromProvider>(context);
    return Form(
      key: registrationForm.fromKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecotaration(
              hintText: 'Armando@tamponi.com',
              labelText: 'Correo Electrónico',
              prefixIcon: Icons.alternate_email,
            ),
            onChanged: (value) => registrationForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'Formato inválido';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecotaration(
              hintText: '*******',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => registrationForm.contrasena = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe tener al menos 6 caracteres';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecotaration(
              hintText: '*******',
              labelText: 'Confirmar Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => registrationForm.confirmcontrasena = value,
            validator: (value) {
              return (value == registrationForm.contrasena)
                  ? null
                  : 'Las contraseñas no coinciden';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.orange[700],
            elevation: 0,
            color: Colors.orange,
            onPressed: registrationForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final userListProvider = Provider.of<UserListProvider>(context, listen: false);
                    bool userExists = await userListProvider.checkUserExists(
                        email: registrationForm.email,
                        contrasena: registrationForm.contrasena);
                    if (registrationForm.isValidFrom() && !userExists) {
                      registrationForm.isLoading = true;
                      // TODO: REGISTRAR AL USUARIO EN BACKEND
                      ///mockup
                      final user = UserModel(
                        email: registrationForm.email,
                        contrasena: registrationForm.contrasena,
                      );
                      userListProvider.newUser(user,
                          email: user.email, contrasena: user.contrasena);
                      ///
                      registrationForm.isLoading = false;
                      userListProvider.notifyListeners();
                      Navigator.pushReplacementNamed(context, 'login');
                    }
                    else {//TODO optimizar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('El usuario ya existe.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 80,
                vertical: 12,
              ),
              child: Text(
                registrationForm.isLoading ? 'Espere' : 'Registrar',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
