import 'package:toaster_linear/toaster_linear.dart';

void main() {
  /// Initialize Matrices using List of Lists
  Matrix m1 = Matrix([
    [2.0, 4.0],
    [6.0, 8.0]
  ]);

  /// Create a 2x3 matrix with default fill value of 0.0
  /// [0.0, 0.0, 0.0],
  /// [0.0, 0.0, 0.0]
  Matrix m2 = Matrix.fill(2, 3);

  /// Create a 2x3 matrix with 4.0 as fill
  /// [4.0, 4.0, 4.0],
  /// [4.0, 4.0, 4.0]
  Matrix m3 = Matrix.fill(2, 3, 4.0);

  /// You can add matrices of the same size
  assert(m3 + m2 == m3);
  m3 += m2;

  /// You can subtract matrices of the same size
  assert(m3 - m2 == m3);
  m3 -= m2;

  /// You can multiply matrices
  m1 *= m2.transpose();

  /// You can scale matrices
  m1 *= 3;

  /// You can transpose matrices
  Matrix m4 = m1.transpose();

  print(m3);
  print(m4);
}
