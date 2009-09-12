/*
 * $Id: h_init.prg,v 1.25 2009-09-12 18:22:13 declan2005 Exp $
 */
/*
 * ooHG source code:
 * Initialization procedure
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

#include "oohg.ch"

#define ABM_CRLF                HB_OsNewLine()

STATIC _OOHG_Messages := { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }

INIT PROCEDURE _OOHG_INIT()

   Public _OOHG_AllVars[ 33 ]

    _OOHG_Main        := nil

   _OOHG_ThisType        := ''
   _OOHG_ThisForm := NIL
   _OOHG_ThisControl := nil
   _OOHG_ThisEventType := ''
   _OOHG_ThisObject := ''

   _OOHG_ExtendedNavigation := .F.

   _OOHG_ThisItemRowIndex  := 0
   _OOHG_ThisItemColIndex  := 0
   _OOHG_ThisItemCellRow      := 0
   _OOHG_ThisItemCellCol      := 0
   _OOHG_ThisItemCellWidth := 0
   _OOHG_ThisItemCellHeight   := 0

   _OOHG_ThisQueryData     := ""
   _OOHG_ThisQueryRowIndex  := 0
   _OOHG_ThisQueryColIndex  := 0

   _OOHG_DefaultFontName         := 'Arial'
   _OOHG_DefaultFontSize         := 9

   _OOHG_TempWindowName       := ""

   _OOHG_ActiveFrame := {}

   _OOHG_THISItemCellValue := Nil

   _OOHG_AutoAdjust := .F.

   _OOHG_AdjustWidth := .T.

   _OOHG_AdjustFont :=  .T.

   _OOHG_SameEnterDblClick :=  .F.

#ifndef __XHARBOUR__
  REQUEST DBFNTX,DBFDBT
  ANNOUNCE HB_GTSYS
#endif

 InitMessages()

Return

*------------------------------------------------------------------------------*
Procedure InitMessages( cLang )
*------------------------------------------------------------------------------*
Local aLang, aLangDefault

   IF VALTYPE( cLang ) $ "CM" .AND. ! EMPTY( cLang )
      // Language specified via parameter
      cLang := UPPER( ALLTRIM( cLang ) )
   ELSE
      // [x]Harbour's default language
      cLang := Set( _SET_LANGUAGE )
   ENDIF

   aLang := _OOHG_MacroCall( "ooHG_Messages_" + cLang + "()" )
   aLangDefault := ooHG_Messages_EN()

   IF VALTYPE( aLang ) != "A"
      aLang := {}
   ENDIF


   _OOHG_Messages[  1 ] := InitMessagesMerge( aLang, aLangDefault,  1 )
   _OOHG_Messages[  2 ] := InitMessagesMerge( aLang, aLangDefault,  2 )
   _OOHG_Messages[  3 ] := InitMessagesMerge( aLang, aLangDefault,  3 )
   _OOHG_Messages[  4 ] := InitMessagesMerge( aLang, aLangDefault,  4 )
   _OOHG_Messages[  5 ] := InitMessagesMerge( aLang, aLangDefault,  5 )
   _OOHG_Messages[  6 ] := InitMessagesMerge( aLang, aLangDefault,  6 )
   _OOHG_Messages[  7 ] := InitMessagesMerge( aLang, aLangDefault,  7 )
   _OOHG_Messages[  8 ] := InitMessagesMerge( aLang, aLangDefault,  8 )
   _OOHG_Messages[  9 ] := InitMessagesMerge( aLang, aLangDefault,  9 )
   _OOHG_Messages[ 10 ] := InitMessagesMerge( aLang, aLangDefault, 10 )
   _OOHG_Messages[ 11 ] := InitMessagesMerge( aLang, aLangDefault, 11 )

Return

FUNCTION _OOHG_Messages( nTable, nItem )
RETURN IF( ( VALTYPE( nTable ) == "N" .AND. nTable >= 1 .AND. nTable <= LEN( _OOHG_Messages ) .AND. ;
             VALTYPE( nItem ) == "N" .AND. nItem >= 1 .AND. nItem <= LEN( _OOHG_Messages[ nTable] ) ), ;
             _OOHG_Messages[ nTable ][ nItem ], "" )

STATIC FUNCTION InitMessagesMerge( aLang, aLangDefault, nTable )
Local aReturn
   aReturn := ACLONE( aLangDefault[ nTable ] )
   IF LEN( aLang ) >= nTable .AND. VALTYPE( aLang[ nTable ] ) == "A"
      AEVAL( aReturn, { |c,i| IF( LEN( aLang[ nTable ] ) >= i .AND. VALTYPE( aLang[ nTable ][ i ] ) $ "CM" , aReturn[ i ] := aLang[ nTable ][ i ] , c ) } )
   ENDIF
RETURN aReturn

FUNCTION ooHG_Messages_EN // English (default)
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Are you sure ?'           ,;
               'Close Window'             ,;
               'Close not allowed'        ,;
               'Program Already Running'  ,;
               'Edit'                     ,;
               'Ok'                       ,;
               'Cancel'                   ,;
               'Pag.'                      }

   // BROWSE MESSAGES
   acBrowseButton := { "Append"   ,;
                       "Edit"     ,;
                       "&Cancel"  ,;
                       "&OK"       }
   acBrowseError := { "Window: "                                              ,;
                      " is not defined. Program terminated"                   ,;
                      "MiniGUI Error"                                         ,;
                      "Control: "                                             ,;
                      " Of "                                                  ,;
                      " Already defined. Program Terminated"                  ,;
                      "Browse: Type Not Allowed. Program terminated"          ,;
                      "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program Terminated",;
                      "Record Is Being Edited By Another User"                ,;
                      "Warning"                                               ,;
                      "Invalid Entry"                                          }
   acBrowseMessages := { 'Are you sure ?' , 'Delete Record' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Delete record"+Chr(13)+"Are you sure ?"+Chr(13)                  ,;
                  Chr(13)+"Index file missing"+Chr(13)+"Can't do search"+Chr(13)            ,;
                  Chr(13)+"Can't find index field"+Chr(13)+"Can't do search"+Chr(13)        ,;
                  Chr(13)+"Can't do search by"+Chr(13)+"fields memo or logic"+Chr(13)       ,;
                  Chr(13)+"Record not found"+Chr(13)                                        ,;
                  Chr(13)+"Too many cols"+Chr(13)+"The report can't fit in the sheet"+Chr(13) }
   acABMLabel := { "Record"              ,;
                   "Record count"        ,;
                   "       (New)"        ,;
                   "      (Edit)"        ,;
                   "Enter record number" ,;
                   "Find"                ,;
                   "Search text"         ,;
                   "Search date"         ,;
                   "Search number"       ,;
                   "Report definition"   ,;
                   "Report columns"      ,;
                   "Available columns"   ,;
                   "Initial record"      ,;
                   "Final record"        ,;
                   "Report of "          ,;
                   "Date:"               ,;
                   "Initial record:"     ,;
                   "Final record:"       ,;
                   "Ordered by:"         ,;
                   "Yes"                 ,;
                   "No"                  ,;
                   "Page "               ,;
                   " of "                 }
   acABMButton := { "Close"    ,;
                    "New"      ,;
                    "Edit"     ,;
                    "Delete"   ,;
                    "Find"     ,;
                    "Goto"     ,;
                    "Report"   ,;
                    "First"    ,;
                    "Previous" ,;
                    "Next"     ,;
                    "Last"     ,;
                    "Save"     ,;
                    "Cancel"   ,;
                    "Add"      ,;
                    "Remove"   ,;
                    "Print"    ,;
                    "Close"     }
   acABMError := { "EDIT, workarea name missing"                              ,;
                   "EDIT, this workarea has more than 16 fields"              ,;
                   "EDIT, refresh mode out of range (please report bug)"      ,;
                   "EDIT, main event number out of range (please report bug)" ,;
                   "EDIT, list event number out of range (please report bug)"  }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Close",            ; // 1
                "&New",              ; // 2
                "&Modify",           ; // 3
                "&Delete",           ; // 4
                "&Find",             ; // 5
                "&Print",            ; // 6
                "&Cancel",           ; // 7
                "&Ok",               ; // 8
                "&Copy",             ; // 9
                "&Activate Filter",  ; // 10
                "&Deactivate Filter" } // 11
   acLabel := { "None",                         ; // 1
                "Record",                       ; // 2
                "Total",                        ; // 3
                "Active order",                 ; // 4
                "Options",                      ; // 5
                "New record",                   ; // 6
                "Modify record",                ; // 7
                "Select record",                ; // 8
                "Find record",                  ; // 9
                "Print options",                ; // 10
                "Available fields",             ; // 11
                "Fields to print",              ; // 12
                "Available printers",           ; // 13
                "First record to print",        ; // 14
                "Last record to print",         ; // 15
                "Delete record",                ; // 16
                "Preview",                      ; // 17
                "View page thumbnails",         ; // 18
                "Filter Condition: ",           ; // 19
                "Filtered: ",                   ; // 20
                "Filtering Options" ,           ; // 21
                "Database Fields" ,             ; // 22
                "Comparission Operator",        ; // 23
                "Filter Value",                 ; // 24
                "Select Field To Filter",       ; // 25
                "Select Comparission Operator", ; // 26
                "Equal",                        ; // 27
                "Not Equal",                    ; // 28
                "Greater Than",                 ; // 29
                "Lower Than",                   ; // 30
                "Greater or Equal Than",        ; // 31
                "Lower or Equal Than"           } // 32
   acUser := { ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,       ; // 1
               "Type the field value (any text)",                                                                                      ; // 2
               "Type the field value (any number)",                                                                                    ; // 3
               "Select the date",                                                                                                      ; // 4
               "Check for true value",                                                                                                 ; // 5
               "Enter the field value",                                                                                                ; // 6
               "Select any record and press OK",                                                                                       ; // 7
               ABM_CRLF + "You are going to delete the active record   " + ABM_CRLF + "Are you sure?    " + ABM_CRLF,                  ; // 8
               ABM_CRLF + "There isn't any active order   " + ABM_CRLF + "Please select one   " + ABM_CRLF,                            ; // 9
               ABM_CRLF + "Can't do searches by fields memo or logic   " + ABM_CRLF,                                                   ; // 10
               ABM_CRLF + "Record not found   " + ABM_CRLF,                                                                            ; // 11
               "Select the field to include to list",                                                                                  ; // 12
               "Select the field to exclude from list",                                                                                ; // 13
               "Select the printer",                                                                                                   ; // 14
               "Push button to include field",                                                                                         ; // 15
               "Push button to exclude field",                                                                                         ; // 16
               "Push button to select the first record to print",                                                                      ; // 17
               "Push button to select the last record to print",                                                                       ; // 18
               ABM_CRLF + "No more fields to include   " + ABM_CRLF,                                                                   ; // 19
               ABM_CRLF + "First select the field to include   " + ABM_CRLF,                                                           ; // 20
               ABM_CRLF + "No more fields to exlude   " + ABM_CRLF,                                                                    ; // 21
               ABM_CRLF + "First select th field to exclude   " + ABM_CRLF,                                                            ; // 22
               ABM_CRLF + "You don't select any field   " + ABM_CRLF + "Please select the fields to include on print   " + ABM_CRLF,   ; // 23
               ABM_CRLF + "Too many fields   " + ABM_CRLF + "Reduce number of fields   " + ABM_CRLF,                                   ; // 24
               ABM_CRLF + "Printer not ready   " + ABM_CRLF,                                                                           ; // 25
               "Ordered by",                                                                                                           ; // 26
               "From record",                                                                                                          ; // 27
               "To record",                                                                                                            ; // 28
               "Yes",                                                                                                                  ; // 29
               "No",                                                                                                                   ; // 30
               "Page:",                                                                                                                ; // 31
               ABM_CRLF + "Please select a printer   " + ABM_CRLF,                                                                     ; // 32
               "Filtered by",                                                                                                          ; // 33
               ABM_CRLF + "There is an active filter    " + ABM_CRLF,                                                                  ; // 34
               ABM_CRLF + "Can't filter by memo fields    " + ABM_CRLF,                                                                ; // 35
               ABM_CRLF + "Select the field to filter    " + ABM_CRLF,                                                                 ; // 36
               ABM_CRLF + "Select any operator to filter    " + ABM_CRLF,                                                              ; // 37
               ABM_CRLF + "Type any value to filter    " + ABM_CRLF,                                                                   ; // 38
               ABM_CRLF + "There isn't any active filter    " + ABM_CRLF,                                                              ; // 39
               ABM_CRLF + "Deactivate filter?   " + ABM_CRLF,                                                                          ; // 40
               ABM_CRLF + "Record locked by another user    " + ABM_CRLF                                                               } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// CROATIAN
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_HR852 // Croatian
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Are you sure ?'              ,;
               'Zatvori prozor'              ,;
               'Zatvaranje nije dozvoljeno'  ,;
               'Program je ve� pokrenut'     ,;
               'Uredi'                       ,;
               'U redu'                      ,;
               'Prekid'                      ,;
               'Pag.'                         }

   // BROWSE MESSAGES
   acBrowseButton := {}
   acBrowseError := {}
   acBrowseMessages := {}

   // EDIT MESSAGES
   acABMUser := {}
   acABMLabel := {}
   acABMButton := {}
   acABMError := {}

   // EDIT EXTENDED MESSAGES
   acButton:= {}
   acLabel := {}
   acUser := {}

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// BASQUE
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_EU // Basque
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := {}

   // BROWSE MESSAGES
   acBrowseButton := {}
   acBrowseError := {}
   acBrowseMessages := {}

   // EDIT MESSAGES
   acABMUser := {}
   acABMLabel := {}
   acABMButton := {}
   acABMError := {}

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Itxi",             ; // 1
                "&Berria",           ; // 2
                "&Aldatu",           ; // 3
                "&Ezabatu",          ; // 4
                "Bi&latu",           ; // 5
                "In&primatu",        ; // 6
                "&Utzi",             ; // 7
                "&Ok",               ; // 8
                "&Kopiatu",          ; // 9
                "I&ragazkia Ezarri", ; // 10
                "Ira&gazkia Kendu"   } // 11
   acLabel := { "Bat ere ez",                         ; // 1
                "Erregistroa",                        ; // 2
                "Guztira",                            ; // 3
                "Orden Aktiboa",                      ; // 4
                "Aukerak",                            ; // 5
                "Erregistro Berria",                  ; // 6
                "Erregistroa Aldatu",                 ; // 7
                "Erregistroa Aukeratu",               ; // 8
                "Erregistroa Bilatu",                 ; // 9
                "Inprimatze-aukerak",                 ; // 10
                "Eremu Libreak",                      ; // 11
                "Inprimatzeko Eremuak",               ; // 12
                "Inprimagailu Libreak",               ; // 13
                "Inprimatzeko Lehenengo Erregistroa", ; // 14
                "Inprimatzeko Azken Erregistroa",     ; // 15
                "Erregistroa Ezabatu",                ; // 16
                "Aurreikusi",                         ; // 17
                "Orrien Irudi Txikiak Ikusi",         ; // 18
                "Iragazkiaren Baldintza: ",           ; // 19
                "Iragazita: ",                        ; // 20
                "Iragazte-aukerak" ,                  ; // 21
                "Datubasearen Eremuak" ,              ; // 22
                "Konparaketa Eragilea",               ; // 23
                "Iragazkiaren Balioa",                ; // 24
                "Iragazteko Eremua Aukeratu",         ; // 25
                "Konparaketa Eragilea Aukeratu",      ; // 26
                "Berdin",                             ; // 27
                "Ezberdin",                           ; // 28
                "Handiago",                           ; // 29
                "Txikiago",                           ; // 30
                "Handiago edo Berdin",                ; // 31
                "Txikiago edo Berdin"                 } // 32
   acUser := { ABM_CRLF + "Ezin da area aktiborik aurkitu.   "  + ABM_CRLF + "Mesedez aukeratu area EDIT deitu baino lehen   " + ABM_CRLF,  ; // 1
               "Eremuaren balioa idatzi (edozein testu)",                                                                                   ; // 2
               "Eremuaren balioa idatzi (edozein zenbaki)",                                                                                 ; // 3
               "Data aukeratu",                                                                                                             ; // 4
               "Markatu egiazko baliorako",                                                                                                 ; // 5
               "Eremuaren balioa sartu",                                                                                                    ; // 6
               "Edozein erregistro aukeratu eta OK sakatu",                                                                                 ; // 7
               ABM_CRLF + "Erregistro aktiboa ezabatuko duzu   " + ABM_CRLF + "Ziur zaude?    " + ABM_CRLF,                                 ; // 8
               ABM_CRLF + "Ez dago orden aktiborik   " + ABM_CRLF + "Mesedez aukeratu bat   " + ABM_CRLF,                                   ; // 9
               ABM_CRLF + "Memo edo eremu logikoen arabera ezin bilaketarik egin   " + ABM_CRLF,                                            ; // 10
               ABM_CRLF + "Erregistroa ez da aurkitu   " + ABM_CRLF,                                                                        ; // 11
               "Zerrendan sartzeko eremua aukeratu",                                                                                        ; // 12
               "Zerrendatik kentzeko eremua aukeratu",                                                                                      ; // 13
               "Inprimagailua aukeratu",                                                                                                    ; // 14
               "Sakatu botoia eremua sartzeko",                                                                                             ; // 15
               "Sakatu botoia eremua kentzeko",                                                                                             ; // 16
               "Sakatu botoia inprimatzeko lehenengo erregistroa aukeratzeko",                                                              ; // 17
               "Sakatu botoia inprimatzeko azken erregistroa aukeratzeko",                                                                  ; // 18
               ABM_CRLF + "Sartzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 19
               ABM_CRLF + "Lehenago aukeratu sartzeko eremua   " + ABM_CRLF,                                                                ; // 20
               ABM_CRLF + "Kentzeko eremu gehiagorik ez   " + ABM_CRLF,                                                                     ; // 21
               ABM_CRLF + "Lehenago aukeratu kentzeko eremua   " + ABM_CRLF,                                                                ; // 22
               ABM_CRLF + "Ez duzu eremurik aukeratu  " + ABM_CRLF + "Mesedez aukeratu inprimaketan sartzeko eremuak   " + ABM_CRLF,        ; // 23
               ABM_CRLF + "Eremu gehiegi   " + ABM_CRLF + "Murriztu eremu kopurua   " + ABM_CRLF,                                           ; // 24
               ABM_CRLF + "Inprimagailua ez dago prest   " + ABM_CRLF,                                                                      ; // 25
               "Ordenatuta honen arabera:",                                                                                                 ; // 26
               "Erregistro honetatik:",                                                                                                     ; // 27
               "Erregistro honetara:",                                                                                                      ; // 28
               "Bai",                                                                                                                       ; // 29
               "Ez",                                                                                                                        ; // 30
               "Orrialdea:",                                                                                                                ; // 31
               ABM_CRLF + "Mesedez aukeratu inprimagailua   " + ABM_CRLF,                                                                   ; // 32
               "Iragazita honen arabera:",                                                                                                  ; // 33
               ABM_CRLF + "Iragazki aktiboa dago    " + ABM_CRLF,                                                                           ; // 34
               ABM_CRLF + "Ezin iragazi Memo eremuen arabera    " + ABM_CRLF,                                                               ; // 35
               ABM_CRLF + "Iragazteko eremua aukeratu    " + ABM_CRLF,                                                                      ; // 36
               ABM_CRLF + "Iragazteko edozein eragile aukeratu    " + ABM_CRLF,                                                             ; // 37
               ABM_CRLF + "Idatzi edozein balio iragazteko    " + ABM_CRLF,                                                                 ; // 38
               ABM_CRLF + "Ez dago iragazki aktiborik    " + ABM_CRLF,                                                                      ; // 39
               ABM_CRLF + "Iragazkia kendu?   " + ABM_CRLF,                                                                                  ; // 40
               ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// FRENCH
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_FR // French
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Etes-vous s�re ?'       ,;
               'Fermer la fen�tre'      ,;
               'Fermeture interdite'    ,;
               'Programme d�j� activ�'  ,;
               'Editer'                 ,;
               'Ok'                     ,;
               'Abandonner'             ,;
               'Pag.'                    }

   // BROWSE MESSAGES
   acBrowseButton := { "Ajout"         ,;
                       "Modification"  ,;
                       "Annuler"       ,;
                       "OK"             }
   acBrowseError := { "Fen�tre: "                                             ,;
                      " n'est pas d�finie. Programme termin�"                 ,;
                      "Erreur MiniGUI"                                        ,;
                      "Contr�le: "                                            ,;
                      " De "                                                  ,;
                      " D�j� d�fini. Programme termin�"                       ,;
                      "Modification: Type non autoris�. Programme termin�"    ,;
                      "Modification: La clause Ajout ne peut �tre utilis�e avec des champs n'appartenant pas � la zone de travail de Modification. Programme termin�",;
                      "L'enregistrement est utilis� par un autre utilisateur" ,;
                      "Erreur"                                                ,;
                      "Entr�e invalide"                                        }
   acBrowseMessages := { 'Etes-vous s�re ?' , 'Enregistrement d�truit' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Suppression d'enregistrement"+Chr(13)+"Etes-vous s�re ?"+Chr(13)    ,;
                  Chr(13)+"Index manquant"+Chr(13)+"Recherche impossible"+Chr(13)              ,;
                  Chr(13)+"Champ Index introuvable"+Chr(13)+"Recherche impossible"+Chr(13)     ,;
                  Chr(13)+"Recherche impossible"+Chr(13)+"sur champs memo ou logique"+Chr(13)  ,;
                  Chr(13)+"Enregistrement non trouv�"+Chr(13)                                  ,;
                  Chr(13)+"Trop de colonnes"+Chr(13)+"L'�tat ne peut �tre imprim�"+Chr(13)      }
   acABMLabel := { "Enregistrement"                       ,;
                   "Nb. total enr."                       ,;
                   "   (Ajouter)"                         ,;
                   "  (Modifier)"                         ,;
                   "Entrez le num�ro de l'enregistrement" ,;
                   "Trouver"                              ,;
                   "Chercher texte"                       ,;
                   "Chercher date"                        ,;
                   "Chercher num�ro"                      ,;
                   "D�finition de l'�tat"                 ,;
                   "Colonnes de l'�tat"                   ,;
                   "Colonnes disponibles"                 ,;
                   "Enregistrement de d�but"              ,;
                   "Enregistrement de fin"                ,;
                   "Etat de "                             ,;
                   "Date:"                                ,;
                   "Enregistrement de d�but:"             ,;
                   "Enregistrement de fin:"               ,;
                   "Tri� par:"                            ,;
                   "Oui"                                  ,;
                   "Non"                                  ,;
                   " Page"                                ,;
                   " de "                                  }
   acABMButton := { "Fermer"      ,;
                    "Nouveau"     ,;
                    "Modifier"    ,;
                    "Supprimer"   ,;
                    "Trouver"     ,;
                    "Aller �"     ,;
                    "Etat"   ,;
                    "Premier"     ,;
                    "Pr�c�dent"   ,;
                    "Suivant"     ,;
                    "Dernier"     ,;
                    "Enregistrer" ,;
                    "Annuler"     ,;
                    "Ajouter"     ,;
                    "Retirer"     ,;
                    "Imprimer"    ,;
                    "Fermer"      }
   acABMError := { "EDIT, nom de la table manquant"                                         ,;
                   "EDIT, la table a plus de 16 champs"                                     ,;
                   "EDIT, mode rafraichissement hors limite (Rapport d'erreur merci)"       ,;
                   "EDIT, �v�nement principal nombre hors limite (Rapport d'erreur merci)"  ,;
                   "EDIT, liste d'�v�nements nombre hors limite (Rapport d'erreur merci)"   }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Fermer",          ; // 1
                "&Nouveau",         ; // 2
                "&Modifier",        ; // 3
                "&Supprimer",       ; // 4
                "&Trouver",         ; // 5
                "&Imprimer",        ; // 6
                "&Abandon",         ; // 7
                "&Ok",              ; // 8
                "&Copier",          ; // 9
                "&Activer Filtre",  ; // 10
                "&D�activer Filtre" } // 11
   acLabel := { "Aucun",                                   ; // 1
                "Enregistrement",                          ; // 2
                "Total",                                   ; // 3
                "Ordre actif",                             ; // 4
                "Options",                                 ; // 5
                "Nouvel enregistrement",                   ; // 6
                "Modifier enregistrement",                 ; // 7
                "Selectionner enregistrement",             ; // 8
                "Trouver enregistrement",                  ; // 9
                "Imprimer options",                        ; // 10
                "Champs disponibles",                      ; // 11
                "Champs � imprimer",                       ; // 12
                "Imprimantes connect�es",                  ; // 13
                "Premier enregistrement � imprimer",       ; // 14
                "Dernier enregistrement � imprimer",       ; // 15
                "Enregistrement supprim�",                 ; // 16
                "Pr�visualisation",                        ; // 17
                "Aper�u pages",                            ; // 18
                "Condition filtre : ",                     ; // 19
                "Filtr� : ",                               ; // 20
                "Options de filtrage" ,                    ; // 21
                "Champs de la Bdd" ,                       ; // 22
                "Op�rateurs de comparaison",               ; // 23
                "Valeur du filtre",                        ; // 24
                "Selectionner le champ � filtrer",         ; // 25
                "Selectionner l'op�rateur de comparaison", ; // 26
                "Egal",                                    ; // 27
                "Diff�rent",                               ; // 28
                "Plus grand",                              ; // 29
                "Plus petit",                              ; // 30
                "Plus grand ou �gal",                      ; // 31
                "Plus petit ou �gal"                       } // 32
   acUser := { ABM_CRLF + "Ne peut trouver une base active.   "  + ABM_CRLF + "S�lectionner une base avant la fonction EDIT  " + ABM_CRLF,           ; // 1
               "Entrer la valeur du champ (du texte)",                                                                                               ; // 2
               "Entrer la valeur du champ (un nombre)",                                                                                              ; // 3
               "S�lectionner la date",                                                                                                               ; // 4
               "V�rifier la valeur logique",                                                                                                         ; // 5
               "Entrer la valeur du champ",                                                                                                          ; // 6
               "S�lectionner un enregistrement et appuyer sur OK",                                                                                   ; // 7
               ABM_CRLF + "Vous voulez d�truire l'enregistrement actif  " + ABM_CRLF + "Etes-vous s�re?   " + ABM_CRLF,                              ; // 8
               ABM_CRLF + "Il n'y a pas d'ordre actif   " + ABM_CRLF + "S�lectionner en un   " + ABM_CRLF,                                           ; // 9
               ABM_CRLF + "Ne peut faire de recherche sur champ memo ou logique   " + ABM_CRLF,                                                      ; // 10
               ABM_CRLF + "Enregistrement non trouv�  " + ABM_CRLF,                                                                                  ; // 11
               "S�lectionner le champ � inclure � la liste",                                                                                         ; // 12
               "S�lectionner le champ � exclure de la liste",                                                                                        ; // 13
               "S�lectionner l'imprimante",                                                                                                          ; // 14
               "Appuyer sur le bouton pour inclure un champ",                                                                                        ; // 15
               "Appuyer sur le bouton pour exclure un champ",                                                                                        ; // 16
               "Appuyer sur le bouton pour s�lectionner le premier enregistrement � imprimer",                                                       ; // 17
               "Appuyer sur le bouton pour s�lectionner le dernier champ � imprimer",                                                                ; // 18
               ABM_CRLF + "Plus de champs � inclure   " + ABM_CRLF,                                                                                  ; // 19
               ABM_CRLF + "S�lectionner d'abord les champs � inclure   " + ABM_CRLF,                                                                 ; // 20
               ABM_CRLF + "Plus de champs � exclure   " + ABM_CRLF,                                                                                  ; // 21
               ABM_CRLF + "S�lectionner d'abord les champs � exclure   " + ABM_CRLF,                                                                 ; // 22
               ABM_CRLF + "Vous n'avez s�lectionn� aucun champ   " + ABM_CRLF + "S�lectionner les champs � inclure dans l'impression   " + ABM_CRLF, ; // 23
               ABM_CRLF + "Trop de champs   " + ABM_CRLF + "R�duiser le nombre de champs   " + ABM_CRLF,                                             ; // 24
               ABM_CRLF + "Imprimante pas pr�te   " + ABM_CRLF,                                                                                      ; // 25
               "Tri� par",                                                                                                                           ; // 26
               "De l'enregistrement",                                                                                                                ; // 27
               "A l'enregistrement",                                                                                                                 ; // 28
               "Oui",                                                                                                                                ; // 29
               "Non",                                                                                                                                ; // 30
               "Page:",                                                                                                                              ; // 31
               ABM_CRLF + "S�lectionner une imprimante   " + ABM_CRLF,                                                                               ; // 32
               "Filtr� par",                                                                                                                         ; // 33
               ABM_CRLF + "Il y a un filtre actif    " + ABM_CRLF,                                                                                   ; // 34
               ABM_CRLF + "Filtre impossible sur champ memo    " + ABM_CRLF,                                                                         ; // 35
               ABM_CRLF + "S�lectionner un champ de filtre    " + ABM_CRLF,                                                                          ; // 36
               ABM_CRLF + "S�lectionner un op�rateur de filtre   " + ABM_CRLF,                                                                       ; // 37
               ABM_CRLF + "Entrer une valeur au filtre    " + ABM_CRLF,                                                                              ; // 38
               ABM_CRLF + "Il n'y a aucun filtre actif    " + ABM_CRLF,                                                                              ; // 39
               ABM_CRLF + "D�sactiver le filtre?   " + ABM_CRLF,                                                                                     ; // 40
               ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                                 } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// GERMAN
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_DE // German
RETURN ooHG_Messages_DEWIN()

FUNCTION ooHG_Messages_DEWIN // German
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Sind Sie sicher ?'        ,;
               'Fenster schlie�en'        ,;
               'Schlie�en nicht erlaubt'  ,;
               'Programm l�uft bereits'   ,;
               'Bearbeiten'               ,;
               'OK'                       ,;
               'Abbrechen'                ,;
               'Seite'                     }

   // BROWSE MESSAGES
   acBrowseButton := {}
   acBrowseError := {}
   acBrowseMessages := { 'Sind Sie sicher ?' , 'Datensatz l�schen' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Datensatz loeschen"+Chr(13)+"Sind Sie sicher ?"+Chr(13)                   ,;
                  Chr(13)+" Falscher Indexdatensatz"+Chr(13)+"Suche unmoeglich"+Chr(13)              ,;
                  Chr(13)+"Man kann nicht Indexdatenfeld finden"+Chr(13)+"Suche unmoeglich"+Chr(13)  ,;
                  Chr(13)+"Suche unmoeglich nach"+Chr(13)+"Feld memo oder logisch"+Chr(13)           ,;
                  Chr(13)+"Datensatz nicht gefunden"+Chr(13)                                         ,;
                  Chr(13)+" zu viele Spalten"+Chr(13)+"Zu wenig Platz  fuer die Meldung auf dem Blatt" + Chr(13) }
   acABMLabel := { "Datensatz"              ,;
                   "Menge der Dat."        ,;
                   "       (Neu)"        ,;
                   " (Editieren)"        ,;
                   "Datensatznummer eintragen" ,;
                   "Suche"                ,;
                   "Suche Text"         ,;
                   "Suche Datum"         ,;
                   "Suche Zahl"       ,;
                   "Definition der Meldung"   ,;
                   "Spalten der Meldung"      ,;
                   "Zugaengliche Spalten"     ,;
                   "Anfangsdatensatz"      ,;
                   "Endedatensatz"        ,;
                   "Datensatz vom "          ,;
                   "Datum:"               ,;
                   "Anfangsdatensatz:"     ,;
                   "Endedatensatz:"       ,;
                   "Sortieren nach:"         ,;
                   "Ja"                 ,;
                   "Nein"                  ,;
                   "Seite "               ,;
                   " von "                 }
   acABMButton := { "Schliesse"    ,;
                    "Neu"      ,;
                    "Editiere"     ,;
                    "Loesche"   ,;
                    "Finde"     ,;
                    "Gehe zu"     ,;
                    "Meldung"   ,;
                    "Erster"    ,;
                    "Zurueck" ,;
                    "Naechst"     ,;
                    "Letzter"     ,;
                    "Speichern"     ,;
                    "Aufheben"   ,;
                    "Hinzufuegen"      ,;
                    "Loeschen"   ,;
                    "Drucken"    ,;
                    "Schliessen"     }
   acABMError := { "EDIT, falscher Name von Datenbank"                                  ,;
                   "EDIT, Datenbank hat mehr als 16 Felder"                   ,;
                   "EDIT, Auffrische-Modus ausser dem Bereich (siehe Fehlermeldungen)"      ,;
                   "EDIT, Menge der Basisereignisse ausser dem Bereich (siehe Fehlermeldungen)" ,;
                   "EDIT, Liste der Ereignisse ausser dem Bereich (siehe Fehlermeldungen)"  }

   // EDIT EXTENDED MESSAGES
   acButton:= { "S&chlie�en",          ; // 1
                "&Neu",                ; // 2
                "&Bearbeiten",         ; // 3
                "&L�schen",            ; // 4
                "&Suchen",             ; // 5
                "&Drucken",            ; // 6
                "&Abbruch",            ; // 7
                "&Ok",                 ; // 8
                "&Kopieren",           ; // 9
                "&Filter aktivieren",  ; // 10
                "&Filter deaktivieren" } // 11
   acLabel := { "Keine",                                         ; // 1
                "Datensatz",                                     ; // 2
                "Gesamt",                                        ; // 3
                "Aktive Sortierung",                             ; // 4
                "Einstellungen",                                 ; // 5
                "Neuer Datensatz",                               ; // 6
                "Datensatz bearbeiten",                          ; // 7
                "Datensatz ausw�hlen",                           ; // 8
                "Datensatz finden",                              ; // 9
                "Druckeinstellungen",                            ; // 10
                "Verf�gbare Felder",                             ; // 11
                "Zu druckende Felder",                           ; // 12
                "Verf�gbare Drucker",                            ; // 13
                "Erster zu druckender Datensatz",                ; // 14
                "Letzter zu druckender Datensatz",               ; // 15
                "Datensatz l�schen",                             ; // 16
                "Vorschau",                                      ; // 17
                "�bersicht",                                     ; // 18
                "Filterbedingung: ",                             ; // 19
                "Gefiltert: ",                                   ; // 20
                "Filter-Einstellungen" ,                         ; // 21
                "Datenbank-Felder" ,                             ; // 22
                "Vergleichs-Operator",                           ; // 23
                "Filterwert",                                    ; // 24
                "Zu filterndes Feld ausw�hlen",                  ; // 25
                "Vergleichs-Operator ausw�hlen",                 ; // 26
                "Gleich",                                        ; // 27
                "Ungleich",                                      ; // 28
                "Gr��er als",                                    ; // 29
                "Kleiner als",                                   ; // 30
                "Gr��er oder gleich als",                        ; // 31
                "Kleiner oder gleich als"                        } // 32
   acUser := { ABM_CRLF + "Kein aktiver Arbeitsbereich gefunden.   "  + ABM_CRLF + "Bitte einen Arbeitsbereich ausw�hlen vor dem Aufruf von EDIT   " + ABM_CRLF,       ; // 1
               "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 2
               "Eine Zahl eingeben",                                                                                                                                   ; // 3
               "Datum ausw�hlen",                                                                                                                                      ; // 4
               "F�r positive Auswahl einen Haken setzen",                                                                                                              ; // 5
               "Einen Text eingeben (alphanumerisch)",                                                                                                                 ; // 6
               "Einen Datensatz w�hlen und mit OK best�tigen",                                                                                                         ; // 7
               ABM_CRLF + "Sie sind im Begriff, den aktiven Datensatz zu l�schen.   " + ABM_CRLF + "Sind Sie sicher?    " + ABM_CRLF,                                  ; // 8
               ABM_CRLF + "Es ist keine Sortierung aktiv.   " + ABM_CRLF + "Bitte w�hlen Sie eine Sortierung   " + ABM_CRLF,                                           ; // 9
               ABM_CRLF + "Suche nach den Feldern memo oder logisch nicht m�glich.   " + ABM_CRLF,                                                                     ; // 10
               ABM_CRLF + "Datensatz nicht gefunden   " + ABM_CRLF,                                                                                                    ; // 11
               "Bitte ein Feld zum Hinzuf�gen zur Liste w�hlen",                                                                                                       ; // 12
               "Bitte ein Feld zum Entfernen aus der Liste w�hlen ",                                                                                                   ; // 13
               "Drucker ausw�hlen",                                                                                                                                    ; // 14
               "Schaltfl�che  Feld hinzuf�gen",                                                                                                                        ; // 15
               "Schaltfl�che  Feld Entfernen",                                                                                                                         ; // 16
               "Schaltfl�che  Auswahl erster zu druckender Datensatz",                                                                                                 ; // 17
               "Schaltfl�che  Auswahl letzte zu druckender Datensatz",                                                                                                 ; // 18
               ABM_CRLF + "Keine Felder zum Hinzuf�gen mehr vorhanden   " + ABM_CRLF,                                                                                  ; // 19
               ABM_CRLF + "Bitte erst ein Feld zum Hinzuf�gen w�hlen   " + ABM_CRLF,                                                                                   ; // 20
               ABM_CRLF + "Keine Felder zum Entfernen vorhanden   " + ABM_CRLF,                                                                                        ; // 21
               ABM_CRLF + "Bitte ein Feld zum Entfernen w�hlen   " + ABM_CRLF,                                                                                         ; // 22
               ABM_CRLF + "Kein Feld ausgew�hlt   " + ABM_CRLF + "Bitte die Felder f�r den Ausdruck ausw�hlen   " + ABM_CRLF,                                          ; // 23
               ABM_CRLF + "Zu viele Felder   " + ABM_CRLF + "Bitte Anzahl der Felder reduzieren   " + ABM_CRLF,                                                        ; // 24
               ABM_CRLF + "Drucker nicht bereit   " + ABM_CRLF,                                                                                                        ; // 25
               "Sortiert nach",                                                                                                                                        ; // 26
               "Von Datensatz",                                                                                                                                        ; // 27
               "Bis Datensatz",                                                                                                                                        ; // 28
               "Ja",                                                                                                                                                   ; // 29
               "Nein",                                                                                                                                                 ; // 30
               "Seite:",                                                                                                                                               ; // 31
               ABM_CRLF + "Bitte einen Drucker w�hlen   " + ABM_CRLF,                                                                                                  ; // 32
               "Filtered by",                                                                                                                                          ; // 33
               ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 34
               ABM_CRLF + "Kann nicht nach Memo-Feldern filtern    " + ABM_CRLF,                                                                                       ; // 35
               ABM_CRLF + "Feld zum Filtern ausw�hlen    " + ABM_CRLF,                                                                                                 ; // 36
               ABM_CRLF + "Einen Operator zum Filtern ausw�hlen    " + ABM_CRLF,                                                                                       ; // 37
               ABM_CRLF + "Bitte einen Wert f�r den Filter angeben    " + ABM_CRLF,                                                                                    ; // 38
               ABM_CRLF + "Es ist kein aktiver Filter vorhanden    " + ABM_CRLF,                                                                                       ; // 39
               ABM_CRLF + "Filter deaktivieren?   " + ABM_CRLF,                                                                                                         ; // 40
               ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                   } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// ITALIAN
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_IT // Italian
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Sei sicuro ?'                      ,;
               'Chiudi la finestra'                ,;
               'Chiusura non consentita'           ,;
               'Il programma � gi� in esecuzione'  ,;
               'Edita'                             ,;
               'Conferma'                          ,;
               'Annulla'                           ,;
               'Pag.'                               }

   // BROWSE MESSAGES
   acBrowseButton := { "Aggiungere"  ,;
                       "Modificare"  ,;
                       "Cancellare"  ,;
                       "OK"           }
   acBrowseError := { "Window: " ,;
                      " non � definita. Programma terminato" ,;
                      "Errore MiniGUI"  ,;
                      "Controllo: " ,;
                      " Di " ,;
                      " Gi� definito. Programma Terminato" ,;
                      "Browse: Tipo non valido. Programma Terminato"  ,;
                      "Browse: Modifica non possibile: il campo non � pertinente l'area di lavoro.Programma Terminato",;
                      "Record gi� utilizzato da altro utente"                 ,;
                      "Attenzione!"                                           ,;
                      "Dato non valido" }
   acBrowseMessages := { 'Sei sicuro ?' , 'Cancella Record' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Cancellare il record"+Chr(13)+"Sei sicuro ?"+Chr(13)                  ,;
                  Chr(13)+"File indice mancante"+Chr(13)+"Ricerca impossibile"+Chr(13)            ,;
                  Chr(13)+"Campo indice mancante"+Chr(13)+"Ricerca impossibile"+Chr(13)        ,;
                  Chr(13)+"Ricerca impossibile per"+Chr(13)+"campi memo o logici"+Chr(13)       ,;
                  Chr(13)+"Record non trovato"+Chr(13)                                        ,;
                  Chr(13)+"Troppe colonne"+Chr(13)+"Il report non pu� essere stampato"+Chr(13) }
   acABMLabel := { "Record"              ,;
                   "Record totali"       ,;
                   "  (Aggiungi)"        ,;
                   "     (Nuovo)"        ,;
                   "Inserire il numero del record" ,;
                   "Ricerca"                ,;
                   "Testo da cercare"         ,;
                   "Data da cercare"         ,;
                   "Numero da cercare"       ,;
                   "Definizione del report"   ,;
                   "Colonne del report"      ,;
                   "Colonne totali"     ,;
                   "Record Iniziale"      ,;
                   "Record Finale"        ,;
                   "Report di "          ,;
                   "Data:"               ,;
                   "Primo Record:"     ,;
                   "Ultimo Record:"       ,;
                   "Ordinare per:"         ,;
                   "S�"                 ,;
                   "No"                  ,;
                   "Pagina "               ,;
                   " di "                 }
   acABMButton := { "Chiudi"    ,;
                    "Nuovo"      ,;
                    "Modifica"     ,;
                    "Cancella"   ,;
                    "Ricerca"     ,;
                    "Vai a"     ,;
                    "Report"   ,;
                    "Primo"    ,;
                    "Precedente" ,;
                    "Successivo"     ,;
                    "Ultimo"     ,;
                    "Salva"     ,;
                    "Annulla"   ,;
                    "Aggiungi"      ,;
                    "Rimuovi"   ,;
                    "Stampa"    ,;
                    "Chiudi"     }
   acABMError := { "EDIT, il nome dell'area � mancante"                              ,;
                   "EDIT, quest'area contiene pi� di 16 campi"              ,;
                   "EDIT, modalit� aggiornamento fuori dal limite (segnalare l'errore)"      ,;
                   "EDIT, evento pricipale fuori dal limite (segnalare l'errore)" ,;
                   "EDIT, lista eventi fuori dal limite (segnalare l'errore)"  }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Chiudi",          ; // 1
                "&Nuovo",           ; // 2
                "&Modifica",        ; // 3
                "&Cancella",        ; // 4
                "&Trova",           ; // 5
                "&Stampa",          ; // 6
                "&Annulla",         ; // 7
                "&Ok",              ; // 8
                "C&opia",           ; // 9
                "A&ttiva Filtro",   ; // 10
                "&Disattiva Filtro" } // 11
   acLabel := { "Nessuno",                          ; // 1
                "Record",                           ; // 2
                "Totale",                           ; // 3
                "Ordinamento attivo",               ; // 4
                "Opzioni",                          ; // 5
                "Nuovo record",                     ; // 6
                "Modifica record",                  ; // 7
                "Seleziona record",                 ; // 8
                "Trova record",                     ; // 9
                "Stampa opzioni",                   ; // 10
                "Campi disponibili",                ; // 11
                "Campi da stampare",                ; // 12
                "Stampanti disponibili",            ; // 13
                "Primo  record da stampare",        ; // 14
                "Ultimo record da stampare",        ; // 15
                "Cancella record",                  ; // 16
                "Anteprima",                        ; // 17
                "Visualizza pagina miniature",      ; // 18
                "Condizioni Filtro: ",              ; // 19
                "Filtrato: ",                       ; // 20
                "Opzioni Filtro" ,                  ; // 21
                "Campi del Database" ,              ; // 22
                "Operatori di comparazione",        ; // 23
                "Valore Filtro",                    ; // 24
                "Seleziona campo da filtrare",      ; // 25
                "Seleziona operatore comparazione", ; // 26
                "Uguale",                           ; // 27
                "Non Uguale",                       ; // 28
                "Maggiore di",                      ; // 29
                "Minore di",                        ; // 30
                "Maggiore o uguale a",              ; // 31
                "Minore o uguale a"                 } // 32
   acUser := { ABM_CRLF + "Nessuna area attiva.   "  + ABM_CRLF + "Selezionare un'area prima della chiamata a EDIT   " + ABM_CRLF,  ; // 1
               "Digitare valore campo (testo)",                                                                                     ; // 2
               "Digitare valore campo (numerico)",                                                                                  ; // 3
               "Selezionare data",                                                                                                  ; // 4
               "Attivare per valore TRUE",                                                                                          ; // 5
               "Inserire valore campo",                                                                                             ; // 6
               "Seleziona un record and premi OK",                                                                                  ; // 7
               ABM_CRLF + "Cancellazione record attivo   " + ABM_CRLF + "Sei sicuro?      " + ABM_CRLF,                             ; // 8
               ABM_CRLF + "Nessun ordinamento attivo     " + ABM_CRLF + "Selezionarne uno " + ABM_CRLF,                             ; // 9
               ABM_CRLF + "Ricerca non possibile su campi MEMO o LOGICI   " + ABM_CRLF,                                             ; // 10
               ABM_CRLF + "Record non trovato   " + ABM_CRLF,                                                                       ; // 11
               "Seleziona campo da includere nel listato",                                                                          ; // 12
               "Seleziona campo da escludere dal listato",                                                                          ; // 13
               "Selezionare la stampante",                                                                                          ; // 14
               "Premi per includere il campo",                                                                                      ; // 15
               "Premi per escludere il campo",                                                                                      ; // 16
               "Premi per selezionare il primo record da stampare",                                                                 ; // 17
               "Premi per selezionare l'ultimo record da stampare",                                                                 ; // 18
               ABM_CRLF + "Nessun altro campo da inserire   " + ABM_CRLF,                                                           ; // 19
               ABM_CRLF + "Prima seleziona il campo da includere " + ABM_CRLF,                                                      ; // 20
               ABM_CRLF + "Nessun altro campo da escludere       " + ABM_CRLF,                                                      ; // 21
               ABM_CRLF + "Prima seleziona il campo da escludere " + ABM_CRLF,                                                      ; // 22
               ABM_CRLF + "Nessun campo selezionato     " + ABM_CRLF + "Selezionare campi da includere nel listato   " + ABM_CRLF,  ; // 23
               ABM_CRLF + "Troppi campi !   " + ABM_CRLF + "Redurre il numero di campi   " + ABM_CRLF,                              ; // 24
               ABM_CRLF + "Stampante non pronta..!   " + ABM_CRLF,                                                                  ; // 25
               "Ordinato per",                                                                                                      ; // 26
               "Dal record",                                                                                                        ; // 27
               "Al  record",                                                                                                        ; // 28
               "Si",                                                                                                                ; // 29
               "No",                                                                                                                ; // 30
               "Pagina:",                                                                                                           ; // 31
               ABM_CRLF + "Selezionare una stampante   " + ABM_CRLF,                                                                ; // 32
               "Filtrato per ",                                                                                                     ; // 33
               ABM_CRLF + "Esiste un filtro attivo     " + ABM_CRLF,                                                                ; // 34
               ABM_CRLF + "Filtro non previsto per campi MEMO   " + ABM_CRLF,                                                       ; // 35
               ABM_CRLF + "Selezionare campo da filtrare        " + ABM_CRLF,                                                       ; // 36
               ABM_CRLF + "Selezionare un OPERATORE per filtro  " + ABM_CRLF,                                                       ; // 37
               ABM_CRLF + "Digitare un valore per filtro        " + ABM_CRLF,                                                       ; // 38
               ABM_CRLF + "Nessun filtro attivo    " + ABM_CRLF,                                                                    ; // 39
               ABM_CRLF + "Disattivare filtro ?   " + ABM_CRLF,                                                                     ; // 40
               ABM_CRLF + "Record bloccato da altro utente" + ABM_CRLF                                                              } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// POLISH
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_PL852 // Polish
RETURN ooHG_Messages_PLWIN()

FUNCTION ooHG_Messages_PLISO // Polish
RETURN ooHG_Messages_PLWIN()

FUNCTION ooHG_Messages_PLMAZ // Polish
RETURN ooHG_Messages_PLWIN()

FUNCTION ooHG_Messages_PLWIN // Polish
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Czy jeste� pewny ?'       ,;
               'Zamknij okno'             ,;
               'Zamkni�cie niedozwolone'  ,;
               'Program ju� uruchomiony'  ,;
               'Edycja'                   ,;
               'Ok'                       ,;
               'Porzu�'                   ,;
               'Pag.'                      }

   // BROWSE MESSAGES
   acBrowseButton := { "Dodaj"    ,;
                       "Edycja"   ,;
                       "Porzu�"   ,;
                       "OK"        }
   acBrowseError := { "Okno: "                                              ,;
                      " nie zdefiniowane.Program zako�czony"         ,;
                      "B��d MiniGUI"                                         ,;
                      "Kontrolka: "                                             ,;
                      " z "                                                  ,;
                      " ju� zdefiniowana. Program zako�czony"                  ,;
                      "Browse: Niedozwolony typ danych. Program zako�czony"          ,;
                      "Browse: Klauzula Append nie mo�e by� stosowana do p�l nie nale��cych do aktualnego obszaru roboczego. Program zako�czony",;
                      "Rekord edytowany przez innego u�ytkownika"                ,;
                      "Ostrze�enie"                                               ,;
                      "Nieprawid�owy wpis"                                          }
   acBrowseMessages := { 'Czy jesteo pewny ?' , 'Skasuj rekord' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Usuni�cie rekordu"+Chr(13)+"Jeste� pewny ?"+Chr(13)                 ,;
                  Chr(13)+"B��dny zbi�r Indeksowy"+Chr(13)+"Nie mo�na szuka�"+Chr(13)         ,;
                  Chr(13)+"Nie mo�na znale�� pola indeksu"+Chr(13)+"Nie mo�na szuka�"+Chr(13) ,;
                  Chr(13)+"Nie mo�na szuka� wg"+Chr(13)+"pola memo lub logicznego"+Chr(13)         ,;
                  Chr(13)+"Rekordu nie znaleziono"+Chr(13)                                                     ,;
                  Chr(13)+"Zbyt wiele kolumn"+Chr(13)+"Raport nie mo�e zmie�ci� si� na arkuszu"+Chr(13)      }
   acABMLabel := { "Rekord"              ,;
                   "Liczba rekord�w"        ,;
                   "      (Nowy)"        ,;
                   "    (Edycja)"        ,;
                   "Wprowad� numer rekordu" ,;
                   "Szukaj"                ,;
                   "Szukaj tekstu"         ,;
                   "Szukaj daty"         ,;
                   "Szukaj liczby"       ,;
                   "Definicja Raportu"   ,;
                   "Kolumny Raportu"      ,;
                   "Dost�pne kolumny"     ,;
                   "Pocz�tkowy rekord"      ,;
                   "Ko�cowy rekord"        ,;
                   "Raport z "          ,;
                   "Data:"               ,;
                   "Pocz�tkowy rekord:"     ,;
                   "Ko�cowy rekord:"       ,;
                   "Sortowanie wg:"         ,;
                   "Tak"                 ,;
                   "Nie"                  ,;
                   "Strona "               ,;
                   " z "                 }
   acABMButton := { "Zamknij"    ,;
                    "Nowy"      ,;
                    "Edytuj"     ,;
                    "Usu�"   ,;
                    "Znajd�"     ,;
                    "Id� do"     ,;
                    "Raport"   ,;
                    "Pierwszy"    ,;
                    "Poprzedni" ,;
                    "Nast�pny"     ,;
                    "Ostatni"     ,;
                    "Zapisz"     ,;
                    "Rezygnuj"   ,;
                    "Dodaj"      ,;
                    "Usu�"   ,;
                    "Drukuj"    ,;
                    "Zamknij"     }
   acABMError := { "EDIT, b��dna nazwa bazy"                                  ,;
                   "EDIT, baza ma wi�cej ni� 16 p�l"                   ,;
                   "EDIT, tryb od�wierzania poza zakresem (zobacz raport b��d�w)"      ,;
                   "EDIT, liczba zdarz� podstawowych poza zakresem (zobacz raport b��d�w)" ,;
                   "EDIT, lista zdarze� poza zakresem (zobacz raport b��d�w)"  }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Zamknij",        ; // 1
                "&Nowy",           ; // 2
                "&Modyfikuj",      ; // 3
                "&Kasuj",          ; // 4
                "&Znajd�",         ; // 5
                "&Drukuj",         ; // 6
                "&Porzu�",         ; // 7
                "&Ok",             ; // 8
                "&Kopiuj",         ; // 9
                "&Aktywuj Filtr",  ; // 10
                "&Deaktywuj Filtr" } // 11
   acLabel := { "Brak",                        ; // 1
                "Rekord",                      ; // 2
                "Suma",                        ; // 3
                "Aktywny indeks",              ; // 4
                "Opcje",                       ; // 5
                "Nowy rekord",                 ; // 6
                "Modyfikuj rekord",            ; // 7
                "Wybierz rekord",              ; // 8
                "Znajd� rekord",               ; // 9
                "Opcje druku",                 ; // 10
                "Dost�pne pola",               ; // 11
                "Pola do druku",               ; // 12
                "Dost�pne drukarki",           ; // 13
                "Pierwszy rekord do druku",    ; // 14
                "Ostatni rekord do druku",     ; // 15
                "Skasuj rekord",               ; // 16
                "Podgl�d",                     ; // 17
                "Poka� miniatury",             ; // 18
                "Stan filtru: ",               ; // 19
                "Filtrowane: ",                ; // 20
                "Opcje filtrowania" ,          ; // 21
                "Pola bazy danych" ,           ; // 22
                "Operator por�wnania",         ; // 23
                "Warto�� filtru",              ; // 24
                "Wybierz pola do filtru",      ; // 25
                "Wybierz operator por�wnania", ; // 26
                "R�wna si�",                   ; // 27
                "Nie r�wna si�",               ; // 28
                "Wi�kszy ",                    ; // 29
                "Mniejszy ",                   ; // 30
                "Wi�kszy lub r�wny ",          ; // 31
                "Mniejszy lub r�wny"           } // 32
   acUser := { ABM_CRLF + "Aktywny obszar nie odnaleziony   "  + ABM_CRLF + "Wybierz obszar przed wywo�aniem EDIT   " + ABM_CRLF,   ; // 1
               "Poszukiwany ci�g znak�w (dowolny tekst)",                                                                           ; // 2
               "Poszukiwana warto�� (dowolna liczba)",                                                                              ; // 3
               "Wybierz dat�",                                                                                                      ; // 4
               "Check for true value",                                                                                              ; // 5
               "Wprowa� warto��",                                                                                                   ; // 6
               "Wybierz dowolny rekord i naci�cij OK",                                                                              ; // 7
               ABM_CRLF + "Wybra�e� opcj� kasowania rekordu   " + ABM_CRLF + "Czy jeste� pewien?    " + ABM_CRLF,                   ; // 8
               ABM_CRLF + "Brak aktywnych indeks�w   " + ABM_CRLF + "Wybierz    " + ABM_CRLF,                                       ; // 9
               ABM_CRLF + "Nie mo�na szuka� w polach typu MEMO lub LOGIC   " + ABM_CRLF,                                            ; // 10
               ABM_CRLF + "Rekord nie znaleziony   " + ABM_CRLF,                                                                    ; // 11
               "Wybierz rekord kt�ry nale�y doda� do listy",                                                                        ; // 12
               "Wybierz rekord kt�ry nale�y wy��czy� z listy",                                                                      ; // 13
               "Wybierz drukark�",                                                                                                  ; // 14
               "Kliknij na przycisk by doda� pole",                                                                                 ; // 15
               "Kliknij na przycisk by odj�� pole",                                                                                 ; // 16
               "Kliknij, aby wybra� pierwszy rekord do druku",                                                                      ; // 17
               "Kliknij, aby wybra� ostatni rekord do druku",                                                                       ; // 18
               ABM_CRLF + "Brak p�l do w��czenia   " + ABM_CRLF,                                                                    ; // 19
               ABM_CRLF + "Najpierw wybierz pola do w��czenia   " + ABM_CRLF,                                                       ; // 20
               ABM_CRLF + "Brak p�l do wy��czenia   " + ABM_CRLF,                                                                   ; // 21
               ABM_CRLF + "Najpierw wybierz pola do wy��czenia   " + ABM_CRLF,                                                      ; // 22
               ABM_CRLF + "Nie wybra�e� �adnych p�l   " + ABM_CRLF + "Najpierw wybierz pola do w��czenia do wydruku   " + ABM_CRLF, ; // 23
               ABM_CRLF + "Za wiele p�l   " + ABM_CRLF + "Zredukuj liczb� p�l   " + ABM_CRLF,                                       ; // 24
               ABM_CRLF + "Drukarka nie gotowa   " + ABM_CRLF,                                                                      ; // 25
               "Porz�dek wg",                                                                                                       ; // 26
               "Od rekordu",                                                                                                        ; // 27
               "Do rekordu",                                                                                                        ; // 28
               "Tak",                                                                                                               ; // 29
               "Nie",                                                                                                               ; // 30
               "Strona:",                                                                                                           ; // 31
               ABM_CRLF + "Wybierz drukark�   " + ABM_CRLF,                                                                         ; // 32
               "Filtrowanie wg",                                                                                                    ; // 33
               ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 34
               ABM_CRLF + "Nie mo�na filtrowa� wg. p�l typu MEMO    " + ABM_CRLF,                                                   ; // 35
               ABM_CRLF + "Wybierz pola dla filtru    " + ABM_CRLF,                                                                 ; // 36
               ABM_CRLF + "Wybierz operator por�wnania dla filtru    " + ABM_CRLF,                                                  ; // 37
               ABM_CRLF + "Wpisz dowoln� warto�� dla filtru    " + ABM_CRLF,                                                        ; // 38
               ABM_CRLF + "Brak aktywnego filtru    " + ABM_CRLF,                                                                   ; // 39
               ABM_CRLF + "Deaktywowa� filtr?   " + ABM_CRLF,                                                                       ; // 40
               ABM_CRLF + "Record locked by another user" + ABM_CRLF                                                                } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// PORTUGUESE
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_PT // Portuguese
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Voc� tem Certeza ?'            ,;
               'Fechar Janela'                 ,;
               'Fechamento n�o permitido'      ,;
               'Programa j� est� em execu��o'  ,;
               'Edita'                         ,;
               'Ok'                            ,;
               'Cancela'                       ,;
               'Pag.'                           }

   // BROWSE MESSAGES
   acBrowseButton := { "Incluir"  ,;
                       "Alterar"  ,;
                       "Cancelar" ,;
                       "OK"        }
   acBrowseError := { "Window: "                                              ,;
                      " Erro n�o definido. Programa ser� fechado"             ,;
                      "Erro na MiniGUI.lib"                                   ,;
                      "Control: "                                             ,;
                      " Of "                                                  ,;
                      " N�o pronto. Programa ser� fechado"                    ,;
                      "Browse: Tipo Invalido !!!. Programa ser� fechado"      ,;
                      "Browse: Edi��o n�o pode ser efetivada,campo n�o pertence a essa �rea. Programa ser� fechado" ,;
                      "Arquivo em uso n�o pode ser editado !!!"               ,;
                      "Aguarde..."                                            ,;
                      "Dado Invalido"                                          }
   acBrowseMessages := { 'Voc� tem Certeza ?' , 'Apaga Registro' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Ser� apagado o registro atual"+Chr(13)+"Tem certeza?"+Chr(13)                 ,;
                  Chr(13)+"N�o existe um �ndice ativo"+Chr(13)+"N�o � poss�vel realizar a busca"+Chr(13)         ,;
                  Chr(13)+"N�o encontrado o campo �ndice"+Chr(13)+"N�o � poss�vel realizar a busca"+Chr(13) ,;
                  Chr(13)+"N�o � poss�vel realizar busca"+Chr(13)+"por campos memo ou l�gicos"+Chr(13)         ,;
                  Chr(13)+"Registro n�o encontrado"+Chr(13)                                                     ,;
                  Chr(13)+"Inclu�das colunas em excesso"+Chr(13)+"A listagem completa n�o caber� na tela"+Chr(13)      }
   acABMLabel := { "Registro Atual"                 ,;
                   "Total Registros"                ,;
                   "      (Novo)"                   ,;
                   "    (Editar)"                   ,;
                   "Introduza o n�mero do registro" ,;
                   "Buscar"                         ,;
                   "Texto a buscar"                 ,;
                   "Data a buscar"                  ,;
                   "N�mero a buscar"                ,;
                   "Definic�o da lista"             ,;
                   "Colunas da lista"               ,;
                   "Colunas dispon�veis"            ,;
                   "Registro inicial"               ,;
                   "Registro final"                 ,;
                   "Lista de "                      ,;
                   "Data:"                          ,;
                   "Primeiro registro:"             ,;
                   "�ltimo registro:"               ,;
                   "Ordenado por:"                  ,;
                   "Sim"                            ,;
                   "N�o"                            ,;
                   "P�gina "                        ,;
                   " de "                            }
   acABMButton := { "Fechar"           ,;
                    "Novo"             ,;
                    "Modificar"        ,;
                    "Eliminar"         ,;
                    "Buscar"           ,;
                    "Ir ao registro"   ,;
                    "Listar"           ,;
                    "Primeiro"         ,;
                    "Anterior"         ,;
                    "Seguinte"         ,;
                    "�ltimo"           ,;
                    "Guardar"          ,;
                    "Cancelar"         ,;
                    "Juntar"           ,;
                    "Sair"             ,;
                    "Imprimir"         ,;
                    "Fechar"            }
   acABMError := { "EDIT, N�o foi especificada a �rea"                                    ,;
                   "EDIT, A �rea contem mais de 16 campos"                                ,;
                   "EDIT, Atualiza��o fora do limite (por favor comunique o erro)"        ,;
                   "EDIT, Evento principal fora do limite (por favor comunique o erro)"   ,;
                   "EDIT, Evento mostrado est�fora do limite (por favor comunique o erro)" }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Sair",           ; // 1
                "&Novo",            ; // 2
                "&Alterar",        ; // 3
                "&Eliminar",         ; // 4
                "&Localizar",           ; // 5
                "&Imprimir",         ; // 6
                "&Cancelar",         ; // 7
                "&Aceitar",          ; // 8
                "&Copiar",           ; // 9
                "&Ativar Filtro",   ; // 10
                "&Desativar Filtro" } // 11
   acLabel := { "Nenhum",                               ; // 1
                "Registro",                              ; // 2
                "Total",                                 ; // 3
                "Indice ativo",                         ; // 4
                "Op��o",                              ; // 5
                "Novo registro",                        ; // 6
                "Modificar registro",                    ; // 7
                "Selecionar registro",                  ; // 8
                "Localizar registro",                       ; // 9
                "Op��o de impress�o",                 ; // 10
                "Campos dispon�veis",                    ; // 11
                "Campos selecionados",                    ; // 12
                "Impressoras dispon�veis",                ; // 13
                "Primeiro registro a imprimir",            ; // 14
                "�ltimo registro a imprimir",            ; // 15
                "Apagar registro",                       ; // 16
                "Visualizar impress�o",                          ; // 17
                "P�ginas em miniatura",                  ; // 18
                "Condi��o do filtro: ",                ; // 19
                "Filtrado: ",                            ; // 20
                "Op��es do filtro" ,                 ; // 21
                "Campos de la bdd" ,                     ; // 22
                "Operador de compara��o",               ; // 23
                "Valor de compara��o",                  ; // 24
                "Selecione o campo a filtrar",         ; // 25
                "Selecione o operador de compara��o", ; // 26
                "Igual",                                 ; // 27
                "Diferente",                              ; // 28
                "Maior que",                             ; // 29
                "Menor que",                             ; // 30
                "Maior ou igual que",                     ; // 31
                "Menor ou igual que"                      } // 32
   acUser := { ABM_CRLF + "N�o ha uma area ativa   "  + ABM_CRLF + "Por favor selecione uma area antes de chamar a EDIT EXTENDED   " + ABM_CRLF,       ; // 1
               "Introduza o valor do campo (texto)",                                                                                      ; // 2
               "Introduza o valor do campo (num�rico)",                                                                                    ; // 3
               "Selecione a data",                                                                                                      ; // 4
               "Ative o indicar para valor verdadero",                                                                                                 ; // 5
               "Introduza o valor do campo",                                                                                                ; // 6
               "Selecione um registro e tecle Ok",                                                                                       ; // 7
               ABM_CRLF + "Confirma apagar o registro ativo   " + ABM_CRLF + "Tem certeza?    " + ABM_CRLF,                  ; // 8
               ABM_CRLF + "N�o ha um �ndice seleccionado    " + ABM_CRLF + "Por favor selecione un   " + ABM_CRLF,                            ; // 9
               ABM_CRLF + "N�o se pode realizar busca por campos tipo memo ou l�gico   " + ABM_CRLF,                                                   ; // 10
               ABM_CRLF + "Registro n�o encontrado   " + ABM_CRLF,                                                                            ; // 11
               "Selecione o campo a incluir na lista",                                                                                  ; // 12
               "Selecione o campo a excluir da lista",                                                                                ; // 13
               "Selecione a impressora",                                                                                                   ; // 14
               "Precione o bot�o para incluir o campo",                                                                                         ; // 15
               "Precione o bot�o para excluir o campo",                                                                                         ; // 16
               "Precione o bot�o para selecionar o primeiro registro a imprimir",                                                                      ; // 17
               "Precione o bot�o para selecionar o �ltimo registro a imprimir",                                                                       ; // 18
               ABM_CRLF + "Foram incluidos todos os campos   " + ABM_CRLF,                                                                   ; // 19
               ABM_CRLF + "Primeiro seleccione o campo a incluir   " + ABM_CRLF,                                                           ; // 20
               ABM_CRLF + "N�o ha campos para excluir   " + ABM_CRLF,                                                                    ; // 21
               ABM_CRLF + "Primeiro selecione o campo a excluir   " + ABM_CRLF,                                                            ; // 22
               ABM_CRLF + "N�o ha selecionado nenhum campo   " + ABM_CRLF,                                              ; // 23
               ABM_CRLF + "A lista n�o cabe na p�gina   " + ABM_CRLF + "Reduza o n�mero de campos   " + ABM_CRLF,                                   ; // 24
               ABM_CRLF + "A impressora n�o est� dispon�vel   " + ABM_CRLF,                                                                           ; // 25
               "Ordenado por",                                                                                                           ; // 26
               "Do registro",                                                                                                          ; // 27
               "At� registro",                                                                                                            ; // 28
               "Sim",                                                                                                                  ; // 29
               "N�o",                                                                                                                   ; // 30
               "P�gina:",                                                                                                                ; // 31
               ABM_CRLF + "Por favor selecione uma impressora   " + ABM_CRLF,                                                                     ; // 32
               "Filtrado por",                                                                                                          ; // 33
               ABM_CRLF + "N�o ha um filtro ativo    " + ABM_CRLF,                                                                  ; // 34
               ABM_CRLF + "N�o se pode filtrar por campos memo    " + ABM_CRLF,                                                                ; // 35
               ABM_CRLF + "Selecione o campo a filtrar    " + ABM_CRLF,                                                                 ; // 36
               ABM_CRLF + "Selecione o operador de compara��o    " + ABM_CRLF,                                                              ; // 37
               ABM_CRLF + "Introduza o valor do filtro    " + ABM_CRLF,                                                                   ; // 38
               ABM_CRLF + "N�o ha nenhum filtro ativo    " + ABM_CRLF,                                                              ; // 39
               ABM_CRLF + "Eliminar o filtro ativo?   " + ABM_CRLF,                                                                           ; // 40
               ABM_CRLF + "Registro bloqueado por outro usu�rio" + ABM_CRLF                                                                   } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// RUSSIAN
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_RU866 // Russian
RETURN ooHG_Messages_RUWIN()

FUNCTION ooHG_Messages_RUKOI8 // Russian
RETURN ooHG_Messages_RUWIN()

FUNCTION ooHG_Messages_RUWIN // Russian
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { '�� ������� ?'            ,;
               '������� ����'            ,;
               '�������� �� ��������'    ,;
               '��������� ��� ��������'  ,;
               '��������'                ,;
               '��'                      ,;
               '������'                  ,;
               'Pag.'                     }

   // BROWSE MESSAGES
   acBrowseButton := { "��������"  ,;
                       "��������"  ,;
                       "������"    ,;
                       "OK"         }
   acBrowseError := { "����: "                                              ,;
                      " �� ����������. ��������� ��������"                 ,;
                      "MiniGUI ������"                                     ,;
                      "������� ���������: "                               ,;
                      " �� "                                               ,;
                      " ��� ���������. ��������� ��������"                         ,;
                      "Browse: ����� ��� �� �������������. ��������� ��������"    ,;
                      "Browse: Append ����� �� ����� ���� ����������� � ����� �� ������ ������� �������. ��������� ��������",;
                      "������ ������ ������������ ������ �������������"           ,;
                      "��������������"                                             ,;
                      "������� ������������ ������"                                 }
   acBrowseMessages := { '�� ������� ?' , '������� ������' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"�������� ������."+Chr(13)+"�� ������� ?"+Chr(13)                  ,;
                  Chr(13)+"����������� ��������� ����"+Chr(13)+"����� ����������"+Chr(13)   ,;
                  Chr(13)+"����������� ��������� ����"+Chr(13)+"����� ����������"+Chr(13)   ,;
                  Chr(13)+"����� ���������� ��"+Chr(13)+"���� ��� ���������� �����"+Chr(13) ,;
                  Chr(13)+"������ �� �������"+Chr(13)                                       ,;
                  Chr(13)+"������� ����� �������"+Chr(13)+"����� �� ���������� �� �����"+Chr(13) }
   acABMLabel := { "������"              ,;
                   "����� �������"       ,;
                   "     (�����)"        ,;
                   "  (��������)"        ,;
                   "������� ����� ������",;
                   "�����"               ,;
                   "����� �����"         ,;
                   "����� ����"          ,;
                   "����� �����"         ,;
                   "��������� ������"    ,;
                   "������� ������"      ,;
                   "��������� �������"   ,;
                   "��������� ������"    ,;
                   "�������� ������"     ,;
                   "����� ��� "          ,;
                   "����:"               ,;
                   "������ ������:"      ,;
                   "�������� ������:"    ,;
                   "����������� ��:"     ,;
                   "��"                  ,;
                   "���"                 ,;
                   "�������� "           ,;
                   " �� "                 }
   acABMButton := { "�������"   ,;
                    "�����"     ,;
                    "��������"  ,;
                    "�������"   ,;
                    "�����"     ,;
                    "�������"   ,;
                    "�����"     ,;
                    "������"    ,;
                    "�����"     ,;
                    "������"    ,;
                    "���������" ,;
                    "���������" ,;
                    "������"    ,;
                    "��������"  ,;
                    "�������"   ,;
                    "������"    ,;
                    "�������"    }
   acABMError := { "EDIT, �� ������� ��� ������� �������"                     ,;
                   "EDIT, ����������� ������ �� 16 �����"                     ,;
                   "EDIT, ����� ���������� ��� ��������� (�������� �� ������)",;
                   "EDIT, ����� ������� ��� ��������� (�������� �� ������)"   ,;
                   "EDIT, ����� ������� �������� ��� ��������� (�������� �� ������)" }

   // EDIT EXTENDED MESSAGES
   acButton:= {}
   acLabel := {}
   acUser := {}

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// SPANISH
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_ES // Spanish
RETURN ooHG_Messages_ESWIN()

FUNCTION ooHG_Messages_ESWIN // Spanish
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { '� Est� seguro ?'                   ,;
               'Cerrar Ventana'                    ,;
               'Operaci�n no permitida'            ,;
               'El programa ya est� ejecut�ndose'  ,;
               'Editar'                            ,;
               'Aceptar'                           ,;
               'Cancelar'                          ,;
               'Pag.'                               }

   // BROWSE MESSAGES
   acBrowseButton := { "Agregar"    ,;
                       "Editar"     ,;
                       "Cancelar"   ,;
                       "Aceptar"     }
   acBrowseError := { "Window: "                                              ,;
                      " no est� definida. Ejecuci�n terminada"                ,;
                      "MiniGUI Error"                                         ,;
                      "Control: "                                             ,;
                      " De "                                                  ,;
                      " ya definido. Ejecuci�n terminada"                     ,;
                      "Browse: Tipo no permitido. Ejecuci�n terminada"        ,;
                      "Browse: La cl�usula APPEND no puede ser usada con campos no pertenecientes al area del BROWSE. Ejecuci�n terminada",;
                      "El registro est� siendo editado por otro usuario"      ,;
                      "Peligro"                                               ,;
                      "Entrada no v�lida"                                      }
   acBrowseMessages := { '� Est� Seguro ?' , 'Eliminar Registro' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Va a eliminar el registro actual"+Chr(13)+"� Est� seguro ?"+Chr(13)                 ,;
                  Chr(13)+"No hay un �ndice activo"+Chr(13)+"No se puede realizar la b�squeda"+Chr(13)         ,;
                  Chr(13)+"No se encuentra el campo �ndice"+Chr(13)+"No se puede realizar la b�squeda"+Chr(13) ,;
                  Chr(13)+"No se pueden realizar b�squedas"+Chr(13)+"por campos memo o l�gico"+Chr(13)         ,;
                  Chr(13)+"Registro no encontrado"+Chr(13)                                                     ,;
                  Chr(13)+"Ha incl�do demasiadas columnas"+Chr(13)+"El listado no cabe en la hoja"+Chr(13)      }
   acABMLabel := { "Registro Actual"                  ,;
                   "Registros Totales"                ,;
                   "     (Nuevo)"                     ,;
                   "    (Editar)"                     ,;
                   "Introduzca el n�mero de registro" ,;
                   "Buscar"                           ,;
                   "Texto a buscar"                   ,;
                   "Fecha a buscar"                   ,;
                   "N�mero a buscar"                  ,;
                   "Definici�n del listado"           ,;
                   "Columnas del listado"             ,;
                   "Columnas disponibles"             ,;
                   "Registro inicial"                 ,;
                   "Registro final"                   ,;
                   "Listado de "                      ,;
                   "Fecha:"                           ,;
                   "Primer registro:"                 ,;
                   "Ultimo registro:"                 ,;
                   "Ordenado por:"                    ,;
                   "Si"                               ,;
                   "No"                               ,;
                   "P�gina "                          ,;
                   " de "                              }
   acABMButton := { "Cerrar"           ,;
                    "Nuevo"            ,;
                    "Modificar"        ,;
                    "Eliminar"         ,;
                    "Buscar"           ,;
                    "Ir al registro"   ,;
                    "Listado"          ,;
                    "Primero"          ,;
                    "Anterior"         ,;
                    "Siguiente"        ,;
                    "�ltimo"           ,;
                    "Guardar"          ,;
                    "Cancelar"         ,;
                    "A�adir"           ,;
                    "Quitar"           ,;
                    "Imprimir"         ,;
                    "Cerrar"            }
   acABMError := { "EDIT, No se ha especificado el area"                                  ,;
                   "EDIT, El area contiene m�s de 16 campos"                              ,;
                   "EDIT, Refesco fuera de rango (por favor comunique el error)"          ,;
                   "EDIT, Evento principal fuera de rango (por favor comunique el error)" ,;
                   "EDIT, Evento listado fuera de rango (por favor comunique el error)"    }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Cerrar",           ; // 1
                "&Nuevo",            ; // 2
                "&Modificar",        ; // 3
                "&Eliminar",         ; // 4
                "&Buscar",           ; // 5
                "&Imprimir",         ; // 6
                "&Cancelar",         ; // 7
                "&Aceptar",          ; // 8
                "&Copiar",           ; // 9
                "&Activar Filtro",   ; // 10
                "&Desactivar Filtro" } // 11
   acLabel := { "Ninguno",                               ; // 1
                "Registro",                              ; // 2
                "Total",                                 ; // 3
                "Indice activo",                         ; // 4
                "Opciones",                              ; // 5
                "Nuevo registro",                        ; // 6
                "Modificar registro",                    ; // 7
                "Seleccionar registro",                  ; // 8
                "Buscar registro",                       ; // 9
                "Opciones de impresi�n",                 ; // 10
                "Campos disponibles",                    ; // 11
                "Campos del listado",                    ; // 12
                "Impresoras disponibles",                ; // 13
                "Primer registro a imprimir",            ; // 14
                "Ultimo registro a imprimir",            ; // 15
                "Borrar registro",                       ; // 16
                "Vista previa",                          ; // 17
                "P�ginas en miniatura",                  ; // 18
                "Condici�n del filtro: ",                ; // 19
                "Filtrado: ",                            ; // 20
                "Opciones de filtrado" ,                 ; // 21
                "Campos de la bdd" ,                     ; // 22
                "Operador de comparaci�n",               ; // 23
                "Valor de comparaci�n",                  ; // 24
                "Seleccione el campo a filtrar",         ; // 25
                "Seleccione el operador de comparaci�n", ; // 26
                "Igual",                                 ; // 27
                "Distinto",                              ; // 28
                "Mayor que",                             ; // 29
                "Menor que",                             ; // 30
                "Mayor o igual que",                     ; // 31
                "Menor o igual que"                      } // 32
   acUser := { ABM_CRLF + "No hay un area activa   "  + ABM_CRLF + "Por favor seleccione un area antes de llamar a EDIT EXTENDED   " + ABM_CRLF,       ; // 1
               "Introduzca el valor del campo (texto)",                                                                                      ; // 2
               "Introduzca el valor del campo (num�rico)",                                                                                    ; // 3
               "Seleccione la fecha",                                                                                                      ; // 4
               "Active la casilla para indicar un valor verdadero",                                                                                                 ; // 5
               "Introduzca el valor del campo",                                                                                                ; // 6
               "Seleccione un registro y pulse aceptar",                                                                                       ; // 7
               ABM_CRLF + "Se dispone a borrar el registro activo   " + ABM_CRLF + "�Est� seguro?    " + ABM_CRLF,                  ; // 8
               ABM_CRLF + "No se ha seleccionado un indice   " + ABM_CRLF + "Por favor seleccione uno   " + ABM_CRLF,                            ; // 9
               ABM_CRLF + "No se pueden realizar b�squedas por campos tipo memo o l�gico   " + ABM_CRLF,                                                   ; // 10
               ABM_CRLF + "Registro no encontrado   " + ABM_CRLF,                                                                            ; // 11
               "Seleccione el campo a incluir en el listado",                                                                                  ; // 12
               "Seleccione el campo a excluir del listado",                                                                                ; // 13
               "Seleccione la impresora",                                                                                                   ; // 14
               "Pulse el bot�n para incluir el campo",                                                                                         ; // 15
               "Pulse el bot�n para excluir el campo",                                                                                         ; // 16
               "Pulse el bot�n para seleccionar el primer registro a imprimir",                                                                      ; // 17
               "Pulse el bot�n para seleccionar el �ltimo registro a imprimir",                                                                       ; // 18
               ABM_CRLF + "Ha incluido todos los campos   " + ABM_CRLF,                                                                   ; // 19
               ABM_CRLF + "Primero seleccione el campo a incluir   " + ABM_CRLF,                                                           ; // 20
               ABM_CRLF + "No hay campos para excluir   " + ABM_CRLF,                                                                    ; // 21
               ABM_CRLF + "Primero seleccione el campo a excluir   " + ABM_CRLF,                                                            ; // 22
               ABM_CRLF + "No ha seleccionado ning�n campo   " + ABM_CRLF,                                              ; // 23
               ABM_CRLF + "El listado no cabe en la p�gina   " + ABM_CRLF + "Reduzca el numero de campos   " + ABM_CRLF,                                   ; // 24
               ABM_CRLF + "La impresora no est� disponible   " + ABM_CRLF,                                                                           ; // 25
               "Ordenado por",                                                                                                           ; // 26
               "Del registro",                                                                                                          ; // 27
               "Al registro",                                                                                                            ; // 28
               "S�",                                                                                                                  ; // 29
               "No",                                                                                                                   ; // 30
               "P�gina:",                                                                                                                ; // 31
               ABM_CRLF + "Por favor seleccione una impresora   " + ABM_CRLF,                                                                     ; // 32
               "Filtrado por",                                                                                                          ; // 33
               ABM_CRLF + "No hay un filtro activo    " + ABM_CRLF,                                                                  ; // 34
               ABM_CRLF + "No se puede filtrar por campos memo    " + ABM_CRLF,                                                                ; // 35
               ABM_CRLF + "Seleccione el campo a filtrar    " + ABM_CRLF,                                                                 ; // 36
               ABM_CRLF + "Seleccione el operador de comparaci�n    " + ABM_CRLF,                                                              ; // 37
               ABM_CRLF + "Introduzca el valor del filtro    " + ABM_CRLF,                                                                   ; // 38
               ABM_CRLF + "No hay ning�n filtro activo    " + ABM_CRLF,                                                              ; // 39
               ABM_CRLF + "�Eliminar el filtro activo?   " + ABM_CRLF,                                                                           ; // 40
               ABM_CRLF + "Registro bloqueado por otro usuario    " + ABM_CRLF                                                                   } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// FINNISH
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_FI // Finnish
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Oletko varma ?'           ,;
               'Sulje ikkuna'             ,;
               'Sulkeminen ei sallittu'   ,;
               'Ohjelma on jo k�ynniss�'  ,;
               'Korjaa'                   ,;
               'Ok'                       ,;
               'Keskeyt�'                 ,;
               'Sivu.'                     }

   // BROWSE MESSAGES
   acBrowseButton := { "Lis��"      ,;
                       "Korjaa"     ,;
                       " Keskeyt�"  ,;
                       " OK"         }
   acBrowseError := { "Ikkuna: " ,;
                      " m��rittelem�t�n. Ohjelma lopetettu" ,;
                      "MiniGUI Virhe",;
                      "Kontrolli: ",;
                      " / " ,;
                      " On jo m��ritelty. Ohjelma lopetettu" ,;
                      "Browse: Virheellinen tyyppi. Ohjelma lopetettu" ,;
                      "Browse: Et voi lis�t� kentti� jotka eiv�t ole BROWSEN m��rityksess�. Ohjelma lopetettu",;
                      "Toinen k�ytt�j� korjaa juuri tietuetta" ,;
                      "Varoitus" ,;
                      "Virheellinen arvo" }
   acBrowseMessages := { 'Oletko varma ?' , 'Poista tietue' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Poista tietue"+Chr(13)+"Oletko varma?"+Chr(13)                  ,;
                  Chr(13)+"Indeksi tiedosto puuttuu"+Chr(13)+"En voihakea"+Chr(13)            ,;
                  Chr(13)+"Indeksikentt� ei l�ydy"+Chr(13)+"En voihakea"+Chr(13)        ,;
                  Chr(13)+"En voi hakea memo"+Chr(13)+"tai loogisen kent�n mukaan"+Chr(13)       ,;
                  Chr(13)+"Tietue ei l�ydy"+Chr(13),;
                  Chr(13)+"Liian monta saraketta"+Chr(13)+"raportti ei mahdu sivulle"+Chr(13) }
   acABMLabel := { "Tietue"              ,;
                   "Tietue lukum��r�"    ,;
                   "       (Uusi)"       ,;
                   "      (Korjaa)"      ,;
                   "Anna tietue numero"  ,;
                   "Hae"                 ,;
                   "Hae teksti"          ,;
                   "Hae p�iv�ys"         ,;
                   "Hae numero"          ,;
                   "Raportti m��ritys"   ,;
                   "Raportti sarake"     ,;
                   "Sallitut sarakkeet"  ,;
                   "Alku tietue"         ,;
                   "Loppu tietue"        ,;
                   "Raportti "           ,;
                   "Pvm:"                ,;
                   "Alku tietue:"        ,;
                   "Loppu tietue:"       ,;
                   "Lajittelu:"         ,;
                   "Kyll�"                 ,;
                   "Ei"                  ,;
                   "Sivu "               ,;
                   " / "                 }
   acABMButton := { "Sulje"    ,;
                    "Uusi"     ,;
                    "Korjaa"   ,;
                    "Poista"   ,;
                    "Hae"      ,;
                    "Mene"     ,;
                    "Raportti" ,;
                    "Ensimm�inen" ,;
                    "Edellinen"   ,;
                    "Seuraava"    ,;
                    "Viimeinen"   ,;
                    "Tallenna"    ,;
                    "Keskeyt�"    ,;
                    "Lis��"       ,;
                    "Poista"      ,;
                    "Tulosta"     ,;
                    "Sulje"     }
   acABMError := { "EDIT, ty�alue puuttuu"   ,;
                   "EDIT, ty�alueella yli 16 kentt��",;
                   "EDIT, p�ivitysalue ylitys (raportoi virhe)"      ,;
                   "EDIT, tapahtuma numero ylitys (raportoi virhe)" ,;
                   "EDIT, lista tapahtuma numero ylitys (raportoi virhe)"}

   // EDIT EXTENDED MESSAGES
   acButton:= { " Sulje",            ; // 1
                " Uusi",              ; // 2
                " Muuta",           ; // 3
                " Poista",           ; // 4
                " Hae",             ; // 5
                " Tulosta",            ; // 6
                " Keskeyt�",           ; // 7
                " Ok",               ; // 8
                " Kopioi",             ; // 9
                " Aktivoi Filtteri",  ; // 10
                " Deaktivoi Filtteri" } // 11
   acLabel := { "Ei mit��n",                         ; // 1
                "Tietue",                       ; // 2
                "Yhteens�",                        ; // 3
                "Aktiivinen lajittelu",                 ; // 4
                "Optiot",                      ; // 5
                "Uusi tietue",                   ; // 6
                "Muuta tietue",                ; // 7
                "Valitse tietue",                ; // 8
                "Hae tietue",                  ; // 9
                "Tulostus optiot",                ; // 10
                "Valittavat kent�t",               ; // 11
                "Tulostettavat kent�t",              ; // 12
                "Valittavat tulostimet",           ; // 13
                "Ensim. tulostuttava tietue",        ; // 14
                "Viim. tulostettava tietue",         ; // 15
                "Poista tietue",                ; // 16
                "Esikatselu",                      ; // 17
                "N�yt� sivujen miniatyyrit",         ; // 18
                "Suodin ehto: ",           ; // 19
                "Suodatettu: ",                   ; // 20
                "Suodatus Optiot" ,           ; // 21
                "Tietokanta kent�t" ,             ; // 22
                "Vertailu operaattori",        ; // 23
                "Suodatus arvo",                 ; // 24
                "Valitse suodatus kentt�",       ; // 25
                "Valitse vertailu operaattori", ; // 26
                "Yht� kuin",                        ; // 27
                "Erisuuri kuin",                    ; // 28
                "Isompi kuin",                 ; // 29
                "Pienempi kuin",                   ; // 30
                "Isompi tai sama kuin",        ; // 31
                "Pienempi tai sama kuin"           } // 32
   acUser := { ABM_CRLF + "Ty�alue ei l�ydy.   "  + ABM_CRLF + "Valitse ty�aluetta ennenkun kutsut Edit  " + ABM_CRLF,       ; // 1
               "Anna kentt� arvo (teksti�)",                                  ; // 2
               "Anna kentt� arvo (numeerinen)",                                  ; // 3
               "Valitse p�iv�ys",                            ; // 4
               "Tarkista tosi arvo",                     ; // 5
               "Anna kentt� arvo",                    ; // 6
               "Valitse joku tietue ja paina OK",                                     ; // 7
               ABM_CRLF + "Olet poistamassa aktiivinen tietue   "+ABM_CRLF + "Oletko varma?    " + ABM_CRLF,                  ; // 8
               ABM_CRLF + "Ei aktiivista lajittelua   " + ABM_CRLF+"Valitse lajittelu   " + ABM_CRLF,                            ; // 9
               ABM_CRLF + "En voi hakea memo tai loogiseten kenttien perusteella  " + ABM_CRLF,; // 10
               ABM_CRLF + "Tietue ei l�ydy   " + ABM_CRLF,                                                ; // 11
               "Valitse listaan lis�tt�v�t kent�t",                                                    ; // 12
               "Valitse EI lis�tt�v�t kent�t",                                        ; // 13
               "Valitse tulostin",                   ; // 14
               "Paina n�pp�in lis��t�ksesi kentt�",                                                                  ; // 15
               "Paina n�pp�in poistaaksesi kentt�",                                                       ; //16
               "Paina n�pp�in valittaaksesi ensimm�inen tulostettava tietue",  ; // 17
               "Paina n�pp�in valittaaksesi viimeinen tulostettava tietue",   ; // 18
               ABM_CRLF + "Ei lis�� kentti�   " + ABM_CRLF,                                 ; // 19
               ABM_CRLF + "Valitse ensin lis�tt�v� kentt�   "+ABM_CRLF,                                                           ; //20
               ABM_CRLF + "EI Lis�� ohitettavia kentti�   " +ABM_CRLF,; // 21
               ABM_CRLF + "Valitse ensin ohitettava kentt�   " +ABM_CRLF,                                                            ;//22
               ABM_CRLF + "Et valinnut kentti�   " + ABM_CRLF + "Valitse tulosteen kent�t   " + ABM_CRLF,   ; // 23
               ABM_CRLF + "Liikaa kentti�   " + ABM_CRLF + "V�henn� kentt� lukum��r�   " + ABM_CRLF,; // 24
               ABM_CRLF + "Tulostin ei valmiina   " + ABM_CRLF,                                                  ; // 25
               "Lajittelu",             ; // 26
               "Tietueesta",              ; // 27
               "Tietueeseen",                  ; // 28
               "Kyll�",                ; // 29
               "EI",       ; // 30
               "Sivu:",          ; // 31
               ABM_CRLF + "Valitse tulostin   " + ABM_CRLF,                                       ; // 32
               "Lajittelu",            ; // 33
               ABM_CRLF + "Aktiivinen suodin olemassa    " + ABM_CRLF,                                                          ; // 34
               ABM_CRLF + "En voi suodattaa memo kentti�    "+ABM_CRLF,;// 35
               ABM_CRLF + "Valitse suodattava kentt�    " + ABM_CRLF,                                                           ; // 36
               ABM_CRLF + "Valitse suodattava operaattori    " +ABM_CRLF,                                                             ; //37
               ABM_CRLF + "Anna suodatusarvo    " + ABM_CRLF,                                         ; // 38
               ABM_CRLF + "Ei aktiivisia suotimia    " + ABM_CRLF,                                              ; // 39
               ABM_CRLF + "Poista suodin?   " + ABM_CRLF,                                        ; // 40
               ABM_CRLF + "Tietue lukittu    " + ABM_CRLF                                 } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// DUTCH
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_NL // Dutch
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Weet u het zeker?'        ,;
               'Sluit venster'            ,;
               'Sluiten niet toegestaan'  ,;
               'Programma is al actief'   ,;
               'Bewerken'                 ,;
               'Ok'                       ,;
               'Annuleren'                ,;
               'Pag.'                      }

   // BROWSE MESSAGES
   acBrowseButton := { "Toevoegen"  ,;
                       "Bewerken"      ,;
                       "&Annuleer"     ,;
                       "&OK"           }
   acBrowseError := { "Scherm: ",;
                      " is niet gedefinieerd. Programma be�indigd"           ,;
                      "MiniGUI fout",;
                      "Control: ",;
                      " Van ",;
                      " Is al gedefinieerd. Programma be�indigd"                   ,;
                      "Browse: Type niet toegestaan. Programma be�indigd"          ,;
                      "Browse: Toevoegen-methode kan niet worden gebruikt voor velden die niet bij het Browse werkgebied behoren. Programma be�indigd",;
                      "Regel word al veranderd door een andere gebruiker"          ,;
                      "Waarschuwing"                                               ,;
                      "Onjuiste invoer"                                            }
   acBrowseMessages := { 'Weet u het zeker?' , 'Verwijder regel' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Verwijder regel"+Chr(13)+"Weet u het zeker ?"+Chr(13)    ,;
                  Chr(13)+"Index bestand is er niet"+Chr(13)+"Kan niet zoeken"+Chr(13)          ,;
                  Chr(13)+"Kan index veld niet vinden"+Chr(13)+"Kan niet zoeken"+Chr(13)        ,;
                  Chr(13)+"Kan niet zoeken op"+Chr(13)+"Memo of logische velden"+Chr(13)        ,;
                  Chr(13)+"Regel niet gevonden"+Chr(13) ,;
                  Chr(13)+"Te veel rijen"+Chr(13)+"Het rapport past niet op het papier"+Chr(13) }
   acABMLabel := { "Regel"     ,;
                   "Regel aantal"          ,;
                   "       (Nieuw)"        ,;
                   "      (Bewerken)"      ,;
                   "Geef regel nummer"     ,;
                   "Vind"                  ,;
                   "Zoek tekst"            ,;
                   "Zoek datum"            ,;
                   "Zoek nummer"           ,;
                   "Rapport definitie"     ,;
                   "Rapport rijen"         ,;
                   "Beschikbare rijen"     ,;
                   "Eerste regel"          ,;
                   "Laatste regel"         ,;
                   "Rapport van "          ,;
                   "Datum:"                ,;
                   "Eerste regel:"         ,;
                   "Laatste tegel:"        ,;
                   "Gesorteerd op:"        ,;
                   "Ja"                    ,;
                   "Nee"                   ,;
                   "Pagina "               ,;
                   " van "                 }
   acABMButton := { "Sluiten"   ,;
                    "Nieuw"                 ,;
                    "Bewerken"              ,;
                    "Verwijderen"           ,;
                    "Vind"                  ,;
                    "Ga naar"               ,;
                    "Rapport"               ,;
                    "Eerste"                ,;
                    "Vorige"                ,;
                    "Volgende"              ,;
                    "Laatste"               ,;
                    "Bewaar"                ,;
                    "Annuleren"             ,;
                    "Voeg toe"              ,;
                    "Verwijder"             ,;
                    "Print"                 ,;
                    "Sluiten"               }
   acABMError := { "BEWERKEN, werkgebied naam bestaat niet",;
                   "BEWERKEN, dit werkgebied heeft meer dan 16 velden",;
                   "BEWERKEN, ververs manier buiten bereik (a.u.b. fout melden)"           ,;
                   "BEWERKEN, hoofd gebeurtenis nummer buiten bereik (a.u.b. fout melden)" ,;
                   "BEWERKEN, list gebeurtenis nummer buiten bereik (a.u.b. fout melden)"  }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Sluiten",          ; // 1
                "&Nieuw",            ; // 2
                "&Aanpassen",        ; // 3
                "&Verwijderen",      ; // 4
                "&Vind",             ; // 5
                "&Print",            ; // 6
                "&Annuleren",        ; // 7
                "&Ok",               ; // 8
                "&Kopieer",          ; // 9
                "&Activeer filter",  ; // 10
                "&Deactiveer filter" } // 11
   acLabel := { "Geen",                             ; // 1
                "Regel",                            ; // 2
                "Totaal",                           ; // 3
                "Actieve volgorde",                 ; // 4
                "Opties",                           ; // 5
                "Nieuw regel",                      ; // 6
                "Aanpassen regel",                  ; // 7
                "Selecteer regel",                  ; // 8
                "Vind regel",                       ; // 9
                "Print opties",                     ; //10
                "Beschikbare velden",               ; //11
                "Velden te printen",                ; //12
                "Beschikbare printers",             ; //13
                "Eerste regel te printen",          ; //14
                "Laatste regel te printen",         ; //15
                "Verwijder regel",                  ; //16
                "Voorbeeld",                        ; //17
                "Laat pagina klein zien",           ; //18
                "Filter condities: ",               ; //19
                "Gefilterd: ",                      ; //20
                "Filter opties" ,                   ; //21
                "Database velden" ,                 ; //22
                "Vergelijkings operator",           ; //23
                "Filter waarde",                    ; //24
                "Selecteer velden om te filteren",  ; //25
                "Selecteer vergelijkings operator", ; //26
                "Gelijk",                           ; //27
                "Niet gelijk",                      ; //28
                "Groter dan",                       ; //29
                "Kleiner dan",                      ; //30
                "Groter dan of gelijk aan",         ; //31
                "Kleiner dan of gelijk aan"         } //32
   acUser := { ABM_CRLF + "Kan geen actief werkgebied vinden   "  + ABM_CRLF + "Selecteer A.U.B. een actief werkgebied voor BEWERKEN aan te roepen   " + ABM_CRLF, ; // 1
               "Geef de veld waarde (een tekst)",; // 2
               "Geef de veld waarde (een nummer)",; // 3
               "Selecteer de datum",; // 4
               "Controleer voor geldige waarde",; // 5
               "Geef de veld waarde",; // 6
               "Selecteer een regel en druk op OK",; // 7
               ABM_CRLF + "Je gaat het actieve regel verwijderen  " + ABM_CRLF + "Zeker weten?    " + ABM_CRLF,; // 8
               ABM_CRLF + "Er is geen actieve volgorde " + ABM_CRLF + "Selecteer er A.U.B. een   " + ABM_CRLF,; // 9
               ABM_CRLF + "Kan niet zoeken in memo of logische velden   " + ABM_CRLF,; // 10
               ABM_CRLF + "Regel niet gevonden   " +ABM_CRLF,; // 11
               "Selecteer het veld om in de lijst in te sluiten",; // 12
               "Selecteer het veld om uit de lijst te halen",; // 13
               "Selecteer de printer",; // 14
               "Druk op de knop om het veld in te sluiten",; // 15
               "Druk op de knop om het veld uit te sluiten",; // 16
               "Druk op de knop om het eerste veld te selecteren om te printen",; // 17
               "Druk op de knop om het laatste veld te selecteren om te printen",; // 18
               ABM_CRLF + "Geen velden meer om in te sluiten   " + ABM_CRLF,; // 19
               ABM_CRLF + "Selecteer eerst het veld om in te sluiten   " + ABM_CRLF,; // 20
               ABM_CRLF + "Geen velden meer om uit te sluiten   " + ABM_CRLF,; // 21
               ABM_CRLF + "Selecteer eerst het veld om uit te sluiten   " + ABM_CRLF,; // 22
               ABM_CRLF + "Je hebt geen velden geselecteerd   " + ABM_CRLF + "Selecteer A.U.B. de velden om in te sluiten om te printen   " + ABM_CRLF, ; // 23
               ABM_CRLF + "Teveel velden   " + ABM_CRLF + "Selecteer minder velden   " + ABM_CRLF,; // 24
               ABM_CRLF + "Printer niet klaar   " + ABM_CRLF,; // 25
               "Volgorde op",; // 26
               "Van regel",; // 27
               "Tot regel",; // 28
               "Ja",; // 29
               "Nee",; // 30
               "Pagina:",; // 31
               ABM_CRLF + "Selecteer A.U.B. een printer " + ABM_CRLF,; // 32
               "Gefilterd op", ; // 33
               ABM_CRLF + "Er is een actief filter    " + ABM_CRLF,; // 34
               ABM_CRLF + "Kan niet filteren op memo velden    " + ABM_CRLF,; // 35
               ABM_CRLF + "Selecteer het veld om op te filteren    " + ABM_CRLF, ; // 36
               ABM_CRLF + "Selecteer een operator om te filteren    " + ABM_CRLF,; // 37
               ABM_CRLF + "Type een waarde om te filteren " + ABM_CRLF,; // 38
               ABM_CRLF + "Er is geen actief filter    "+ ABM_CRLF,; // 39
               ABM_CRLF + "Deactiveer filter?   " + ABM_CRLF,; // 40
               ABM_CRLF + "Regel geblokkeerd door een andere gebuiker" + ABM_CRLF } // 41

RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }

/////////////////////////////////////////////////////////////
// SLOVENIAN
////////////////////////////////////////////////////////////
FUNCTION ooHG_Messages_SLISO // Slovenian
RETURN ooHG_Messages_SLWIN()

FUNCTION ooHG_Messages_SL852 // Slovenian
RETURN ooHG_Messages_SLWIN()

FUNCTION ooHG_Messages_SL437 // Slovenian
RETURN ooHG_Messages_SLWIN()

FUNCTION ooHG_Messages_SLWIN // Slovenian
Local acMisc
Local acBrowseButton, acBrowseError, acBrowseMessages
Local acABMUser, acABMLabel, acABMButton, acABMError
Local acButton, acLabel, acUser

   // MISC MESSAGES
   acMisc := { 'Ste prepri�ani ?'        ,;
               'Zapri okno'              ,;
               'Zapiranje ni dovoljeno'  ,;
               'Program je �e zagnan'    ,;
               'Popravi'                 ,;
               'V redu'                  ,;
               'Prekini'                 ,;
               'Pag.'                     }

   // BROWSE MESSAGES
   acBrowseButton := { "Dodaj" ,;
                       "Popravi"    ,;
                       "Prekini"    ,;
                       "V redu" }
   acBrowseError := { "Window: "                        ,;
                      " not defined. Program terminated"     ,;
                      "MiniGUI Error"                        ,;
                      "Control: "                            ,;
                      " Of "                                 ,;
                      " Already defined. Program Terminated" ,;
                      "Type Not Allowed. Program terminated" ,;
                      "False WorkArea. Program Terminated"   ,;
                      "Zapis ureja drug uporabnik"           ,;
                      "Opozorilo"                            ,;
                      "Narobe vnos" }
   acBrowseMessages := { 'Ste prepri�ani ?' , 'Bri�i vrstico' }

   // EDIT MESSAGES
   acABMUser := { Chr(13)+"Bri�i vrstico"+Chr(13)+"Ste prepri�ani ?"+Chr(13)     ,;
                  Chr(13)+"Manjka indeksna datoteka"+Chr(13)+"Ne morem iskati"+Chr(13)       ,;
                  Chr(13)+"Ne najdem indeksnega polja"+Chr(13)+"Ne morem iskati"+Chr(13)     ,;
                  Chr(13)+"Ne morem iskati po"+Chr(13)+"memo ali logi�nih poljih"+Chr(13)    ,;
                  Chr(13)+"Ne najdem vrstice"+Chr(13)                                        ,;
                  Chr(13)+"Preve� kolon"+Chr(13)+"Poro�ilo ne gre na list"+Chr(13) }
   acABMLabel := { "Vrstica"    ,;
                   "�tevilo vrstic"         ,;
                   "       (Nova)"          ,;
                   "      (Popravi)"        ,;
                   "Vnesi �tevilko vrstice" ,;
                   "Poi��i"                 ,;
                   "Besedilo za iskanje"    ,;
                   "Datum za iskanje"       ,;
                   "�tevilka za iskanje"    ,;
                   "Parametri poro�ila"     ,;
                   "Kolon v poro�ilu"       ,;
                   "Kolon na razpolago"     ,;
                   "Za�etna vrstica"        ,;
                   "Kon�na vrstica"         ,;
                   "Pporo�ilo za "          ,;
                   "Datum:"                 ,;
                   "Za�etna vrstica:"       ,;
                   "Kon�na vrstica:"        ,;
                   "Urejeno po:"            ,;
                   "Ja"                     ,;
                   "Ne"                     ,;
                   "Stran "                 ,;
                   " od "                 }
   acABMButton := { "Zapri" ,;
                    "Nova"              ,;
                    "Uredi"             ,;
                    "Bri�i"             ,;
                    "Poi��i"            ,;
                    "Pojdi na"          ,;
                    "Poro�ilo"          ,;
                    "Prva"              ,;
                    "Prej�nja"          ,;
                    "Naslednja"         ,;
                    "Zadnja"            ,;
                    "Shrani"            ,;
                    "Prekini"           ,;
                    "Dodaj"             ,;
                    "Odstrani"          ,;
                    "Natisni"           ,;
                    "Zapri"     }
   acABMError := { "EDIT, workarea name missing"                  ,;
                   "EDIT, this workarea has more than 16 fields"              ,;
                   "EDIT, refresh mode out of range (please report bug)"      ,;
                   "EDIT, main event number out of range (please report bug)" ,;
                   "EDIT, list event number out of range (please report bug)"  }

   // EDIT EXTENDED MESSAGES
   acButton:= { "&Zapri",             ; // 1
                "&Nova",              ; // 2
                "&Spremeni",          ; // 3
                "&Bri�i",             ; // 4
                "&Poi��i",            ; // 5
                "&Natisni",           ; // 6
                "&Prekini",           ; // 7
                "&V redu",            ; // 8
                "&Kopiraj",           ; // 9
                "&Aktiviraj Filter",  ; // 10
                "&Deaktiviraj Filter" } // 11
   acLabel := { "Prazno",                        ; // 1
                "Vrstica",                       ; // 2
                "Skupaj",                        ; // 3
                "Activni indeks",                ; // 4
                "Mo�nosti",                      ; // 5
                "Nova vrstica",                  ; // 6
                "Spreminjaj vrstico",            ; // 7
                "Ozna�i vrstico",                ; // 8
                "Najdi vrstico",                 ; // 9
                "Mo�nosti tiskanja",             ; // 10
                "Polja na razpolago",            ; // 11
                "Polja za tiskanje",             ; // 12
                "Tiskalniki na razpolago",       ; // 13
                "Prva vrstica za tiskanje",      ; // 14
                "Zadnja vrstica za tiskanje",    ; // 15
                "Bri�i vrstico",                 ; // 16
                "Pregled",                       ; // 17
                "Mini pregled strani",           ; // 18
                "Pogoj za filter: ",             ; // 19
                "Filtrirano: ",                  ; // 20
                "Mo�nosti filtra" ,              ; // 21
                "Polja v datoteki" ,             ; // 22
                "Operator za primerjavo",        ; // 23
                "Vrednost filtra",               ; // 24
                "Izberi polje za filter",        ; // 25
                "Izberi operator za primerjavo", ; // 26
                "Enako",                         ; // 27
                "Neenako",                       ; // 28
                "Ve�je od",                      ; // 29
                "Manj�e od",                     ; // 30
                "Ve�je ali enako od",            ; // 31
                "Manj�e ali enako od"            } // 32
   acUser := { ABM_CRLF + "Can't find an active area.   "  + ABM_CRLF + "Please select any area before call EDIT   " + ABM_CRLF,; // 1
               "Vnesi vrednost (tekst)",                                                                                        ; // 2
               "Vnesi vrednost (�tevilka)",                                                                                     ; // 3
               "Izberi datum",                                                                                                  ; // 4
               "Ozna�i za logi�ni DA",                                                                                          ; // 5
               "Vnesi vrednost",                                                                                                ; // 6
               "Izberi vrstico in pritisni <V redu>",                                                                           ; // 7
               ABM_CRLF + "Pobrisali boste trenutno vrstico   " + ABM_CRLF + "Ste prepri�ani?    " + ABM_CRLF,                  ; // 8
               ABM_CRLF + "Ni aktivnega indeksa   " + ABM_CRLF + "Prosimo, izberite ga   " + ABM_CRLF,                          ; // 9
               ABM_CRLF + "Ne morem iskati po logi�nih oz. memo poljih   " + ABM_CRLF,                                          ; // 10
               ABM_CRLF + "Ne najdem vrstice   " + ABM_CRLF,                                                                    ; // 11
               "Izberite polje, ki bo vklju�eno na listo",                                                                      ; // 12
               "Izberite polje, ki NI vklju�eno na listo",                                                                      ; // 13
               "Izberite tisklanik",                                                                                            ; // 14
               "Pritisnite gumb za vklju�itev polja",                                                                           ; // 15
               "Pritisnite gumb za izklju�itev polja",                                                                          ; // 16
               "Pritisnite gumb za izbor prve vrstice za tiskanje",                                                             ; // 17
               "Pritisnite gumb za izbor zadnje vrstice za tiskanje",                                                           ; // 18
               ABM_CRLF + "Ni ve� polj za dodajanje   " + ABM_CRLF,                                                             ; // 19
               ABM_CRLF + "Najprej izberite ppolje za vklju�itev   " + ABM_CRLF,                                                ; // 20
               ABM_CRLF + "Ni ve� polj za izklju�itev   " + ABM_CRLF,                                                           ; // 21
               ABM_CRLF + "Najprej izberite polje za izklju�itev   " + ABM_CRLF,                                                ; // 22
               ABM_CRLF + "Niste izbrali nobenega polja   " + ABM_CRLF + "Prosom, izberite polje za tiskalnje   " + ABM_CRLF,   ; // 23
               ABM_CRLF + "Preve� polj   " + ABM_CRLF + "Zmanj�ajte �tevilo polj   " + ABM_CRLF,                                ; // 24
               ABM_CRLF + "Tiskalnik ni pripravljen   " + ABM_CRLF,                                                             ; // 25
               "Urejeno po",                                                                                                    ; // 26
               "Od vrstice",                                                                                                    ; // 27
               "do vrstice",                                                                                                    ; // 28
               "Ja",                                                                                                            ; // 29
               "Ne",                                                                                                            ; // 30
               "Stran:",                                                                                                        ; // 31
               ABM_CRLF + "Izberite tiskalnik   " + ABM_CRLF,                                                                   ; // 32
               "Filtrirano z",                                                                                                  ; // 33
               ABM_CRLF + "Aktiven filter v uporabi    " + ABM_CRLF,                                                            ; // 34
               ABM_CRLF + "Ne morem filtrirati z memo polji    " + ABM_CRLF,                                                    ; // 35
               ABM_CRLF + "Izberi polje za filtriranje    " + ABM_CRLF,                                                         ; // 36
               ABM_CRLF + "Izberi operator za filtriranje    " + ABM_CRLF,                                                      ; // 37
               ABM_CRLF + "Vnesi vrednost za filtriranje    " + ABM_CRLF,                                                       ; // 38
               ABM_CRLF + "Ni aktivnega filtra    " + ABM_CRLF,                                                                 ; // 39
               ABM_CRLF + "Deaktiviram filter?   " + ABM_CRLF,                                                                  ; // 40
               ABM_CRLF + "Vrstica zaklenjena - uporablja jo drug uporabnik    " + ABM_CRLF                                     } // 41
RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser }
