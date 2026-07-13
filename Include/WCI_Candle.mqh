#ifndef WCI_CANDLE_MQH
#define WCI_CANDLE_MQH

#include "WCI_Utils.mqh"

class CWCI_Candle
{
public:
   datetime time;
   double   open;
   double   high;
   double   low;
   double   close;
   int      shift;

   CWCI_Candle()
   {
      time  = 0;
      open  = 0.0;
      high  = 0.0;
      low   = 0.0;
      close = 0.0;
      shift = -1;
   }

   bool LoadByShift(const int candle_shift)
   {
      shift = candle_shift;
      if(shift < 0)
         return false;

      time  = iTime(_Symbol, _Period, shift);
      open  = iOpen(_Symbol, _Period, shift);
      high  = iHigh(_Symbol, _Period, shift);
      low   = iLow(_Symbol, _Period, shift);
      close = iClose(_Symbol, _Period, shift);

      return (time > 0.0);
   }

   string Type() const
   {
      return WCI_CandleType(open, close);
   }

   double Body() const
   {
      return WCI_Body(open, close);
   }

   double UpperWick() const
   {
      return WCI_UpperWick(open, high, close);
   }

   double LowerWick() const
   {
      return WCI_LowerWick(open, low, close);
   }

   double Range() const
   {
      return (high - low);
   }

   double BodyPips() const
   {
      return Body() / WCI_PipValue();
   }

   double UpperWickPips() const
   {
      return UpperWick() / WCI_PipValue();
   }

   double LowerWickPips() const
   {
      return LowerWick() / WCI_PipValue();
   }

   double RangePips() const
   {
      return Range() / WCI_PipValue();
   }

   string DateTimeText() const
   {
      return TimeToString(time, TIME_DATE | TIME_MINUTES);
   }
};

#endif
