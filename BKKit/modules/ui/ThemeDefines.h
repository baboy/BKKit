//
//  ThemeDefines.h
//  BKKit
//
//  Created by baboy on 23/11/2017.
//  Copyright © 2017 baboy. All rights reserved.
//

#ifndef ThemeDefines_h
#define ThemeDefines_h

/*******table view****/
#define gTableViewBgColor [UIColor colorWithWhite:1.0 alpha:1]
#define gTableViewSelectedBgColor [UIColor colorWithWhite:0.8 alpha:1]
#define gLineTopColor [UIColor colorWithWhite:0.8 alpha:1]
#define gLineBottomColor [UIColor colorWithWhite:1.0 alpha:1]

/*section*/
#define gTableSectionTitleFont  [UIFont systemFontOfSize:14]
#define gTableSectionTitleColor [UIColor colorWithWhite:0 alpha:1]
#define gTableSectionBgColor    [UIColor colorWithWhite:0.75 alpha:1]

// in theme config file
#define ThemeTitleColor             [UIColor colorWithWhite:0 alpha:1]
#define ThemeDescTextColor           [UIColor colorWithWhite:0.4 alpha:1]
#define ThemeDescTextFont           [UIFont systemFontOfSize:14]
#define ThemeDescTextShadowColor    [UIColor colorWithWhite:1 alpha:1]

#define gTableCellTagFont     [UIFont systemFontOfSize:12]
#define gTableCellNoteFont     [UIFont systemFontOfSize:12]
#define gTableCellTagColor    [UIColor colorWithWhite:0.4 alpha:1]



#define gButtonTitleShadowColor     [UIColor colorWithWhite:0 alpha:0.5]


#define gThumbnailColor         [UIColor colorWithWhite:1.0 alpha:1]

#define gNoteFont               [UIFont systemFontOfSize:12.0]
#define gNoteColor              [UIColor colorWithWhite:0.3 alpha:1]
#define gTagFont               [UIFont systemFontOfSize:12.0]
#define gTagColor               [UIColor colorWithWhite:0.5 alpha:1]
#define gTitleColor             [UIColor colorWithWhite:0 alpha:1]
#define gTitleFont              [UIFont boldSystemFontOfSize:16.0]
#define gBigTitleFont              [UIFont boldSystemFontOfSize:18.0]
#define gDescFont               [UIFont systemFontOfSize:14.0]
#define gDescColor              [UIColor colorWithWhite:0.3 alpha:1]
#define gTitleShadowColor       [UIColor colorWithWhite:1 alpha:0.9]
#define gShadowColor            [UIColor colorWithWhite:0.1 alpha:0.6]

/*******按钮圆形图片*******/
#define gButtonCircleBgGradColor1    [UIColor colorWithWhite:0.8 alpha:1]
#define gButtonCircleBgGradColor2    [UIColor colorWithWhite:0.96 alpha:1]
#define gButtonCircleBgGradColor3    [UIColor colorWithWhite:0.98 alpha:1]
#define gButtonCircleBgGradColor4    [UIColor colorWithWhite:0.8 alpha:1]
#define gButtonCircleBgImageColor    [UIColor colorWithWhite:0.7 alpha:1]
/***mv小窗口**/
#define gMVWindowWidth               240
#define gMVWindowHeight              180
/***歌词***/

#define gLyricFont                  [UIFont systemFontOfSize:14]
#define gLyricColor                 [UIColor colorWithWhite:1 alpha:0.8]
#define gLyricHighlightColor        [UIColor colorWithWhite:1 alpha:0.8]
#define gLyricShadowColor           [UIColor colorWithWhite:0 alpha:0.8]
#define gLyricShadowHighlightColor  [UIColor redColor]
#define gLyricColorHightlight       [UIColor redColor]

#define gWidgetShadowColor      [UIColor colorWithWhite:0 alpha:0.8]
#define gWidgetBgColor          [UIColor colorWithWhite:0 alpha:0.5]
#define gWidgetTextColor          [UIColor colorWithWhite:1 alpha:0.5]
#define gWidgetTextShadowColor     [UIColor colorWithWhite:0 alpha:0.5]
#define gWidgetBorderColor      [UIColor colorWithWhite:1 alpha:0.5]
#define gWidgetCornerRad        6.0

#define defNavBgColor           [UIColor colorFromString:@"#1ba1e2"]
/*

*/
#define LoadNib(nib, owner) [[[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil] objectAtIndex:0]
#define LoadNibFromClass(nibClass, owner) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(nibClass) owner:owner options:nil] objectAtIndex:0]

#endif /* ThemeDefines_h */
