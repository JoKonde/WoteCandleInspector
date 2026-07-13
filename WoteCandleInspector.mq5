//+------------------------------------------------------------------+
//|                                          WoteCandleInspector.mq5 |
//|                                                        Wote 2026 |
//|                                                https://wotes.org |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

input color  PanelBgColor      = clrBlack;
input color  PanelTextColor    = clrWhite;
input color  PanelBorderColor  = clrDodgerBlue;
input color  CandleMarkColor   = clrGold;
input int    PanelX            = 20;
input int    PanelY            = 20;
input int    PanelWidth        = 360;
input int    PanelHeight       = 250;

string PANEL_BG  = "WCI_PanelBG";
string PANEL_TXT = "WCI_PanelText";
string PANEL_BOX = "WCI_SelectedCandleBox";

bool g_panel_visible = false;

string CandleType(const double o,const double c)
{
   return (c >= o) ? "Haussiere" : "Baissiere";
}

double PipValue()
{
   if(_Digits == 3 || _Digits == 5)
      return(_Point * 10.0);
   return(_Point);
}

double CandleBody(const double o,const double c)
{
   return MathAbs(c - o);
}

double UpperWick(const double o,const double h,const double c)
{
   return h - MathMax(o, c);
}

double LowerWick(const double o,const double l,const double c)
{
   return MathMin(o, c) - l;
}

string DetectPattern(const double o,const double h,const double l,const double c)
{
   double body = CandleBody(o, c);
   double range = h - l;
   if(range <= 0.0)
      return("Aucun");

   double upper_wick = UpperWick(o, h, c);
   double lower_wick = LowerWick(o, l, c);

   if(body <= range * 0.1)
      return("Doji");

   if(lower_wick >= body * 2.0 && upper_wick <= body * 0.5)
      return("Marteau");

   if(upper_wick >= body * 2.0 && lower_wick <= body * 0.5)
      return("Shooting Star");

   return("Aucun");
}

string BuildInterpretation(const string pattern,const string type)
{
   if(pattern == "Marteau")
      return("Rejet des bas : les acheteurs ont repris la main.");
   if(pattern == "Shooting Star")
      return("Rejet des hauts : les vendeurs ont repris le contrôle.");
   if(pattern == "Doji")
      return("Indecision : acheteurs et vendeurs sont équilibrés.");
   if(type == "Haussiere")
      return("Bougie haussiere : les acheteurs dominent.");
   return("Bougie baissiere : les vendeurs dominent.");
}

int OnInit()
{
   EventSetMillisecondTimer(250);
   CreatePanel();
   HidePanel();
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
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

int GetNearestBarByX(const int x)
{
   datetime t;
   double p;
   int subwindow = 0;
   if(!ChartXYToTimePrice(0, x, 0, subwindow, t, p))
      return(-1);
   return(iBarShift(_Symbol, _Period, t, false));
}

void ShowCandleInfoByClick(const int x, const int y)
{
   int shift = GetNearestBarByX(x);
   if(shift < 0)
      return;

   datetime t = iTime(_Symbol, _Period, shift);
   double o = iOpen(_Symbol, _Period, shift);
   double h = iHigh(_Symbol, _Period, shift);
   double l = iLow(_Symbol, _Period, shift);
   double c = iClose(_Symbol, _Period, shift);

   if(t <= 0)
      return;

   string type = CandleType(o, c);
   string dt   = TimeToString(t, TIME_DATE | TIME_MINUTES);
   double body = CandleBody(o, c);
   double upper_wick = UpperWick(o, h, c);
   double lower_wick = LowerWick(o, l, c);
   double range = h - l;
   double pip = PipValue();
   string pattern = DetectPattern(o, h, l, c);
   string interpretation = BuildInterpretation(pattern, type);

   string txt = "WoteCandleInspector v3.0\n";
   txt += "-------------------------\n";
   txt += "Date : " + dt + "\n";
   txt += "Type : " + type + "\n";
   txt += "Pattern : " + pattern + "\n\n";
   txt += "Open  : " + DoubleToString(o, _Digits) + "\n";
   txt += "High  : " + DoubleToString(h, _Digits) + "\n";
   txt += "Low   : " + DoubleToString(l, _Digits) + "\n";
   txt += "Close : " + DoubleToString(c, _Digits) + "\n\n";
   txt += "Corps       : " + DoubleToString(body / pip, 1) + " pips\n";
   txt += "Mèche haute : " + DoubleToString(upper_wick / pip, 1) + " pips\n";
   txt += "Mèche basse : " + DoubleToString(lower_wick / pip, 1) + " pips\n";
   txt += "Amplitude   : " + DoubleToString(range / pip, 1) + " pips\n\n";
   txt += "Interprétation : " + interpretation;

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
