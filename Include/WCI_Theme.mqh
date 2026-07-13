#pragma once

class CWCI_Theme
{
public:
   static color Background()
   {
      return clrBlack;
   }

   static color Text()
   {
      return clrWhite;
   }

   static color Border()
   {
      return clrDodgerBlue;
   }

   static color CandleMark()
   {
      return clrGold;
   }

   static int PanelWidth()
   {
      return 380;
   }

   static int PanelHeight()
   {
      return 280;
   }

   static int PanelX()
   {
      return 20;
   }

   static int PanelY()
   {
      return 20;
   }
};
