#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#InstallKeybdHook
#UseHook On

; The only way I could find to pass information from the layout to the emulator
; The layout changes the name of Layout_STD.txt or Layout_ALT.txt
; And we check here if the alternate layout is active and call the appropriate config
If FileExist( "F:\FrontEnd\attract-v2\layouts\Syskeuomorphic\Layout_STD.txt" ) {
	Run, parajve.exe -NoSplash -config="data/configuration.xml" %1%
} else {
	Run, parajve.exe -NoSplash -config="data/configurationnoovrly.xml" %1%
}

; Some other things not related to the alternate layout
Joy5:: ; Save state
	SendInput, {f5}
return

Joy6:: ; Load state
	SendInput, {f9}
return

Joy10:: SendInput, {break}

Joy9::
	SendInput, {ESC}
	ExitApp
Return

esc::
	SendInput, {ESC}
	ExitApp