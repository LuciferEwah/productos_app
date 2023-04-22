import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.indigo,
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [_Box(), const _HeaderIcon(), child]),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _boxBackground(),
      child: Stack(children: const [
        Positioned(
          top: 90,
          left: 30,
          child: _Bubble(),
        ),
        Positioned(
          top: 10,
          left: 300,
          child: _Bubble(),
        ),
        Positioned(
          top: 199,
          left: 330,
          child: _Bubble(),
        ),
        Positioned(
          top: 10,
          left: 150,
          child: _Bubble(),
        ),
        Positioned(
          top: 180,
          left: 160,
          child: _Bubble(),
        ),
        Positioned(
          top: 270,
          left: 10,
          child: _Bubble(),
        )
      ]),
    );
  }

  BoxDecoration _boxBackground() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(185, 90, 0, 1),
        Color.fromRGBO(222, 108, 0, 1)
      ]));
}

class _Bubble extends StatelessWidget {
  const _Bubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
