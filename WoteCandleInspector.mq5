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
#include <Include/WCI_Panel.mqh>
#include <Include/WCI_Analyzer.mqh>
#include <Include/WCI_Theme.mqh>

CWCI_Panel    g_panel;
CWCI_Candle   g_candle;

string PANEL_BOX = "WCI_SelectedCandleBox";

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
      ObjectSetInteger(0, PANEL_BOX, OBJPROP_COLOR, CWCI_Theme::CandleMark());
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
   if(!CWCI_Selector::LoadSelectedCandle(shift, g_candle))
      return;

   string report = CWCI_Analyzer::BuildReport(g_candle);
   g_panel.Show(report);
   DrawSelectedCandleBox(shift);
}

int OnInit()
{
   g_panel.Configure(CWCI_Theme::PanelX(), CWCI_Theme::PanelY(), CWCI_Theme::PanelWidth(), CWCI_Theme::PanelHeight(), CWCI_Theme::Background(), CWCI_Theme::Text(), CWCI_Theme::Border());
   g_panel.Create();
   g_panel.Hide();
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   g_panel.Delete();
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
