#pragma once
#include <Include/WCI_Candle.mqh>

class CWCI_Patterns
{
public:
   static string Detect(const CWCI_Candle &candle)
   {
      double body = candle.Body();
      double range = candle.Range();
      if(range <= 0.0)
         return "Aucun";

      double upper_wick = candle.UpperWick();
      double lower_wick = candle.LowerWick();

      if(body <= range * 0.10)
         return "Doji";

      if(lower_wick >= body * 2.0 && upper_wick <= body * 0.5)
         return "Marteau";

      if(upper_wick >= body * 2.0 && lower_wick <= body * 0.5)
         return "Shooting Star";

      if(candle.close > candle.open && body >= range * 0.60)
         return "Bullish Impulse";

      if(candle.close < candle.open && body >= range * 0.60)
         return "Bearish Impulse";

      return "Aucun";
   }

   static string Interpretation(const string pattern, const string candle_type)
   {
      if(pattern == "Marteau")
         return "Rejet des bas : les acheteurs ont repris la main.";
      if(pattern == "Shooting Star")
         return "Rejet des hauts : les vendeurs ont repris le contrôle.";
      if(pattern == "Doji")
         return "Indecision : acheteurs et vendeurs sont équilibrés.";
      if(pattern == "Bullish Impulse")
         return "Pression acheteuse forte.";
      if(pattern == "Bearish Impulse")
         return "Pression vendeuse forte.";
      if(candle_type == "Haussiere")
         return "Bougie haussiere : les acheteurs dominent.";
      return "Bougie baissiere : les vendeurs dominent.";
   }
};
