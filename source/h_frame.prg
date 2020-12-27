/*
 * $Id: h_frame.prg $
 */
/*
 * ooHG source code:
 * Frame control
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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
#include "hbclass.ch"

CLASS TFrame FROM TControl

   DATA Type           INIT "FRAME" READONLY
   DATA nWidth         INIT 140
   DATA nHeight        INIT 140
   DATA aExcludeArea   INIT {}

   METHOD Caption      SETGET
   METHOD Define
   METHOD Events
   METHOD ToolTip      SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, y, x, w, h, caption, fontname, ;
               fontsize, opaque, bold, italic, underline, strikeout, ;
               backcolor, fontcolor, transparent, lRtl, invisible, lDisabled, ;
               tooltip, aArea ) CLASS TFrame

   Local ControlHandle, nStyle
   Local oTab

   ASSIGN ::nCol         VALUE x           TYPE "N"
   ASSIGN ::nRow         VALUE y           TYPE "N"
   ASSIGN ::nWidth       VALUE w           TYPE "N"
   ASSIGN ::nHeight      VALUE h           TYPE "N"
   ASSIGN caption        VALUE caption     TYPE "CM" DEFAULT ""
   ASSIGN opaque         VALUE opaque      TYPE "L"  DEFAULT .F.
   ASSIGN transparent    VALUE transparent TYPE "L"  DEFAULT .F.
   ASSIGN ::aExcludeArea VALUE aArea       TYPE "A"

   IF transparent
      IF opaque
         MsgOOHGError( "OPAQUE and TRANSPARENT clauses can't be used simultaneously. Program terminated." )
      ELSE
         ::Transparent := .T.
      ENDIF
   ELSE
      ::Transparent := ! opaque
   ENDIF

   If valtype( caption ) == 'U'
      caption := ""
      fontname := "Arial"
      fontsize := 1
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, , lRtl )

   nStyle := ::InitStyle( ,, Invisible, .T., lDisabled )

   ControlHandle := InitFrame( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, caption, opaque, ::lRtl, nStyle )

   ::Register( ControlHandle, ControlName,,, tooltip )
   ::SetFont( , , bold, italic, underline, strikeout )

   IF _OOHG_LastFrame() == "TABPAGE" .AND. ::IsVisualStyled
      oTab := _OOHG_ActiveFrame
      IF oTab:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   ::Caption := Caption

   Return Self

METHOD Caption( cCaption ) CLASS TFrame

   Local cRet

   // Under XP, when caption is changed, part of the old text remains visible.
   cRet := ::Super:Caption( cCaption )
   If ::lVisible
      ::Visible := .F.
      ::Visible := .T.
   EndIf

   Return cRet

METHOD ToolTip( uToolTip ) CLASS TFrame

   IF PCount() > 0
      TFrame_SetToolTip( Self, ( ValType( uToolTip ) $ "CM" .AND. ! Empty( uToolTip ) ) .OR. HB_ISBLOCK( uToolTip ) )
      ::Super:ToolTip( uToolTip )
   ENDIF

   RETURN ::cToolTip


#pragma BEGINDUMP

#include "oohg.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windowsx.h>

BOOL PtInExcludeArea( PHB_ITEM pArea, int x, int y );

#define s_Super s_TControl

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TFrame_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TFrame_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITFRAME )          /* FUNCTION InitFrame( hWnd, hMenu, nCol, nRow, nWidth, nHeight, cCaption, lOpaque, lLeftAlign, nStyle ) -> hWnd */
{
   HWND hframe;
   int Style, StyleEx;

   Style = hb_parni( 10 ) | WS_CHILD | BS_GROUPBOX | BS_NOTIFY;
   StyleEx = _OOHG_RTL_Status( hb_parl( 9 ) );
   if( ! hb_parl( 8 ) )
      StyleEx = StyleEx | WS_EX_TRANSPARENT;

   hframe = CreateWindowEx( StyleEx, "BUTTON", hb_parc( 7 ), Style,
                            hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                            HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   _OOHG_TFrame_lpfnOldWndProc( SetWindowLongPtr( hframe, GWLP_WNDPROC, (LONG_PTR) SubClassFuncA ) );

   HWNDret( hframe );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TFRAME_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TFrame -> uRetVal */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = (UINT) hb_parni( 2 );
   WPARAM wParam  = WPARAMparam( 3 );
   LPARAM lParam  = LPARAMparam( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf   = _OOHG_GetControlInfo( pSelf );
   POINT pt;
   PHB_ITEM pArea;
   BOOL bPtInExcludeArea;

   switch( message )
   {
      case WM_NCHITTEST:
         _OOHG_Send( pSelf, s_aExcludeArea );
         hb_vmSend( 0 );
         pArea = hb_param( -1, HB_IT_ARRAY );
         pt.x = GET_X_LPARAM( lParam );
         pt.y = GET_Y_LPARAM( lParam );
         MapWindowPoints( HWND_DESKTOP, hWnd, &pt, 1 );
         bPtInExcludeArea = PtInExcludeArea( pArea, pt.x, pt.y );

         if( oSelf->lAux[ 0 ] && ! bPtInExcludeArea )
         {
            hb_retni( HTCLIENT );
         }
         else
         {
            hb_retni( HTTRANSPARENT );
         }
         break;

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TFRAME_SETTOOLTIP )          /* FUNCTION TFrame_SetToolTip( Self, lShow ) -> NIL */
{
   PHB_ITEM pSelf = hb_param( 1, HB_IT_ANY );
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->lAux[ 0 ] = hb_parl( 2 );
   hb_ret();
}

#pragma ENDDUMP
