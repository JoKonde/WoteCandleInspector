//+------------------------------------------------------------------+
//|                                          WoteCandleInspector.mq5 |
//|                                                        Wote 2026 |
//|                                                https://wotes.org |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

input color  PanelBgColor      = clrBlack;
input color  PanelTextColor    = clrWhite;
input color  PanelBorderColor  = clrDodgerBlue;
input color  CandleMarkColor   = clrGold;
input int    PanelX            = 20;
input int    PanelY            = 20;
input int    PanelWidth        = 260;
input int    PanelHeight       = 140;

string PANEL_BG   = "WCI_PanelBG";
string PANEL_TXT  = "WCI_PanelText";
string PANEL_BOX  = "WCI_SelectedCandleBox";

bool g_panel_visible = false;

int OnInit()
{
   EventSetMillisecondTimer(250);
   CreatePanel();
   HidePanel();
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   ObjectDelete(0, PANEL_BG);
   ObjectDelete(0, PANEL_TXT);
   ObjectDelete(0, PANEL_BOX);
   ChartRedraw(0);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   return(rates_total);
}

void OnTimer()
{
   if(g_panel_visible)
      ChartRedraw(0);
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id == CHARTEVENT_CLICK)
   {
      int x = (int)lparam;
      int y = (int)dparam;
      ShowCandleInfoByClick(x, y);
   }
}

void CreatePanel()
{
   if(ObjectFind(0, PANEL_BG) < 0)
   {
      ObjectCreate(0, PANEL_BG, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_XDISTANCE, PanelX);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_YDISTANCE, PanelY);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_XSIZE, PanelWidth);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_YSIZE, PanelHeight);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_BGCOLOR, PanelBgColor);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_COLOR, PanelBorderColor);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_BACK, false);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_SELECTABLE, false);
   }

   if(ObjectFind(0, PANEL_TXT) < 0)
   {
      ObjectCreate(0, PANEL_TXT, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_XDISTANCE, PanelX + 10);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_YDISTANCE, PanelY + 10);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_COLOR, PanelTextColor);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_FONTSIZE, 10);
      ObjectSetString(0, PANEL_TXT, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_SELECTABLE, false);
   }
}

void ShowPanel(const string text)
{
   ObjectSetString(0, PANEL_TXT, OBJPROP_TEXT, text);
   ObjectSetInteger(0, PANEL_BG, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, PANEL_TXT, OBJPROP_HIDDEN, false);
   g_panel_visible = true;
}

void HidePanel()
{
   ObjectSetInteger(0, PANEL_BG, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, PANEL_TXT, OBJPROP_HIDDEN, true);
   g_panel_visible = false;
}

void ClearSelectedBox()
{
   ObjectDelete(0, PANEL_BOX);
}

void ShowCandleInfoByClick(const int x, const int y)
{
   int subwindow = 0;
   datetime candle_time;
   double candle_price;

   if(!ChartXYToTimePrice(0, x, y, subwindow, candle_time, candle_price))
      return;

   int shift = iBarShift(_Symbol, _Period, candle_time, false);
   if(shift < 0)
      return;

   datetime t = iTime(_Symbol, _Period, shift);
   double o = iOpen(_Symbol, _Period, shift);
   double h = iHigh(_Symbol, _Period, shift);
   double l = iLow(_Symbol, _Period, shift);
   double c = iClose(_Symbol, _Period, shift);

   string type = (c >= o) ? "Haussiere" : "Baissiere";
   string dt   = TimeToString(t, TIME_DATE | TIME_MINUTES);

   string txt = "WoteCandleInspector v1.0\n";
   txt += "-------------------------\n";
   txt += "Date : " + dt + "\n";
   txt += "Type : " + type + "\n\n";
   txt += "Open  : " + DoubleToString(o, _Digits) + "\n";
   txt += "High  : " + DoubleToString(h, _Digits) + "\n";
   txt += "Low   : " + DoubleToString(l, _Digits) + "\n";
   txt += "Close : " + DoubleToString(c, _Digits);

   ShowPanel(txt);
   DrawSelectedCandleBox(shift);
}

void DrawSelectedCandleBox(const int shift)
{
   ClearSelectedBox();

   datetime t1 = iTime(_Symbol, _Period, shift);
   datetime t2 = iTime(_Symbol, _Period, shift - 1);
   if(shift == 0)
      t2 = t1 + PeriodSeconds(_Period);

   double hi = iHigh(_Symbol, _Period, shift);
   double lo = iLow(_Symbol, _Period, shift);
   double range = (hi - lo);
   if(range <= 0)
      range = _Point * 10;

   double margin = range * 0.15;

   if(ObjectCreate(0, PANEL_BOX, OBJ_RECTANGLE, 0, t1, hi + margin, t2, lo - margin))
   {
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_COLOR, CandleMarkColor);
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_FILL, false);
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_BACK, false);
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_HIDDEN, true);
   }
}
