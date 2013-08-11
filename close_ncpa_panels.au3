; Last modified $Id$
; $HeadURL$
; -*- visual-basic-mode -*-


#include <File.au3>; for TempFile(), _PathSplit(), And others
#include <Array.au3>
#include <date.au3>
AutoItSetOption("MustDeclareVars", 1)

; ------------------------------
; Main
; ------------------------------

Global Const $LogDirectory = @WindowsDir & "\temp" & "\."
Global Const $log = $LogDirectory & "\" & @ScriptName & ".log"


_FileWriteLog( $log, StringFormat("INFO: LINE %04i: Starting %s from directory %s on machine %s", _
                                  @ScriptLineNumber, @ScriptName, @ScriptDir, @ComputerName))

Global $WinMatchMode      
Global $WinMatchModeValue 
Global $WinTitle          
Global $WinEmbeddedText   
Global $WinWaitTimeout

$WinMatchMode      = "WinTitleMatchMode"
$WinMatchModeValue = 3 ;Exact title match
$WinTitle          = "Select a Company"
$WinEmbeddedText   = ""
$WinWaitTimeout    = 10
WaitAndActivateWindow(@ScriptLineNumber, $WinMatchMode, $WinMatchModeValue, $WinTitle, $WinEmbeddedText, $WinWaitTimeout)


_FileWriteLog( $log, StringFormat("INFO: LINE %04i: Ending %s\\%s", _
                                  @ScriptLineNumber, @ScriptDir, @ScriptName ))




; --------------------------------------------------
; Starting Function Definitions
; --------------------------------------------------

Func WaitAndActivateWindow($ScriptLineNumber, $WinMatchMode, $WinMatchModeValue, $WinTitle, $WinEmbeddedText, $WinWaitTimeout)

  _FileWriteLog( $log, _
                 StringFormat("INFO: LINE %04i: Setting %s to %s", _
                              $ScriptLineNumber, $WinMatchMode, $WinMatchModeValue))
  AutoItSetOption($WinMatchMode, $WinMatchModeValue)

  If "" == $WinEmbeddedText Then
      _FileWriteLog( $log, _
                    StringFormat("INFO: LINE %04i: Searching for window '%s'", _
                                 $ScriptLineNumber, $WinTitle))
  Else
      _FileWriteLog( $log, _
                    StringFormat("INFO: LINE %04i: Searching for window '%s' with '%s' embedded within it", _
                                 $ScriptLineNumber, $WinTitle, $WinEmbeddedText))
  EndIf

  local $WinWaitStatus

  $WinWaitStatus = WinWait($WinTitle, $WinEmbeddedText, $WinWaitTimeout)
  If 0 == $WinWaitStatus Then
      _FileWriteLog( $log, _
                    StringFormat("FATAL: LINE %04i: Can't find window '%s' or @error=1, quitting.", _
                                 $ScriptLineNumber, $WinTitle))

      Exit 1
  EndIF
  
  If Not WinActivate($WinTitle, $WinEmbeddedText) Then
        _FileWriteLog( $log, StringFormat("ERROR: LINE %04i: Can't find window '%s', quitting.", _
                                          @ScriptLineNumber, $WinTitle))



        Exit 1
  EndIf


  Local $full_title = WinGetTitle($WinTitle, $WinEmbeddedText)
  _FileWriteLog( $log, _
                StringFormat("INFO: LINE %04i: Found window '%s', setting it to be the focus, continuing...", _
                             $ScriptLineNumber, $full_title))
  

EndFunc

; --------------------------------------------------

; Emacs vars
; Local Variables: ***
; comment-column:0 ***
; tab-width: 4 ***
; comment-start:"; " ***
; End: ***
