#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <rational/rational.h>

#include <sstream>

#include "doctest.h"

TEST_CASE("testing input / output") {
  std::stringstream ss;
  ss << "-3/7";

  CHECK(ss.good());

  Rational R;
  ss >> R;
  CHECK(R == Rational(-3, 7));
  ss.clear();

  ss << R;
  std::string output;
  std::getline(ss, output);
  CHECK(output == "-3/7");
}

TEST_CASE("testing reduce method") {
  Rational R(210, -231);

  CHECK(R.num() == -10);
  CHECK(R.denum() == 11);
}

TEST_CASE("testing comparations") {
  CHECK(Rational(-1, 2) < Rational(1, 2));
  CHECK(Rational(-1, 4) == Rational(16, -64));
}

TEST_CASE("summ and substraction test") {
  Rational R(-11, 23);
  Rational L(-8, -15);

  CHECK(R - L == Rational(-349, 345));
}

TEST_CASE("multiplication test") {
  CHECK(Rational(11, 12) * Rational(3, -11) == Rational(-1, 4));
}

TEST_CASE("division test") {
  CHECK(Rational(-15, 16) / Rational(5, -4) == Rational(3, 4));
}

TEST_CASE("other") {
  Rational r(123);

  CHECK(r == Rational(123, 1));
}

void CreateWithZeroNumerator() { Rational badNumber(1, 0); }
TEST_CASE("create with zero numerator") {
  CHECK_THROWS(CreateWithZeroNumerator());
}

TEST_CASE("comparison operations") {
  Rational small_number(2, 3);
  Rational second_small_number(2, 3);
  Rational big_number(5, 6);
  CHECK(small_number == second_small_number);
  CHECK(small_number <= second_small_number);
  CHECK(small_number <= big_number);
  CHECK(small_number < big_number);
  CHECK(small_number != big_number);
  CHECK_FALSE(small_number > big_number);
  CHECK_FALSE(small_number >= big_number);
}

TEST_CASE("zero case") {
  Rational default_number;
  CHECK(default_number.num() == 0);
  CHECK(default_number.denum() == 1);
  Rational zero_number(0, 3);
  CHECK(zero_number == default_number);
}

TEST_CASE("same irreducible appearance case") {
  int a = rand() % 10000;
  int b = rand() % 10000 + 1;
  Rational number_1(a, b);
  Rational number_2(-a, -b);
  int c = rand() % 1000 + 2;
  Rational number_3(a * c, b * c);
  Rational number_4(-a * c, -b * c);
  CHECK(number_1 == number_2);
  CHECK(number_1 == number_3);
  CHECK(number_1 == number_4);
}

TEST_CASE("create") {
  int a = rand() % 10000;
  int b = rand() % 10000 + 1;
  Rational number_1(a, b);
  Rational number_2 = number_1;
  Rational number_3;
  int c = rand() % 10000 + 1;
  CHECK(number_1 == number_2);
  CHECK(number_1 != number_3);
  bool is_null_exception = false;
}

TEST_CASE("arithmetic operations") {
  int iterCount = 5;
  for (int i = 0; i < iterCount; ++i) {
    int a = rand() % 10000;
    int b = rand() % 10000 + 1;
    int c = rand() % 10000 + 1;
    int d = rand() % 10000 + 1;
    Rational number_1(a, b);
    Rational number_2(c, d);
    Rational sum(a * d + b * c, b * d);
    Rational mult(a * c, b * d);
    Rational diff(a * d - b * c, b * d);
    Rational div(a * d, b * c);
    CHECK(number_1 + number_2 == sum);
    CHECK(number_1 * number_2 == mult);
    CHECK(number_1 - number_2 == diff);
    CHECK(number_1 / number_2 == div);
  }
}

TEST_CASE("zero division case") {
  Rational dividend(1, 1);
  Rational zero_divisor;
  CHECK_THROWS(dividend / zero_divisor);
}

TEST_CASE("input/output") {
  Rational number;
  std::stringstream input_stream;
  input_stream << "15/9";
  input_stream >> number;
  CHECK(number == Rational(5, 3));
  std::stringstream output_stream;
  output_stream << number;
  std::string str_number;
  output_stream >> str_number;
  CHECK(str_number == "5/3");
}

TEST_CASE("invalid input") {
  SUBCASE("zero denominator") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "15/0";
    input_stream >> number;
    CHECK(input_stream.fail());
  }
  SUBCASE("fail_1") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "15d2";
    input_stream >> number;
    CHECK(input_stream.fail());
  }
  SUBCASE("fail_2") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "15 2";
    input_stream >> number;
    CHECK(input_stream.fail());
  }
  SUBCASE("fail_3") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "12/-12";
    input_stream >> number;
    CHECK(input_stream.fail());
  }
  SUBCASE("fail_4") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "15/ 2";
    input_stream >> number;
    CHECK(input_stream.fail());
  }
  SUBCASE("fail_5") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "15 /2";
    input_stream >> number;
    CHECK(input_stream.fail());
  }
  SUBCASE("eof") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "12/5";
    input_stream >> number;
    CHECK(input_stream.eof());
  }
  SUBCASE("good") {
    Rational number;
    std::stringstream input_stream;
    input_stream << "12/5 ";
    input_stream >> number;
    CHECK(input_stream.good());
  }
}