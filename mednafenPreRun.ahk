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
	Run, mednafen.exe -vb.anaglyph.preset disabled -vb.anaglyph.rcolor 0x000000 "%1%"
} else {
	Run, mednafen.exe -vb.anaglyph.preset red_blue -vb.anaglyph.rcolor 0x00baff "%1%"
}

; Some other things not related to the alternate layout
Joy10:: ; Start 
	If GetKeyState("Joy9") { ; Select
		SendInput, {ESC down}
		Sleep, 50
		SendInput, {ESC up}
		ExitApp
	} else {
		; nada
	}
Return

esc::
Sleep, 50
SendInput, {ESC down}
Sleep, 50
SendInput, {ESC up}
ExitApp