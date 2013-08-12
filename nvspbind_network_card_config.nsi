!include LogicLib.nsh
!include FileFunc.nsh
!include MUI2.NSH
!include nsDialogs.nsh
!include nsis-streambox2\StreamboxNSISHelper.nsh

Name "${name}"
OutFile "${outfile}"

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"



VIAddVersionKey ProductName "My Fun Product"
VIAddVersionKey FileDescription "Creates fun things"
VIAddVersionKey Language "English"
VIAddVersionKey LegalCopyright "@Streambox"
VIAddVersionKey CompanyName "Streambox"
VIAddVersionKey ProductVersion "${version}"
VIAddVersionKey FileVersion "${version}"
VIProductVersion "${version}"

;--------------------------------
; docs
# http://nsis.sourceforge.net/Docs
# http://nsis.sourceforge.net/Macro_vs_Function
# http://nsis.sourceforge.net/Adding_custom_installer_pages
# http://nsis.sourceforge.net/ConfigWrite
# loops
# http://nsis.sourceforge.net/Docs/Chapter2.html#\2.3.6

;--------------------------------
Var sysdrive
var debug

;--------------------------------
;Interface Configuration

!define MUI_WELCOMEPAGE_TITLE "Welcome to the Streambox setup wizard."
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP nsis-streambox2\Graphics\sblogo.bmp
!define MUI_WELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_UNWELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_ABORTWARNING
!define MUI_ICON nsis-streambox2\Icons\Streambox_128.ico

UninstallText "This will uninstall ${name}"

;--------------------------------
;Pages

; !insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Functions

!insertmacro killProcess



Function .onInit
	StrCpy $sysdrive $WINDIR 1

	SetAutoClose true
	##############################
	# did we call with "/debug"
	StrCpy $debug 0
	${GetParameters} $0
	ClearErrors
	${GetOptions} $0 '/debug' $1
	${IfNot} ${Errors}
		StrCpy $debug 1
		SetAutoClose false #leave installer window open when /debug
	${EndIf}
	ClearErrors

FunctionEnd

Function .onInstSuccess
FunctionEnd

Section section1 section_section1

	SetOutPath '$TEMP\${name}'
	${killProcess} close_ncpa_panels.exe
	File close_ncpa_panels.exe
	exec close_ncpa_panels.exe

	${killProcess} nvspbind.exe
	File nvspbind.exe
	File nvspbind.txt
	File configure_cards.bat

	ExpandEnvStrings $0 %COMSPEC%
	nsExec::ExecToLog '"$0" /c cd "$TEMP\${name} && call configure_cards.bat"

	${If} 0 == $debug
		SetOutPath '$TEMP'
		${killProcess} close_ncpa_panels.exe
		${killProcess} nvspbind.exe
		rmdir /r '$TEMP\${name}'

	${Else}
		exec '"$WINDIR\explorer.exe" "$TEMP\${name}"'

		ExpandEnvStrings $0 %COMSPEC%
		exec '"$0" /k cd "$TEMP\${name}"'
	${EndIf}

SectionEnd
LangString DESC_section1 ${LANG_ENGLISH} \
"Description of section 1."

Section section2 section_section2

SectionEnd
LangString DESC_section2 ${LANG_ENGLISH} \
"Description of section 2."

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
