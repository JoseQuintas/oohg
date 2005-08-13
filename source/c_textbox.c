/*
 * $Id: c_textbox.c,v 1.2 2005-08-13 05:14:45 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C textbox functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
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
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#define ENM_CHANGE	1
#define ENM_KEYEVENTS	65536
#define EM_SETEVENTMASK	1093
#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

static LRESULT APIENTRY SubClassFunc( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam );
extern PHB_ITEM GetControlObjectByHandle( LONG hWnd );

static WNDPROC lpfnOldWndProc = 0;

HB_FUNC( INITTEXTBOX )
{
   HWND hwnd;         // Handle of the parent window/form.
   HWND hedit;        // Handle of the child window/control.
   WNDPROC ll;

   // Get the handle of the parent window/form.
   hwnd = ( HWND ) hb_parnl( 1 );

   // Creates the child control.
   hedit = CreateWindowEx( WS_EX_CLIENTEDGE ,
                           "EDIT",
                           "",
                           ( WS_CHILD | ES_AUTOHSCROLL | hb_parni( 7 ) ),
                           hb_parni( 3 ),
                           hb_parni( 4 ),
                           hb_parni( 5 ),
                           hb_parni( 6 ),
                           hwnd,
                           ( HMENU ) hb_parni( 2 ),
                           GetModuleHandle( NULL ),
                           NULL );

   SendMessage( hedit, ( UINT ) EM_LIMITTEXT, ( WPARAM) hb_parni( 8 ), ( LPARAM ) 0 );

   ll = lpfnOldWndProc;
   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hedit, GWL_WNDPROC, ( LONG ) SubClassFunc );
   if( ll != NULL && ll != lpfnOldWndProc )
   {
      MessageBox( GetActiveWindow(), "cambia!", ".", MB_OK | MB_ICONINFORMATION | MB_SYSTEMMODAL );
   }

   hb_retnl( ( LONG ) hedit );

}

static PHB_DYNS s_Events_Char = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   PHB_ITEM pResult = NULL;

   if( msg == WM_CHAR )
   {
      if( ! s_Events_Char )
      {
         s_Events_Char = hb_dynsymFindName( "EVENTS_CHAR" );
      }

      hb_vmPushSymbol( s_Events_Char->pSymbol );
      hb_vmPush( GetControlObjectByHandle( ( LONG ) hWnd ) );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmSend( 2 );
      pResult = hb_param( -1, HB_IT_NUMERIC );
/*
      BOOL bCtrl     = GetKeyState( VK_CONTROL ) & 0x8000;
      int  iScanCode = HIWORD( lParam ) & 0xFF ;
      int  c = ( int ) wParam;
*/
   }

   if( pResult )
   {
      return hb_itemGetNL( pResult );
   }
   else
   {
      return CallWindowProc( lpfnOldWndProc, hWnd, msg, wParam, lParam );
   }
}

HB_FUNC( SETTEXTEDITREADONLY )
{
	SendMessage( (HWND) hb_parnl (1) , (UINT)EM_SETREADONLY, (WPARAM)hb_parl(2), (LPARAM)0);
}