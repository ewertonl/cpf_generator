import '../../utils/cpf_tools/cpf_tools.dart' as cpf_tools;

class Cpf {
  Cpf({required this.digits});

  final List<int> digits;

  int get cpfValue => cpf_tools.digitsToCpfValue(digits);

  int get regionDigit => digits[8];
  String get region => cpf_tools.cpfRegion(regionDigit);

  factory Cpf.random() {
    return Cpf(digits: cpf_tools.generateRandomCPF());
  }

  factory Cpf.fromBaseValue(List<int> baseValue) {
    return Cpf(digits: cpf_tools.generateCPF(baseValue));
  }
}
