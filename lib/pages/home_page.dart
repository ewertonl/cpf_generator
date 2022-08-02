import 'package:cpf_generator/cpf/models/cpf_model.dart';
import 'package:cpf_generator/cpf/widgets/animated_cpf_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Cpf _newCPF = Cpf.random();
  bool _isMasked = true;

  void _generateNewCpf() {
    _newCPF = Cpf.random();
    setState(() {});
  }

  void _copyCPFToClipBoard() {
    String cpfValue = _newCPF.cpfValue.toString().padLeft(11, '0');
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
                label: const Text("Incluir pontuação"),
                icon: _isMasked
                    ? const Icon(Icons.check_circle_rounded)
                    : const Icon(Icons.check_circle_outline_rounded),
              ),
              AnimatedCpfText(
                cpfDigits: _newCPF.digits,
                isMasked: _isMasked,
                onEnd: _copyCPFToClipBoard,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _generateNewCpf,
                    child: const Text("Gerar CPF"),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: _copyCPFToClipBoard,
                    child: const Text("Copiar"),
                  ),
                  const SizedBox(height: 42),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
