import 'dart:math' show Random;

List<int> randomNumberList() {
  List<int> numberList = [];
  for (var i = 0; i < 9; i++) {
    numberList.add(Random.secure().nextInt(9));
  }
  return numberList;
}

List<int> getCheckDigits(List<int> numberList) {
  int firstDigit = calculateCheckDigit(numberList, true);

  int secondDigit = calculateCheckDigit([...numberList, firstDigit], false);

  return [firstDigit, secondDigit];
}

int calculateCheckDigit(List<int> numberList, bool isFristDigit) {
  var result = 0;

  int multiplier = isFristDigit ? 10 : 11;

  for (final number in numberList) {
    result += number * multiplier;
    multiplier--;
  }

  result = result * 10 % 11;
  return result > 9 ? 0 : result;
}

List<int> generateCPF(List<int> numberList) {
  List<int> cpfNumbers = numberList;
  cpfNumbers = [...cpfNumbers, ...getCheckDigits(cpfNumbers)];
  return cpfNumbers;
}

int digitsToCpfValue(List<int> digits) {
  return digits.reduce((value, element) => 10 * value + element);
}

List<int> generateRandomCPF() {
  List<int> cpfNumbers = randomNumberList();
  cpfNumbers = [...cpfNumbers, ...getCheckDigits(cpfNumbers)];
  return cpfNumbers;
}

String maskCPFValue(int cpfValue) {
  String cpfString = cpfValue.toString().padLeft(11, '0');
  return "${cpfString.substring(0, 3)}.${cpfString.substring(3, 6)}.${cpfString.substring(6, 9)}-${cpfString.substring(9, 11)}";
}

String cpfRegion(int regionId) {
  Map<int, String> cpfRegions = {
    1: "Distrito Federal, Goiás, Mato Grosso do Sul e Tocantins",
    2: "Pará, Amazonas, Acre, Amapá, Rondônia e Roraima",
    3: "Ceará, Maranhão e Piauí",
    4: "Pernambuco, Rio Grande do Norte, Paraíba e Alagoas",
    5: "Bahia e Sergipe",
    6: "Minas Gerais",
    7: "Rio de Janeiro e Espírito Santo",
    8: "São Paulo",
    9: "Paraná e Santa Catarina",
    0: "Rio Grande do Sul",
  };
  return cpfRegions[regionId]!;
}
