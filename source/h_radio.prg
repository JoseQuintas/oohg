/*
 * $Id: h_radio.prg,v 1.50 2016-10-22 16:23:55 fyurisich Exp $
 */
/*
 * ooHG source code:
 * RadioGroup control
 *
 * Copyright 2005-2016 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
 */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 */


#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TRadioGroup FROM TLabel
   DATA Type                   INIT "RADIOGROUP" READONLY
   DATA TabStop                INIT .T.
   DATA IconWidth              INIT 19
   DATA nWidth                 INIT 120
   DATA nHeight                INIT 25
   DATA aOptions               INIT {}
   DATA TabHandle              INIT 0
   DATA lHorizontal            INIT .F.
   DATA nSpacing               INIT nil
   DATA lThemed                INIT .F.
   DATA oBkGrnd                INIT nil
   DATA LeftAlign              INIT .F.

   METHOD RowMargin            BLOCK { |Self| - ::Row }
   METHOD ColMargin            BLOCK { |Self| - ::Col }
   METHOD ReadOnly             SETGET
   METHOD Define
   METHOD SetFont
   METHOD SizePos
   METHOD Value                SETGET
   METHOD Enabled              SETGET
   METHOD SetFocus
   METHOD Visible              SETGET
   METHOD GroupHeight
   METHOD GroupWidth
   METHOD ItemCount            BLOCK { |Self| LEN( ::aOptions ) }
   METHOD AddItem
   METHOD InsertItem
   METHOD DeleteItem
   METHOD Caption
   METHOD AdjustResize
   METHOD ItemEnabled
   METHOD ItemReadOnly
   METHOD Spacing              SETGET

   EMPTY( _OOHG_AllVars )
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, aOptions, Value, fontname, ;
               fontsize, tooltip, change, width, spacing, HelpId, invisible, ;
               notabstop, bold, italic, underline, strikeout, backcolor, ;
               fontcolor, transparent, autosize, horizontal, lDisabled, lRtl, ;
               height, themed, bkgrnd, left, readonly ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local i, oItem, uToolTip, uReadOnly

   ASSIGN ::nCol        VALUE x           TYPE "N"
   ASSIGN ::nRow        VALUE y           TYPE "N"
   ASSIGN ::nWidth      VALUE width       TYPE "N"
   ASSIGN ::nHeight     VALUE height      TYPE "N"
   ASSIGN ::lAutoSize   VALUE autosize    TYPE "L"
   ASSIGN ::lHorizontal VALUE horizontal  TYPE "L"
   ASSIGN ::Transparent VALUE transparent TYPE "L"
   ASSIGN ::LeftAlign   VALUE left        TYPE "L"
   ASSIGN ::nSpacing    VALUE spacing     TYPE "N" DEFAULT Iif( ::lHorizontal, ::nWidth, ::nHeight )
   ASSIGN aOptions      VALUE aOptions    TYPE "A" DEFAULT {}

   If HB_IsObject( bkgrnd )
      ::oBkGrnd := bkgrnd
      ::lThemed := .T.
   Else
      ASSIGN ::lThemed VALUE themed TYPE "L" DEFAULT IsAppThemed()
   EndIf

   IF HB_IsLogical( NoTabStop )
      ::TabStop := ! NoTabStop
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, , lRtl )
   ::InitStyle( , , Invisible, ! ::TabStop, lDisabled )
   ::Register( 0, , HelpId, , tooltip )

   ::AutoSize := autosize

   ::aOptions := {}

   x := ::Col
   y := ::Row
   For i = 1 to LEN( aOptions )
      If HB_IsArray( tooltip ) .AND. LEN( tooltip ) >= i
         uToolTip := tooltip[ i ]
      Else
         uToolTip := ::ToolTip
      EndIf
      If HB_IsArray( readonly ) .AND. LEN( readonly ) >= i
         uReadOnly := readonly[ i ]
      Else
         uReadOnly := readonly
      EndIf

      oItem := TRadioItem():Define( , Self, x, y, ::nWidth, ::nHeight, ;
               aOptions[ i ], .F., ( i == 1 ), ;
               ::AutoSize, ::Transparent, , , ;
               , , , , , , ;
               uToolTip, ::HelpId, , .T., uReadOnly, , ;
               bkgrnd, ::LeftAlign )

      AADD( ::aOptions, oItem )
      If ::lHorizontal
         x += ::nSpacing
      Else
         y += ::nSpacing
      EndIf
   Next

   ::Value := Value

   If ! HB_IsNumeric( Value ) .AND. LEN( ::aOptions ) > 0
      ::aOptions[ 1 ]:TabStop := .T.
   EndIf

   ::SetFont( , , bold, italic, underline, strikeout )

   ASSIGN ::OnChange VALUE Change TYPE "B"

Return Self

*------------------------------------------------------------------------------*
METHOD GroupHeight() CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local nRet, oFirst, oLast

   IF ::lHorizontal
      nRet := ::Height
   ELSE
      IF LEN( ::aOptions ) > 0
         oFirst := ::aOptions[ 1 ]
         oLast  := aTail( ::aOptions )
         nRet   := oLast:Row + oLast:Height - oFirst:Row
      ELSE
         nRet := 0
      ENDIF
   ENDIF
RETURN nRet

*------------------------------------------------------------------------------*
METHOD GroupWidth() CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local nRet, oFirst, oLast

   IF ::lHorizontal
      IF LEN( ::aOptions ) > 0
         oFirst := ::aOptions[ 1 ]
         oLast  := aTail( ::aOptions )
         nRet   := oLast:Col + oLast:Width - oFirst:Col
      ELSE
         nRet := 0
      ENDIF
   ELSE
      nRet := ::Width
   ENDIF
RETURN nRet

*------------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
   AEVAL( ::aOptions, { |o| o:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) } )
RETURN ::Super:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout )

*------------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local nDeltaRow, nDeltaCol, uRet
   nDeltaRow := ::Row
   nDeltaCol := ::Col
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   nDeltaRow := ::Row - nDeltaRow
   nDeltaCol := ::Col - nDeltaCol
   AEVAL( ::aControls, { |o| o:Visible := .F., o:SizePos( o:Row + nDeltaRow, o:Col + nDeltaCol, Width, Height ), o:Visible := .T. } )
Return uRet

*------------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
LOCAL i, lSetFocus
   If HB_IsNumeric( nValue )
      nValue := INT( nValue )
      lSetFocus := ( ASCAN( ::aOptions, { |o| o:hWnd == GetFocus() } ) > 0 )
      For i := 1 TO LEN( ::aOptions )
         ::aOptions[ i ]:Value := ( i == nValue )
      Next
      nValue := ::Value
      For i := 1 TO LEN( ::aOptions )
         ::aOptions[ i ]:TabStop := ( ::TabStop .AND. i == MAX( nValue, 1 ) )
      Next
      If lSetFocus
         If nValue > 0
            ::aOptions[ nValue ]:SetFocus()
         EndIf
      EndIf
      ::DoChange()
   EndIf
RETURN ASCAN( ::aOptions, { |o| o:Value } )

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
   If HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   EndIf
RETURN ::Super:Enabled

*------------------------------------------------------------------------------*
METHOD SetFocus() CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local nValue
   nValue := ::Value
   If nValue >= 1 .AND. nValue <= LEN( ::aOptions )
      ::aOptions[ nValue ]:SetFocus()
   Else
      ::aOptions[ 1 ]:SetFocus()
   EndIf
Return Self

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
   If HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      If lVisible
         AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
      Else
         AEVAL( ::aControls, { |o| o:ForceHide() } )
      EndIf
   EndIf
RETURN ::lVisible

*------------------------------------------------------------------------------*
METHOD AddItem( cCaption, nImage, uToolTip ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Return ::InsertItem( ::ItemCount + 1, cCaption, nImage, uToolTip )

/*
TODO:
RadioItem with Image instead/and Text.

Note that TMultiPage control expects an Image as third parameter.
*/

*------------------------------------------------------------------------------*
METHOD InsertItem( nPosition, cCaption, nImage, uToolTip, bkgrnd, uLeftAlign, uReadOnly ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local nPos2, Spacing, oItem, x, y, nValue, hWnd
   EMPTY( nImage )
   IF  ( ! VALTYPE( uToolTip ) $ "CM" .OR. EMPTY( uToolTip ) ) .AND. ! HB_IsBlock( uToolTip )
      uToolTip := ::ToolTip
   ENDIF
   ASSIGN bkgrnd VALUE bkgrnd TYPE "O" DEFAULT ::oBkGrnd

   nValue := ::Value

   If HB_IsNumeric( ::nSpacing )
      Spacing := ::nSpacing
   Else
      Spacing := IF( ::lHorizontal, ::nWidth, ::nHeight )
   EndIf

   nPosition := INT( nPosition )
   If nPosition < 1 .OR. nPosition > LEN( ::aOptions )
      nPosition := LEN( ::aOptions ) + 1
   EndIf

   AADD( ::aOptions, nil )
   AINS( ::aOptions, nPosition )
   nPos2 := LEN( ::aOptions )
   DO WHILE nPos2 > nPosition
      If ::lHorizontal
         ::aOptions[ nPos2 ]:Col += Spacing
      Else
         ::aOptions[ nPos2 ]:Row += Spacing
      EndIf
      nPos2--
   ENDDO

   If nPosition == 1
      x := ::Col
      y := ::Row
      If LEN( ::aOptions ) > 1
         WindowStyleFlag( ::aOptions[ 2 ]:hWnd, WS_GROUP, 0 )
      EndIf
   Else
      x := ::aOptions[ nPosition - 1 ]:Col
      y := ::aOptions[ nPosition - 1 ]:Row
      If ::lHorizontal
         x += Spacing
      Else
         y += Spacing
      EndIf
   EndIf
   oItem := TRadioItem():Define( , Self, x, y, ::Width, ::Height, ;
            cCaption, .F., ( nPosition == 1 ), ;
            ::AutoSize, ::Transparent, , , ;
            , , , , , , ;
            uToolTip, ::HelpId, , .T., uReadOnly, , ;
            bkgrnd, uLeftAlign )
   ::aOptions[ nPosition ] := oItem

   If nPosition > 1
      SetWindowPos( oItem:hWnd, ::aOptions[ nPosition - 1 ]:hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ElseIf LEN( ::aOptions ) >= 2
      hWnd:= GetWindow( ::aOptions[ 2 ]:hWnd, GW_HWNDPREV )
      SetWindowPos( oItem:hWnd, hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   Endif

   If nValue >= nPosition
      ::Value := ::Value
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD DeleteItem( nItem ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local nValue
   nItem := INT( nItem )
   If nItem >= 1 .AND. nItem <= LEN( ::aOptions )
      nValue := ::Value
      ::aOptions[ nItem ]:Release()
      _OOHG_DeleteArrayItem( ::aOptions, nItem )
      If nItem == 1 .AND. LEN( ::aOptions ) > 0
         WindowStyleFlag( ::aOptions[ 1 ]:hWnd, WS_GROUP, WS_GROUP )
      EndIf
      If nValue >= nItem
         ::Value := nValue
      EndIf
   EndIf

   If nValue >= nItem
      ::Value := ::Value
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD Caption( nItem, uValue ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Return ( ::aOptions[ nItem ]:Caption := uValue )

*------------------------------------------------------------------------------*
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
   If HB_IsNumeric( ::nSpacing )
      If ::lHorizontal
         ::Spacing := ::nSpacing * nDivw
      Else
         ::Spacing := ::nSpacing * nDivh
      EndIf
   EndIf
Return ::Super:AdjustResize( nDivh, nDivw, lSelfOnly )

*------------------------------------------------------------------------------*
METHOD Spacing( nSpacing ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local x, y, i, oCtrl
   If HB_IsNumeric( nSpacing )
      x := ::Col
      y := ::Row
      For i = 1 to LEN( ::aOptions )
         oCtrl := ::aOptions[ i ]
         oCtrl:Visible := .F.
         oCtrl:SizePos( y, x )
         oCtrl:Visible := .T.
         If ::lHorizontal
            x += nSpacing
         Else
            y += nSpacing
         EndIf
      Next
      ::nSpacing := nSpacing
   EndIf
Return ::nSpacing

*------------------------------------------------------------------------------*
METHOD ItemEnabled( nItem, lEnabled ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
   If HB_IsLogical( lEnabled )
      ::aOptions[ nItem ]:Enabled := lEnabled
   EndIf
Return ::aOptions[ nItem ]:Enabled

*------------------------------------------------------------------------------*
METHOD ItemReadonly( nItem, lReadOnly ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
   If HB_IsLogical( lReadOnly )
      ::aOptions[ nItem ]:Enabled := ! lReadOnly
   EndIf
Return ! ::aOptions[ nItem ]:Enabled

*------------------------------------------------------------------------------*
METHOD ReadOnly( uReadOnly ) CLASS TRadioGroup
*------------------------------------------------------------------------------*
Local i, aReadOnly

   If HB_IsLogical( uReadOnly )
      aReadOnly := ARRAY( LEN( ::aOptions ) )
      AFILL( aReadOnly, uReadOnly )
   ElseIf HB_IsArray( uReadOnly )
      aReadOnly := ARRAY( LEN( ::aOptions ) )
      For i := 1 TO LEN( uReadOnly )
         If HB_IsLogical( uReadOnly[ i ] )
            aReadOnly[ i ] := uReadOnly[ i ]
         EndIf
      Next i
   EndIf

   If HB_IsArray( aReadOnly )
      For i := 1 TO LEN( ::aOptions )
         If HB_IsLogical( aReadOnly[ i ] )
            ::aOptions[ i ]:Enabled := ! aReadOnly[ i ]
         EndIf
      Next i
   Else
      aReadOnly := ARRAY( LEN( ::aOptions ) )
   EndIf

   For i := 1 TO LEN( ::aOptions )
      aReadOnly[ i ] := ! ::aOptions[ i ]:Enabled
   Next i

Return aReadOnly





CLASS TRadioItem FROM TLabel
   DATA Type          INIT "RADIOITEM" READONLY
   DATA nWidth        INIT 120
   DATA nHeight       INIT 25
   DATA IconWidth     INIT 19
   DATA TabHandle     INIT 0
   DATA oBkGrnd       INIT 0
   DATA LeftAlign     INIT .F.

   METHOD Define
   METHOD Value             SETGET
   METHOD Events
   METHOD Events_Command
   METHOD Events_Color
   METHOD Events_Notify
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, width, height, ;
               caption, value, lFirst, ;
               autosize, transparent, fontcolor, backcolor, ;
               fontname, fontsize, bold, italic, underline, strikeout, ;
               tooltip, HelpId, invisible, notabstop, lDisabled, lRtl, ;
               bkgrnd, left ) CLASS TRadioItem
*------------------------------------------------------------------------------*
Local ControlHandle, nStyle, oContainer

   ASSIGN ::nCol      VALUE x      TYPE "N"
   ASSIGN ::nRow      VALUE y      TYPE "N"
   ASSIGN ::nWidth    VALUE width  TYPE "N"
   ASSIGN ::nHeight   VALUE height TYPE "N"
   ASSIGN ::LeftAlign VALUE left   TYPE "L"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )

   If HB_IsObject( bkgrnd )
      ::oBkGrnd := bkgrnd
   ElseIf ::Parent:Type == "RADIOGROUP"
      ::oBkGrnd := ::Parent:oBkGrnd
   Endif

   nStyle := ::InitStyle( ,, Invisible, notabstop, lDisabled )

   If HB_IsLogical( lFirst ) .AND. lFirst
      ControlHandle := InitRadioGroup( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height, ::LeftAlign )
   Else
      ControlHandle := InitRadioButton( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height, ::LeftAlign )
   EndIf

   ::Register( ControlHandle,, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   If _OOHG_UsesVisualStyle()
      oContainer := ::Container
      DO WHILE ! oContainer == NIL
         If oContainer:Type == "TAB"
            ::TabHandle := oContainer:hWnd
            EXIT
         EndIf
         oContainer := oContainer:Container
      ENDDO
   EndIf

   ::Transparent := transparent
   ::AutoSize    := autosize
   ::Caption := caption

   ::Value := value
Return Self

*------------------------------------------------------------------------------*
METHOD Value( lValue ) CLASS TRadioItem
*------------------------------------------------------------------------------*
LOCAL lOldValue
   If HB_IsLogical( lValue )
      lOldValue := ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )
      If ! lValue == lOldValue
         SendMessage( ::hWnd, BM_SETCHECK, IF( lValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      EndIf
   EndIf
Return ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )

*------------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TRadioItem
*------------------------------------------------------------------------------*
   If nMsg == WM_LBUTTONDBLCLK
      If HB_IsBlock( ::OnDblClick )
         ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
      ElseIf ! ::Container == NIL
         ::Container:DoEventMouseCoords( ::Container:OnDblClick, "DBLCLICK" )
      EndIf
      Return nil
   ElseIf nMsg == WM_RBUTTONUP
      If HB_IsBlock( ::OnRClick )
         ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
      ElseIf ! ::Container == NIL
         ::Container:DoEventMouseCoords( ::Container:OnRClick, "RCLICK" )
      EndIf
      Return nil
   EndIf
RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TRadioItem
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
/*
Local lTab
*/
   If Hi_wParam == BN_CLICKED
      If ! ::Container == NIL
/*
         lTab := ( ::Container:TabStop .AND. ::Value )
         If ! lTab == ::TabStop
            ::TabStop := lTab
         EndIf
*/
         ::Container:DoChange()
      EndIf
      Return nil
   EndIf
Return ::Super:Events_Command( wParam )

*------------------------------------------------------------------------------*
METHOD Events_Color( wParam, nDefColor ) CLASS TRadioItem
*------------------------------------------------------------------------------*
Return Events_Color_InTab( Self, wParam, nDefColor )    // see h_controlmisc.prg

*------------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TRadioItem
*------------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == NM_CUSTOMDRAW
      If ! ::Container == NIL .AND. ::Container:lThemed .AND. IsAppThemed()
         Return TRadioItem_Notify_CustomDraw( Self, lParam, ::Caption, HB_IsObject( ::oBkGrnd ) )
      EndIf
   EndIf

Return ::Super:Events_Notify( wParam, lParam )





EXTERN InitRadioGroup, InitRadioButton

#pragma BEGINDUMP

// #define s_Super s_TLabel

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

#ifndef BST_HOT
   #define BST_HOT        0x0200
#endif

/*
This files are not present in BCC 551
#include <uxtheme.h>
#include <tmschema.h>
*/

typedef struct _MARGINS {
	int cxLeftWidth;
	int cxRightWidth;
	int cyTopHeight;
	int cyBottomHeight;
} MARGINS, *PMARGINS;

typedef HANDLE HTHEME;

enum {
	BP_PUSHBUTTON = 1,
	BP_RADIOBUTTON = 2,
	BP_CHECKBOX = 3,
	BP_GROUPBOX = 4,
	BP_USERBUTTON = 5
};

enum {
	RBS_UNCHECKEDNORMAL = 1,
	RBS_UNCHECKEDHOT = 2,
	RBS_UNCHECKEDPRESSED = 3,
	RBS_UNCHECKEDDISABLED = 4,
	RBS_CHECKEDNORMAL = 5,
	RBS_CHECKEDHOT = 6,
	RBS_CHECKEDPRESSED = 7,
	RBS_CHECKEDDISABLED = 8
};

static WNDPROC lpfnOldWndProcA = 0, lpfnOldWndProcB = 0;

static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcA );
}

static LRESULT APIENTRY SubClassFuncB( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcB );
}

HB_FUNC( INITRADIOGROUP )
{
   HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON | WS_GROUP;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   if( hb_parl( 8 ) )
      Style = Style | BS_LEFTTEXT;

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcA = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFuncA );

   HWNDret( hbutton );
}

HB_FUNC( INITRADIOBUTTON )
{
   HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   if( hb_parl( 8 ) )
      Style = Style | BS_LEFTTEXT;

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcB = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFuncB );

   HWNDret( hbutton );
}

/* http://devel.no-ip.org/programming/static/os/ReactOS-0.3.14/dll/win32/comctl32/theme_button.c */

typedef int (CALLBACK *CALL_OPENTHEMEDATA )( HWND, LPCWSTR );
typedef int (CALLBACK *CALL_DRAWTHEMEBACKGROUND )( HTHEME, HDC, int, int, const RECT*, const RECT* );
typedef int (CALLBACK *CALL_GETTHEMEBACKGROUNDCONTENTRECT )( HTHEME, HDC, int, int, const RECT*, RECT* );
typedef int (CALLBACK *CALL_CLOSETHEMEDATA )( HTHEME );
typedef int (CALLBACK *CALL_DRAWTHEMEPARENTBACKGROUND )( HWND, HDC, RECT* );

int TRadioItem_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bDrawThemeParentBackground )
{
   HMODULE hInstDLL;
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground;
   CALL_OPENTHEMEDATA dwProcOpenThemeData;
   HTHEME hTheme;
   LONG style, state;
   int state_id, checkState, drawState, iNeeded;
   CALL_DRAWTHEMEBACKGROUND dwProcDrawThemeBackground;
   CALL_GETTHEMEBACKGROUNDCONTENTRECT dwProcGetThemeBackgroundContentRect;
   RECT content_rect, aux_rect;
   CALL_CLOSETHEMEDATA dwProcCloseThemeData;
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   static const int rb_states[2][5] =
   {
      { RBS_UNCHECKEDNORMAL, RBS_UNCHECKEDHOT, RBS_UNCHECKEDPRESSED, RBS_UNCHECKEDDISABLED, RBS_UNCHECKEDNORMAL },
      { RBS_CHECKEDNORMAL,   RBS_CHECKEDHOT,   RBS_CHECKEDPRESSED,   RBS_CHECKEDDISABLED,   RBS_CHECKEDNORMAL }
   };

   hInstDLL = LoadLibrary( "UXTHEME.DLL" );
   if( ! hInstDLL )
   {
      return CDRF_DODEFAULT;
   }

   if( bDrawThemeParentBackground & ( pCustomDraw->dwDrawStage == CDDS_PREERASE ) )
   {
      /* erase background (according to parent window's themed background) */
      dwProcDrawThemeParentBackground = (CALL_DRAWTHEMEPARENTBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
      if( ! dwProcDrawThemeParentBackground )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      ( dwProcDrawThemeParentBackground )( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
   }

 	if (pCustomDraw->dwDrawStage == CDDS_PREERASE || pCustomDraw->dwDrawStage == CDDS_PREPAINT)
   {
      /* get theme handle */
      dwProcOpenThemeData = (CALL_OPENTHEMEDATA) GetProcAddress( hInstDLL, "OpenThemeData" );
      if( ! dwProcOpenThemeData )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      hTheme = (HTHEME) ( dwProcOpenThemeData )( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      /* determine state for DrawThemeBackground()
         note: order of these tests is significant */
      style = GetWindowLong( pCustomDraw->hdr.hwndFrom, GWL_STYLE );
      state = SendMessage( pCustomDraw->hdr.hwndFrom, BM_GETSTATE, 0, 0 );

      if( state & BST_CHECKED )
      {
         checkState = 1;
      }
      else
      {
         checkState = 0;
      }

      if( style & WS_DISABLED )
      {
         drawState = 3;
      }
      else if( state & BST_HOT )
      {
         drawState = 1;
      }
      else if( state & BST_FOCUS )
      {
         drawState = 4;
      }
      else if( state & BST_PUSHED )
      {
         drawState = 2;
      }
      else
      {
         drawState = 0;
      }

      state_id = rb_states[checkState][drawState];

      /* get content rectangle */
      dwProcGetThemeBackgroundContentRect = (CALL_GETTHEMEBACKGROUNDCONTENTRECT) GetProcAddress( hInstDLL, "GetThemeBackgroundContentRect" );
      if( ! dwProcGetThemeBackgroundContentRect )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      ( dwProcGetThemeBackgroundContentRect )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &pCustomDraw->rc, &content_rect );

      /* draw themed button background appropriate to control state */
      dwProcDrawThemeBackground = (CALL_DRAWTHEMEBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeBackground" );
      if( ! dwProcDrawThemeBackground )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }
      aux_rect = pCustomDraw->rc;
      aux_rect.top = aux_rect.top + (content_rect.bottom - content_rect.top - 13) / 2;
      aux_rect.bottom = aux_rect.top + 13;
      aux_rect.right = aux_rect.left + 13;
      content_rect.left = aux_rect.right + 6;
      ( dwProcDrawThemeBackground )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &aux_rect, NULL );

      // paint caption
      SetTextColor( pCustomDraw->hdc, ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_BTNTEXT ) : (COLORREF) oSelf->lFontColor );
      DrawText( pCustomDraw->hdc, cCaption, -1, &content_rect, DT_VCENTER | DT_LEFT | DT_SINGLELINE );

      /* paint focus rectangle */
      if( state & BST_FOCUS )
      {
         aux_rect = content_rect;
         iNeeded = DrawText( pCustomDraw->hdc, cCaption, -1, &aux_rect, DT_VCENTER | DT_LEFT | DT_SINGLELINE | DT_CALCRECT );

         aux_rect.left -= 1;
         aux_rect.right += 1;
         aux_rect.top = content_rect.top + ( ( content_rect.bottom - content_rect.top - iNeeded ) / 2 ) + 2;
         aux_rect.bottom = aux_rect.top + iNeeded - 4;

         DrawFocusRect( pCustomDraw->hdc, &aux_rect );
      }

      /* close theme */
      dwProcCloseThemeData = (CALL_CLOSETHEMEDATA) GetProcAddress( hInstDLL, "CloseThemeData" );
      if( dwProcCloseThemeData )
      {
         ( dwProcCloseThemeData )( hTheme );
      }

      FreeLibrary( hInstDLL );

      return CDRF_SKIPDEFAULT;
   }

   return CDRF_SKIPDEFAULT;
}

HB_FUNC( TRADIOITEM_NOTIFY_CUSTOMDRAW)
{
   hb_retni( TRadioItem_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), (LPARAM) hb_parnl( 2 ), (LPCSTR) hb_parc( 3 ), (BOOL) hb_parl( 4 ) ) );
}

#pragma ENDDUMP
