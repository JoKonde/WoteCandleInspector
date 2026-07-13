//+------------------------------------------------------------------+
//|                                          WoteCandleInspector.mq5 |
//|                                                        Wote 2026 |
//|                                                https://wotes.org |
//+------------------------------------------------------------------+
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

#include <Include/WCI_Utils.mqh>
#include <Include/WCI_Candle.mqh>
#include <Include/WCI_Patterns.mqh>
#include <Include/WCI_Selector.mqh>

input color PanelBgColor      = clrBlack;
input color PanelTextColor    = clrWhite;
input color PanelBorderColor  = clrDodgerBlue;
input color CandleMarkColor   = clrGold;
input int   PanelX            = 20;
input int   PanelY            = 20;
input int   PanelWidth        = 380;
input int   PanelHeight       = 280;

string PANEL_BG  = "WCI_PanelBG";
string PANEL_TXT = "WCI_PanelText";
string PANEL_BOX = "WCI_SelectedCandleBox";

bool g_panel_visible = false;

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
      ObjectSetInteger(0, PANEL_BG, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, PANEL_BG, OBJPROP_HIDDEN, true);
   }

   if(ObjectFind(0, PANEL_TXT) < 0)
   {
      ObjectCreate(0, PANEL_TXT, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_XDISTANCE, PanelX + 12);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_YDISTANCE, PanelY + 10);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_COLOR, PanelTextColor);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_FONTSIZE, 10);
      ObjectSetString(0, PANEL_TXT, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, PANEL_TXT, OBJPROP_HIDDEN, true);
   }
}

void ShowPanel(const string text)
{
   ObjectSetString(0, PANEL_TXT, OBJPROP_TEXT, text);
   ObjectSetInteger(0, PANEL_BG, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, PANEL_TXT, OBJPROP_HIDDEN, false);
   g_panel_visible = true;
   ChartRedraw(0);
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

void DrawSelectedCandleBox(const int shift)
{
   ClearSelectedBox();

   datetime t1 = iTime(_Symbol, _Period, shift);
   datetime t2 = iTime(_Symbol, _Period, shift - 1);
   if(shift == 0)
      t2 = t1 + PeriodSeconds(_Period);

   double hi = iHigh(_Symbol, _Period, shift);
   double lo = iLow(_Symbol, _Period, shift);
   double range = hi - lo;
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

void ShowCandleInfoByShift(const int shift)
{
   CWCI_Candle candle;
   if(!CWCI_Selector::LoadSelectedCandle(shift, candle))
      return;

   string type = candle.Type();
   string pattern = CWCI_Patterns::Detect(candle);
   string interpretation = CWCI_Patterns::Interpretation(pattern, type);

   string txt = "WoteCandleInspector v4.0 Pro\n";
   txt += "--------------------------------\n";
   txt += "Date : " + candle.DateTimeText() + "\n";
   txt += "Type : " + type + "\n";
   txt += "Pattern : " + pattern + "\n\n";
   txt += "Open  : " + DoubleToString(candle.open, _Digits) + "\n";
   txt += "High  : " + DoubleToString(candle.high, _Digits) + "\n";
   txt += "Low   : " + DoubleToString(candle.low, _Digits) + "\n";
   txt += "Close : " + DoubleToString(candle.close, _Digits) + "\n\n";
   txt += "Corps       : " + DoubleToString(candle.BodyPips(), 1) + " pips\n";
   txt += "Mèche haute : " + DoubleToString(candle.UpperWickPips(), 1) + " pips\n";
   txt += "Mèche basse : " + DoubleToString(candle.LowerWickPips(), 1) + " pips\n";
   txt += "Amplitude   : " + DoubleToString(candle.RangePips(), 1) + " pips\n\n";
   txt += "Interprétation : " + interpretation;

   ShowPanel(txt);
   DrawSelectedCandleBox(shift);
}

int OnInit()
{
   CreatePanel();
   HidePanel();
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
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

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id == CHARTEVENT_CLICK)
   {
      int x = (int)lparam;
      int shift = CWCI_Selector::ByClickX(x);
      if(shift >= 0)
         ShowCandleInfoByShift(shift);
   }
}
