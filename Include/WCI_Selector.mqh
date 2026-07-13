#pragma once

class CWCI_Selector
{
public:
   static int ByClickX(const int x)
   {
      int subwindow = 0;
      datetime t;
      double p;

      if(!ChartXYToTimePrice(0, x, 0, subwindow, t, p))
         return -1;

      return iBarShift(_Symbol, _Period, t, false);
   }

   static int ByCrosshair()
   {
      long x = 0;
      if(!ChartGetInteger(0, CHART_MOUSE_X, 0, x))
         return -1;
      return ByClickX((int)x);
   }
};
