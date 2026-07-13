# WoteCandleInspector

**WoteCandleInspector** est un indicateur pour **MetaTrader 5 (MT5)** permettant d'inspecter facilement les bougies japonaises directement sur le graphique.

En cliquant sur une bougie, l'indicateur affiche ses informations essentielles (OHLC), ses mesures en pips, les patterns détectés et une interprétation pédagogique pour l'analyse du **Price Action**.

## ✨ Fonctionnalités

### Version actuelle (v4.0 Pro)

- Affichage des valeurs **Open**, **High**, **Low** et **Close**
- Affichage de la date et de l'heure de la bougie
- Type de bougie : **Haussière** ou **Baissière**
- Mesure du **corps**, des **mèches** (haute et basse) et de l'**amplitude** en pips
- Détection automatique des patterns :
  - Doji
  - Marteau
  - Shooting Star
  - Bullish Impulse
  - Bearish Impulse
- **Interprétation pédagogique** en français selon le pattern ou le type de bougie
- **Panneau d'informations** sur le graphique (thème sombre)
- **Mise en évidence** de la bougie sélectionnée (rectangle doré)

### Fonctionnalités prévues

- Copie des informations de la bougie dans le presse-papiers
- Panneau personnalisable (couleurs, position, taille via paramètres d'entrée)
- Assistant pédagogique avancé (v2.0)

## 🎯 Objectif

L'objectif de **WoteCandleInspector** est de faciliter l'analyse des chandeliers japonais et d'aider les traders à mieux comprendre le comportement des acheteurs et des vendeurs à chaque bougie.

## 🏗️ Architecture

```
WoteCandleInspector.mq5      → Point d'entrée (événements, dessin)
Include/
  WCI_Candle.mqh             → Modèle de données et calculs d'une bougie
  WCI_Selector.mqh           → Sélection de la bougie au clic
  WCI_Analyzer.mqh           → Génération du rapport texte
  WCI_Patterns.mqh           → Détection de patterns et interprétation
  WCI_Panel.mqh              → Panneau graphique (labels + word-wrap)
  WCI_Theme.mqh              → Couleurs et dimensions du panneau
  WCI_Utils.mqh              → Fonctions utilitaires (pips, corps, mèches)
```

## 🚀 Feuille de route

- **v1.0** ✅ Inspection des valeurs OHLC
- **v1.1** ✅ Calcul du corps, des mèches et de l'amplitude (en pips)
- **v1.2** ✅ Détection des patterns de chandeliers
- **v1.3** ✅ Interface graphique (panneau + mise en évidence)
- **v2.0** 🔜 Assistant pédagogique avancé + copie presse-papiers + personnalisation

## 📦 Installation, compilation et utilisation

### 1. Placer les fichiers au bon endroit

MetaTrader 5 ne lit **pas** directement ton dossier `Documents\tutoriels\`. Il faut copier le projet dans le dossier de données du terminal.

1. Ouvre **MetaTrader 5**
2. Menu **Fichier → Ouvrir le dossier de données**
3. Va dans le sous-dossier : `MQL5\Indicators\`
4. Copie tout le dossier **`WoteCandleInspector`** dedans

Structure attendue :

```
MQL5\Indicators\WoteCandleInspector\
├── WoteCandleInspector.mq5
├── Include\
│   ├── WCI_Analyzer.mqh
│   ├── WCI_Candle.mqh
│   ├── WCI_Panel.mqh
│   ├── WCI_Patterns.mqh
│   ├── WCI_Selector.mqh
│   ├── WCI_Theme.mqh
│   └── WCI_Utils.mqh
└── README.md   (optionnel)
```

> Important : garde le dossier `Include` **à côté** du fichier `.mq5`, pas dans `MQL5\Include\`.

### 2. Compiler dans MetaEditor

1. Dans MT5 : **Outils → MetaQuotes Language Editor** (ou touche **F4**)
2. Dans le **Navigateur** à gauche, ouvre :  
   `Indicateurs → WoteCandleInspector → WoteCandleInspector.mq5`
3. Appuie sur **F7** (ou bouton **Compile**)
4. En bas, onglet **Erreurs** : tu dois voir **0 error(s), 0 warning(s)**

Si tu modifies un fichier `.mqh`, recompile toujours le `.mq5` (F7), puis **retire et remets** l’indicateur sur le graphique pour recharger la nouvelle version.

### 3. Ajouter l’indicateur sur un graphique

1. Dans MT5, ouvre un graphique (ex. EURUSD H1)
2. Dans le **Navigateur** (Ctrl+N) :  
   `Indicateurs → WoteCandleInspector → WoteCandleInspector`
3. **Glisse-dépose** l’indicateur sur le graphique  
   (ou double-clic → **OK**)
4. Vérifie dans le **Journal** le message :  
   `custom indicator WoteCandleInspector (...) loaded successfully`

### 4. Utiliser l’outil

1. **Clique** sur une bougie du graphique
2. Un **rectangle doré** entoure la bougie sélectionnée
3. Un **panneau noir** affiche :
   - Date / Type / Pattern
   - Open, High, Low, Close
   - Corps, mèches et amplitude en pips
   - Interprétation Price Action (texte long = retour à la ligne automatique)

Pour enlever l’indicateur : clic droit sur le graphique → **Liste des indicateurs** → sélectionne `WoteCandleInspector` → **Supprimer**.

## 🤝 Contributions

Les suggestions, les signalements de bugs et les contributions sont les bienvenus.

## 📄 Licence

À définir.

---

Développé avec ❤️ par **Jonathan Konde**

**WOTE — Au-delà de l'imagination !**
