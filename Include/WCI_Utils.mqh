#pragma once

string WCI_CandleType(const double open_price, const double close_price)
{
   return (close_price >= open_price) ? "Haussiere" : "Baissiere";
}

double WCI_PipValue()
{
   return (_Digits == 3 || _Digits == 5) ? (_Point * 10.0) : _Point;
}

double WCI_Body(const double open_price, const double close_price)
{
   return MathAbs(close_price - open_price);
}

double WCI_UpperWick(const double open_price, const double high_price, const double close_price)
{
   return high_price - MathMax(open_price, close_price);
}

double WCI_LowerWick(const double open_price, const double low_price, const double close_price)
{
   return MathMin(open_price, close_price) - low_price;
}
