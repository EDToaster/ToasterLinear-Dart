import 'dart:math';

class Matrix {
  static const double DEFAULT_VALUE = 0.0;

  static const String TOO_FEW_LAYERS_EXCEPTION_MESSAGE =
      "The amount of nodes in the neural network must exceed 2.";
  static const String INPUT_VECTOR_LENGTH_EXCEPTION_MESSAGE =
      "The neural network input data size is inconsistent with matrix size.";
  static const String TARGET_VECTOR_LENGTH_EXCEPTION_MESSAGE =
      "The neural network target data size is inconsistent with matrix size.";
  static const String MATRIX_MULT =
      "Matrix size is inconsistent when multiplying.";
  static const String UNSUPPORTED_OPERATION =
      "The type is not supported by this operation.";
  static const String MATRIX_ADD = "Matrix size is inconsistent when adding.";
  static const String MATRIX_COST =
      "Matrix size is inconsistent when calculating cost function.";
  static const String DOT_PRODUCT =
      "Dot products must be between two m×1 vectors.";
  static const String CONFORM_VECTOR = "Must input m×1 vectors.";

  final List<List<double>> _values;
  final int _m, _n;

  int get m => _m;
  int get n => _n;
  bool get isVector => n == 1;

  Matrix(List<List<double>> this._values)
      : _m = _values.length,
        _n = _values[0].length;

  Matrix.fill(int m, int n, [double fill = DEFAULT_VALUE])
      : _values = get2DList(m, n, fill),
        _m = m,
        _n = n {
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        this[i][j] = fill;
      }
    }
  }

  Matrix.identity(int size)
      : _values = get2DList(size, size, 0.0),
        _m = size,
        _n = size {
    for (int i = 0; i < size; i++) {
      this[i][i] = 1.0;
    }
  }

  operator [](int m) => _values[m];
  operator *(dynamic other) {
    if (other is Matrix) {
      if (other.isVector && this.isVector && this.m == other.m) {
        // vector dot products
        double sum = 0.0;
        for (int i = 0; i < this.m; i++) {
          sum += this[i][0] * other[i][0];
        }
        return sum;
      } else if (this.m == other.n) {
        // matrix mult
        Matrix toReturn = new Matrix.fill(other.m, this.n);

        for (int i = 0; i < toReturn.n; i++) {
          for (int j = 0; j < toReturn.m; j++) {
            toReturn[j][i] = dot(other, i, j);
          }
        }
        return toReturn;
      } else {
        throw new Exception(MATRIX_MULT);
      }
    } else if (other is num) {
      // scalar
      return this.map((x) => x * other);
    } else
      throw new Exception(UNSUPPORTED_OPERATION);
  }

  //HADAMARD
  operator %(Matrix other) {
    if (this.m != other.m || this.n != other.n)
      throw new Exception(MATRIX_MULT);

    Matrix toReturn = new Matrix.fill(m, n);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        toReturn[i][j] = this[i][j] * other[i][j];
      }
    }
    return toReturn;
  }

  operator +(Matrix other) {
    if (this.m != other.m || this.n != other.n) throw new Exception(MATRIX_ADD);
    Matrix toReturn = new Matrix.fill(m, n);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        toReturn[i][j] = this[i][j] + other[i][j];
      }
    }
    return toReturn;
  }

  operator -(Matrix other) {
    return this + ~other;
  }

  // NEGATIVE
  operator ~() {
    return this.map((x) => -x);
  }

  operator ==(dynamic other) {
    if (other is Matrix) {
      if (this.m == other.m && this.n == other.n) {
        for (int i = 0; i < n; i++) {
          for (int j = 0; j < m; j++) {
            if (this[j][i] != other[j][i]) {
              return false;
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _values.hashCode;

  double calculateDistanceCost(Matrix other) {
    if (this.m != other.m || this.n != other.n)
      throw new Exception(MATRIX_COST);

    double cost = 0.0;

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        cost += pow(this[i][j] - other[i][j], 2);
      }
    }
    return cost;
  }

  Matrix map(MapFunction f) {
    Matrix toReturn = new Matrix.fill(m, n);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        toReturn[i][j] = f(this[i][j]);
      }
    }
    return toReturn;
  }

  double dot(Matrix other, int thisColumn, int otherRow) {
    return this.spliceColumn(thisColumn) * (other.spliceRow(otherRow));
  }

  Matrix spliceRow(int index) {
    return this.transpose().spliceColumn(index);
  }

  Matrix spliceColumn(int index) {
    Matrix toReturn = new Matrix.fill(m, 1);
    for (int i = 0; i < m; i++) {
      toReturn[i][0] = this[i][index];
    }

    return toReturn;
  }

  Matrix transpose() {
    Matrix toReturn = new Matrix.fill(n, m);
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        toReturn[j][i] = this[i][j];
      }
    }
    return toReturn;
  }

  static List<List<double>> get2DList(int m, int n, double fill) {
    List<List<double>> toRet = [];
    for (int i = 0; i < m; i++) {
      List<double> sub = [];
      for (int j = 0; j < n; j++) {
        sub.add(fill);
      }
      toRet.add(sub);
    }
    return toRet;
  }

  @override
  String toString() => _values.toString();
}

typedef double MapFunction(double x);
