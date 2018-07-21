import 'package:toaster_linear/toaster_linear.dart';
import 'package:test/test.dart';

void main() {
  group('Matrix Tests', () {
    Matrix testMatrix0;
    Matrix testMatrix1;
    Matrix testMatrixFill0;
    Matrix testMatrixFill1;
    Matrix testTransposed0;
    Matrix testTransposed1;
    Matrix testVector0;
    Matrix testVector1;

    setUp(() {
      testMatrix0 = Matrix([
        [1.0, 2.0],
        [3.0, 4.0],
        [5.0, 6.0],
      ]);
      testMatrix1 = Matrix([
        [1.0, 2.0],
        [3.0, 4.0],
      ]);

      testTransposed0 = new Matrix([
        [1.0, 2.0, 3.0],
      ]);
      testTransposed1 = new Matrix([
        [4.0, 5.0, 6.0],
      ]);

      testVector0 = testTransposed0.transpose();
      testVector1 = testTransposed1.transpose();

      testMatrixFill0 = Matrix.fill(4, 4, 1.0);
      testMatrixFill1 = Matrix([
        [1.0, 1.0, 1.0, 1.0],
        [1.0, 1.0, 1.0, 1.0],
        [1.0, 1.0, 1.0, 1.0],
        [1.0, 1.0, 1.0, 1.0],
      ]);
    });

    test('Fill vs Manual equality', () {
      expect(testMatrixFill0 == testMatrixFill1, isTrue);
    });

    test('Transposition', () {
      Matrix transposed0 = Matrix([
        [1.0, 3.0, 5.0],
        [2.0, 4.0, 6.0]
      ]);

      expect(testMatrix0.transpose() == transposed0, isTrue);
    });

    test('Splicing', () {
      Matrix col_0 = Matrix([
        [1.0],
        [3.0],
        [5.0]
      ]);
      Matrix col_t0 = Matrix([
        [1.0],
        [2.0],
      ]);

      expect(testMatrix0.spliceColumn(0) == col_0, isTrue);
      expect(testMatrix0.transpose().spliceColumn(0) == col_t0, isTrue);
      expect(testMatrix0.spliceRow(0) == col_t0, isTrue);
      expect(testMatrix0.transpose().spliceRow(0) == col_0, isTrue);
    });

    test('Vectors', () {
      expect(testVector0.isVector, isTrue);
      expect(testVector0.transpose().isVector, isFalse);
      expect(testMatrix0.isVector, isFalse);
      expect(testMatrix0.transpose().isVector, isFalse);
      expect(testTransposed0.isVector, isFalse);
      expect(testTransposed0.transpose().isVector, isTrue);
    });

    test('Double Dot Product', () {
      expect(testVector0 * testVector1 == 32, isTrue);
    });

    test('Double Dot Product Error', () {
      expect(() => testVector0 * testMatrix0, throwsException);
    });

    test('Setting', () {
      Matrix result = Matrix([
        [1.0, 2.0, 3.0],
      ]).transpose();
      result[2][0] = 3.0;
      expect(result == testVector0, isTrue);
    });

    test('MM Mult', () {
      Matrix resultMatrix = Matrix([
        [7.0, 10.0],
        [15.0, 22.0],
        [23.0, 34.0],
      ]);

      expect(testMatrix1 * testMatrix0 == resultMatrix, isTrue);
    });

    test('Matrix Scaling', () {
      Matrix resultMatrix = Matrix([
        [2.0, 4.0],
        [6.0, 8.0],
      ]);

      expect(testMatrix1 * 2 == resultMatrix, isTrue);
    });

    test('Identity', () {
      Matrix id = Matrix.identity(3);
      expect(testMatrix0 * id == testMatrix0, isTrue);
    });

    test('Adding', () {
      Matrix result = Matrix([
        [2.0, 4.0],
        [6.0, 8.0]
      ]);
      expect(testMatrix1 + testMatrix1 == result, isTrue);
    });

    test('Subbing', () {
      Matrix result = Matrix([
        [0.0, 0.0],
        [0.0, 0.0]
      ]);
      expect(testMatrix1 - testMatrix1 == result, isTrue);
    });

    test('Cost', () {
      expect(testMatrix0.calculateDistanceCost(testMatrix0) == 0, isTrue);

      Matrix broken = Matrix([
        [0.0, 0.0],
        [3.0, 4.0],
        [5.0, 6.0]
      ]);

      expect(testMatrix0.calculateDistanceCost(broken) == 5, isTrue);
      expect(broken.calculateDistanceCost(testMatrix0) == 5, isTrue);
    });
  });
}
