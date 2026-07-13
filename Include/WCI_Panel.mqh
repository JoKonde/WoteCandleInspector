#pragma once

class CWCI_Panel
{
private:
   string m_bg_name;
   string m_text_name;
   int    m_x;
   int    m_y;
   int    m_width;
   int    m_height;
   color  m_bg_color;
   color  m_text_color;
   color  m_border_color;

public:
   CWCI_Panel()
   {
      m_bg_name      = "WCI_PanelBG";
      m_text_name    = "WCI_PanelText";
      m_x            = 20;
      m_y            = 20;
      m_width        = 380;
      m_height       = 280;
      m_bg_color     = clrBlack;
      m_text_color    = clrWhite;
      m_border_color  = clrDodgerBlue;
   }

   void Configure(const int x,const int y,const int width,const int height,const color bg,const color text,const color border)
   {
      m_x = x;
      m_y = y;
      m_width = width;
      m_height = height;
      m_bg_color = bg;
      m_text_color = text;
      m_border_color = border;
   }

   bool Create()
   {
      if(ObjectFind(0, m_bg_name) < 0)
      {
         if(!ObjectCreate(0, m_bg_name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
            return false;

         ObjectSetInteger(0, m_bg_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         ObjectSetInteger(0, m_bg_name, OBJPROP_XDISTANCE, m_x);
         ObjectSetInteger(0, m_bg_name, OBJPROP_YDISTANCE, m_y);
         ObjectSetInteger(0, m_bg_name, OBJPROP_XSIZE, m_width);
         ObjectSetInteger(0, m_bg_name, OBJPROP_YSIZE, m_height);
         ObjectSetInteger(0, m_bg_name, OBJPROP_BGCOLOR, m_bg_color);
         ObjectSetInteger(0, m_bg_name, OBJPROP_COLOR, m_border_color);
         ObjectSetInteger(0, m_bg_name, OBJPROP_BACK, false);
         ObjectSetInteger(0, m_bg_name, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSetInteger(0, m_bg_name, OBJPROP_WIDTH, 1);
         ObjectSetInteger(0, m_bg_name, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, m_bg_name, OBJPROP_HIDDEN, true);
      }

      if(ObjectFind(0, m_text_name) < 0)
      {
         if(!ObjectCreate(0, m_text_name, OBJ_LABEL, 0, 0, 0))
            return false;

         ObjectSetInteger(0, m_text_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         ObjectSetInteger(0, m_text_name, OBJPROP_XDISTANCE, m_x + 12);
         ObjectSetInteger(0, m_text_name, OBJPROP_YDISTANCE, m_y + 10);
         ObjectSetInteger(0, m_text_name, OBJPROP_COLOR, m_text_color);
         ObjectSetInteger(0, m_text_name, OBJPROP_FONTSIZE, 10);
         ObjectSetString(0, m_text_name, OBJPROP_FONT, "Arial");
         ObjectSetInteger(0, m_text_name, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, m_text_name, OBJPROP_HIDDEN, true);
      }

      return true;
   }

   void Show(const string text)
   {
      ObjectSetString(0, m_text_name, OBJPROP_TEXT, text);
      ObjectSetInteger(0, m_bg_name, OBJPROP_HIDDEN, false);
      ObjectSetInteger(0, m_text_name, OBJPROP_HIDDEN, false);
      ChartRedraw(0);
   }

   void Hide()
   {
      ObjectSetInteger(0, m_bg_name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, m_text_name, OBJPROP_HIDDEN, true);
   }

   void Delete()
   {
      ObjectDelete(0, m_bg_name);
      ObjectDelete(0, m_text_name);
   }

   string BackgroundName() const { return m_bg_name; }
   string TextName() const { return m_text_name; }
};
