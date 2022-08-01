import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils/cpf_tools/cpf_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CPF Generator',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 6, 64, 255),
      ),
      home: const HomePage(title: 'Gerador de CPF'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  int _newCPF = 0;
  int _oldCPF = int.parse(generateRandomCPF());
  bool _isMasked = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: _oldCPF.toDouble(),
      duration: const Duration(seconds: 1),
    );
    _animation = Tween(begin: _oldCPF, end: _oldCPF).animate(_controller);
  }

  void _animateCPF() {
    setState(() {
      _newCPF = int.parse(generateRandomCPF());
      _animation = IntTween(
        begin: _oldCPF,
        end: _newCPF,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    });
    _oldCPF = _newCPF;
    _controller.forward(from: 0.0);
  }

  void _copyCPFToClipBoard() {
    String cpfValue = _animation.value.toString().padLeft(11, '0');
    Clipboard.setData(
      ClipboardData(
        text: _isMasked ? _maskCPF(cpfValue) : cpfValue,
      ),
    );
  }

  String _maskCPF(String cpfString) {
    String value = cpfString.padLeft(11, '0');
    return "${value.substring(0, 3)}.${value.substring(3, 6)}.${value.substring(6, 9)}-${value.substring(9, 11)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                  onPressed: () {
                    _isMasked = !_isMasked;
                    setState(() {});
                  },
                  icon: _isMasked
                      ? const Icon(Icons.check_circle_rounded)
                      : const Icon(Icons.check_circle_outline_rounded),
                  label: const Text("Incluir pontuação")),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  String cpfValue =
                      _animation.value.toString().padLeft(11, '0');
                  String cpfString = _isMasked ? _maskCPF(cpfValue) : cpfValue;
                  return SelectableText(
                    cpfString,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 27,
                    ),
                  );
                },
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _animateCPF,
                    child: const Text("Gerar CPF"),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: _copyCPFToClipBoard,
                    child: const Text("Copiar"),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
