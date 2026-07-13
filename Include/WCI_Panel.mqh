#ifndef WCI_PANEL_MQH
#define WCI_PANEL_MQH

// Panneau d'infos : fond + une OBJ_LABEL par ligne.
// Les longues phrases (ex. interprétation) sont découpées (word-wrap)
// pour rester visibles dans la largeur du panneau.
class CWCI_Panel
{
private:
   string m_bg_name;
   string m_line_prefix;   // préfixe des labels : WCI_PanelLine_0, _1, ...
   int    m_line_count;    // nombre de lignes actuellement affichées
   int    m_x;
   int    m_y;
   int    m_width;
   int    m_height;
   color  m_bg_color;
   color  m_text_color;
   color  m_border_color;
   int    m_font_size;
   int    m_line_height;   // espacement vertical entre lignes (pixels)

   string LineName(const int index) const
   {
      return m_line_prefix + IntegerToString(index);
   }

   void ClearLines()
   {
      for(int i = 0; i < m_line_count; i++)
         ObjectDelete(0, LineName(i));
      m_line_count = 0;
   }

   // Ajoute une chaîne dans le tableau de lignes affichées
   void PushLine(string &out[], const string line)
   {
      int n = ArraySize(out);
      ArrayResize(out, n + 1);
      out[n] = line;
   }

   // Largeur utile en caractères approx. (police Consolas monospace)
   int MaxCharsPerLine() const
   {
      // marge gauche/droite ~24 px ; ~6 px par caractère en taille 9
      int char_w = MathMax(5, m_font_size - 3);
      int max_chars = (m_width - 24) / char_w;
      if(max_chars < 20)
         max_chars = 20;
      return max_chars;
   }

   // Coupe un mot trop long caractère par caractère
   void PushHardBreak(string &out[], const string word, const int max_chars)
   {
      string rest = word;
      while(StringLen(rest) > max_chars)
      {
         PushLine(out, StringSubstr(rest, 0, max_chars));
         rest = StringSubstr(rest, max_chars);
      }
      if(StringLen(rest) > 0)
         PushLine(out, rest);
   }

   // Word-wrap d'une ligne source → plusieurs lignes dans out[]
   void AppendWrapped(string &out[], const string line, const int max_chars)
   {
      // Ligne vide (espace vertical du rapport)
      if(StringLen(line) == 0)
      {
         PushLine(out, "");
         return;
      }

      // Déjà assez courte
      if(StringLen(line) <= max_chars)
      {
         PushLine(out, line);
         return;
      }

      // Découpe en mots (espaces)
      string words[];
      int wc = StringSplit(line, ' ', words);
      if(wc <= 0)
      {
         PushHardBreak(out, line, max_chars);
         return;
      }

      string current = "";
      for(int i = 0; i < wc; i++)
      {
         string word = words[i];
         string candidate = (StringLen(current) == 0) ? word : (current + " " + word);

         if(StringLen(candidate) <= max_chars)
         {
            current = candidate;
            continue;
         }

         // La ligne courante est pleine → on la pousse
         if(StringLen(current) > 0)
            PushLine(out, current);

         // Mot plus long que la largeur → coupe forcée
         if(StringLen(word) > max_chars)
         {
            PushHardBreak(out, word, max_chars);
            // Le dernier fragment trop long a déjà été poussé entièrement ;
            // on repart sur une ligne vide pour le mot suivant.
            // Si PushHardBreak a tout poussé, current reste vide.
            // En pratique PushHardBreak pousse tout le mot → current = ""
            current = "";
         }
         else
            current = word;
      }

      if(StringLen(current) > 0)
         PushLine(out, current);
   }

public:
   CWCI_Panel()
   {
      m_bg_name      = "WCI_PanelBG";
      m_line_prefix  = "WCI_PanelLine_";
      m_line_count   = 0;
      m_x            = 20;
      m_y            = 20;
      m_width        = 380;
      m_height       = 280;
      m_bg_color     = clrBlack;
      m_text_color    = clrWhite;
      m_border_color  = clrDodgerBlue;
      m_font_size    = 9;
      m_line_height  = 16;
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
      ObjectDelete(0, "WCI_PanelText");

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

      return true;
   }

   // Affiche le rapport : \n puis word-wrap, une label par ligne visible
   void Show(const string text)
   {
      ClearLines();

      string raw[];
      int raw_count = StringSplit(text, StringGetCharacter("\n", 0), raw);
      if(raw_count <= 0)
         return;

      int max_chars = MaxCharsPerLine();
      string display[];
      ArrayResize(display, 0);

      for(int i = 0; i < raw_count; i++)
         AppendWrapped(display, raw[i], max_chars);

      int count = ArraySize(display);
      if(count <= 0)
         return;

      int needed_height = 16 + (count * m_line_height);
      if(needed_height < m_height)
         needed_height = m_height;
      ObjectSetInteger(0, m_bg_name, OBJPROP_YSIZE, needed_height);
      ObjectSetInteger(0, m_bg_name, OBJPROP_HIDDEN, false);

      for(int i = 0; i < count; i++)
      {
         string name = LineName(i);
         if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
            continue;

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_x + 12);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_y + 8 + (i * m_line_height));
         ObjectSetInteger(0, name, OBJPROP_COLOR, m_text_color);
         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, m_font_size);
         ObjectSetString(0, name, OBJPROP_FONT, "Consolas");
         ObjectSetString(0, name, OBJPROP_TEXT, display[i]);
         ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
         ObjectSetInteger(0, name, OBJPROP_BACK, false);
      }

      m_line_count = count;
      ChartRedraw(0);
   }

   void Hide()
   {
      ObjectSetInteger(0, m_bg_name, OBJPROP_HIDDEN, true);
      for(int i = 0; i < m_line_count; i++)
         ObjectSetInteger(0, LineName(i), OBJPROP_HIDDEN, true);
   }

   void Delete()
   {
      ClearLines();
      ObjectDelete(0, m_bg_name);
      ObjectDelete(0, "WCI_PanelText");
   }

   string BackgroundName() const { return m_bg_name; }
};

#endif
