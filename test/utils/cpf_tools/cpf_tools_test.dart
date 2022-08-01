import 'package:cpf_generator/utils/cpf_tools/cpf_tools.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CPF Generator ...', () {
    test(
      "randomNumberList() should generate a different list everytime "
      "the function is called",
      () {
        var numberList1 = randomNumberList().join('');
        var numberList2 = randomNumberList().join('');
        var numberList3 = randomNumberList().join('');

        expect(
          numberList1,
          allOf([
            isNot(equals(numberList2)),
            isNot(equals(numberList3)),
          ]),
        );
      },
    );

    test(
      "The first check digit for the CPF number 529982247 should be 2",
      () {
        int firstCheckDigit = calculateCheckDigit(
          [5, 2, 9, 9, 8, 2, 2, 4, 7],
          true,
        );
        expect(firstCheckDigit, equals(2));
      },
    );

    test(
      "The second check digit for the CPF number 529982247 should be 5",
      () {
        int firstCheckDigit = calculateCheckDigit(
          [5, 2, 9, 9, 8, 2, 2, 4, 7, 2],
          false,
        );
        expect(firstCheckDigit, equals(5));
      },
    );

    test(
      "generateRandomCPF() should generate a String with 11 characters",
      () {
        String cpf = generateRandomCPF();
        expect(cpf.length, equals(11));
      },
    );

    test(
      "generateCPF() with the list [6, 7, 7, 5, 5, 8, 2, 3, 5] "
      "should generate the CPF 67755823580",
      () {
        String cpf = generateCPF([6, 7, 7, 5, 5, 8, 2, 3, 5]);
        expect(cpf, equals("67755823580"));
      },
    );
  });
}
