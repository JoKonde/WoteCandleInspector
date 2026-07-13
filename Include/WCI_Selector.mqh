#ifndef WCI_SELECTOR_MQH
#define WCI_SELECTOR_MQH

#include "WCI_Candle.mqh"

class CWCI_Selector
{
public:
   static int ByClickX(const int x)
   {
      int subwindow = 0;
      datetime t = 0;
      double p = 0.0;

      // Essaie d'abord avec le point exact du clic
      if(ChartXYToTimePrice(0, x, 0, subwindow, t, p))
      {
         int shift = iBarShift(_Symbol, _Period, t, false);
         if(shift >= 0)
            return shift;
      }

      // Fallback: récupérer la bougie la plus proche selon la position X visible
      long first_visible = ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR);
      long visible_bars  = ChartGetInteger(0, CHART_VISIBLE_BARS);
      if(first_visible < 0 || visible_bars <= 0)
         return -1;

      int chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
      if(chart_width <= 0)
         return -1;

      int x_clamped = x;
      if(x_clamped < 0)
         x_clamped = 0;
      if(x_clamped > chart_width - 1)
         x_clamped = chart_width - 1;

      double bars_from_left = ((double)x_clamped / (double)chart_width) * (double)visible_bars;
      int shift = (int)MathRound((double)first_visible - bars_from_left);

      if(shift < 0)
         shift = 0;
      if(shift >= Bars(_Symbol, _Period))
         shift = Bars(_Symbol, _Period) - 1;

      return shift;
   }

   static bool LoadSelectedCandle(const int shift, CWCI_Candle &candle)
   {
      if(shift < 0)
         return false;
      return candle.LoadByShift(shift);
   }
};

#endif
