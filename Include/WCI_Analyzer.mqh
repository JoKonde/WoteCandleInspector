#ifndef WCI_ANALYZER_MQH
#define WCI_ANALYZER_MQH

#include "WCI_Candle.mqh"
#include "WCI_Patterns.mqh"

class CWCI_Analyzer
{
public:
   static string BuildReport(const CWCI_Candle &candle)
   {
      string type = candle.Type();
      string pattern = CWCI_Patterns::Detect(candle);
      string interpretation = CWCI_Patterns::Interpretation(pattern, type);

      string report = "WoteCandleInspector v4.0 Pro\n";
      report += "--------------------------------\n";
      report += "Date : " + candle.DateTimeText() + "\n";
      report += "Type : " + type + "\n";
      report += "Pattern : " + pattern + "\n\n";
      report += "Open  : " + DoubleToString(candle.open, _Digits) + "\n";
      report += "High  : " + DoubleToString(candle.high, _Digits) + "\n";
      report += "Low   : " + DoubleToString(candle.low, _Digits) + "\n";
      report += "Close : " + DoubleToString(candle.close, _Digits) + "\n\n";
      report += "Corps       : " + DoubleToString(candle.BodyPips(), 1) + " pips\n";
      report += "Mèche haute : " + DoubleToString(candle.UpperWickPips(), 1) + " pips\n";
      report += "Mèche basse : " + DoubleToString(candle.LowerWickPips(), 1) + " pips\n";
      report += "Amplitude   : " + DoubleToString(candle.RangePips(), 1) + " pips\n\n";
      report += "Interprétation : " + interpretation;

      return report;
   }
};

#endif
