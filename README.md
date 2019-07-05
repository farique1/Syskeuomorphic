# Syskeuomorphic  


A simple **Attract Mode** layout that intends to mimic the look and feel of classical videogames and computer systems displays.  

The included systems are:  
- Atari 2600  
- Odyssey²  
- ZX81  
- Vectrex (with and without overlay)  
- TRS-80 Color (2)  
- MSX (1)  
- Amiga (Workbench 2.0)  
- Virtual Boy (red and anaglyph)  
- Arcade (not skeuomorphic)  

![# Syskeuomorphic](https://github.com/farique1/Syskeuomorphic/blob/master/GitHub/Syskeu_Screenboard.png?raw=true)

> Systems screenshot view.  
> Vectrex and Virtual Boy alternate screens.  
> Overviews on systems "text mode".  
> Fonts details.  
> Arcade flyer view.  

[YouTube](https://youtu.be/qVWvaFZ74c8)  

## Characteristics  

### The Good  

- The layout tries to capture the mood and feel of the classic systems, not to be absolutely thecnically correct. They are also very text based.  
- As arcade games are all over the place design wise the arcade display is not Syskeuomorphic (but still sorta skeuomorphic)  
- Overviews use a "text mode" analogue on systems with strong separation between text and graphic screens.  
- Alternate mode launch the emulators with different settings.  
  - Vectrex display without the overlay theme that launch the emulator without overlays.  
  - Virtual Boy anaglyph display that launch the emulator in anaglyph mode.  
- The fonts were custom made  with [**Chartotype**](https://github.com/farique1/Chartotype), straight from system dumps when possible or made to represent the system feel otherwise.  
- Screenshot, flyer and overviews display.  
- List scroll bar, Long text scrolling on the info display and revealing long game names.  
- Independent help screens for joystick or keyboard.  
- Easy to add new systems with concise variables block with settings to every aspect of the display.  

### The Bad  

- Code not incredibly polished and somewhat rigid.  
- The Vectrex and Virtual Boy alternate modes use a terrible jerry rigged system to send information to the emulators.  
- 16:9 only.  

### The Ugly  

- Myself.  

## Thechnicalities  

### Systems Display names  

In order for the layout to recognise the current systems, their `displays` must be created with their names exactly as follows:  

```
Atari 2600
Odyssey2
ZX81
Vectrex
MSX
Amiga
Virtual Boy
Arcade
```


### Adding new systems  

To add a new system create a new emulator and display on **Attract Mode**.  
Create or copy the new system font on the `Syskeuomorphic/fonts` folder.  On the `Syskeuomorphic/images` folder create a background screen and ideally also create a joystick and/or keyboard help screen.  
On the layout `.nut` file, copy a new `CASE` block (like the one below) with the new system display name and adjust the colors and positions (terribly trial and error, sorry.)  
***Done!***  

> Fonts can easily be made with [**Chartotype**](https://github.com/farique1/Chartotype).  

> The alternate displays `CASE` has the `hasAlt` boolean set to `true` and an `if` block containing the variables with different values.   
> The alternate display also needs a different background file with the same name but ending with `_Alt` and the alternate display snapshots are added as `altsnap` with `Add Artwork` on the `Emulators` config in **Attract Mode**  

```Javascript
case "Atari 2600":
	cs  = 12; csp = cs; csg = cs // Character sizes
	ls  = 22; lsp = ls // Line spacings
	famd = 0 // Filter BG adjustment
	seti =  33; sepo = floor(seti / 2) // List items; Selected game position
	pcme =  40; pcmd = 160; pcms = 178 // First column positions
	scme = 171; scmd = 690; scms = pcms - 5; scmi = scms + seti * ls // second column positions
	tcme = 700; tcmd =1170; tipy = -3 // Third column positions
	bape =scme; bapd =1171; balt = 2 // Selected game bar positions and size
	baps = (sepo) * ls + pcms + 14 // selected game bar upper position
	lst = [208, 132, 192] // List color (RGB)
	fil = [236, 176, 224] // Filter color (RGB)
	fi2 = [160,  60, 136] // Filter alternate color (RGB)
	fib = [  0,   0,   0, 0] // Filter background color (RGB)
	sel = [252, 252, 104] // Selected game color (RGB)
	ent = [252, 252, 104] // Game entry number color (RGB)
	plc = [252, 252, 104] // Played count color (RGB)
	inf = [144, 180, 236] // Information upper color (RGB)
	inl = [144, 180, 236] // Information lower color (RGB)
	ovr = [ 40,  40,  40] // Overview color (RGB)
	ovb = [  0,   0,   0, 0] // Overview background color (RGBV) V = alpha or visible boolean
	ovo = [  0,   0,   0, 0] // Overview border color (RGBV) V = alpha or visible boolean
	bar = [160,  60, 136, 1] // Selected game bar color (RGBV) V = alpha or visible boolean
	scb = [  5,   7,  -6, 1] // Scroll bar adjustments: Upper, Lower, Left, Width
	snaP = [1227, 74, 1819, 923] // Snapshots position (Left, Upper, Right, Lower)
	flrP = [1227, 74, 1819, 923] // Flier positions (Left, Upper, Right, Lower)
	ovrP = [1227, 74, 1819, 923] // Overview positions (Left, Upper, Right, Lower)
	ovrO = [   0,  0,    0,   0] // Overview border positions (Left, Upper, Right, Lower)
	lineMin = 59; line = lineMin // Overview text line position
	hasAlt = false // Has alternate display?
	sysName = "" // System name ("" = blank, "default" = default system name, "Name" = 'Name')
	font = "A2600 Blocky" // Font used
	bgimg = "Atari2600WideFree" // Background image
	helpK = "Help_Keyboard.png" // Keyboard help image
	helpJ = "Help_Atari 2600J.png" // Joystick help image
	break
```

### The alternate mode emulator link  

To make the emulators open with different settings when called from the alternate displays (Vectrex with and without overlay and Virtual Boy with or without anaglyph mode), the only way I managed to send information from the layout to the emulator was by changing the name of a file on the layout folder.  
The file is named `Layout_STD.txt` and the layout changes it to `Layout_ALT.txt` when an alternate display is activated.  
**Attract Mode** then is set up to call an **Autohotkey** script instead of the emulator itself, this script checks the current name of the file and launch the emulator with the correct setting.  

ie:  
```Autohotkey
If FileExist( "F:\FrontEnd\attract-v2\layouts\Syskeuomorphic\Layout_STD.txt" ) {
	Run, mednafen.exe -vb.anaglyph.preset disabled -vb.anaglyph.rcolor 0x000000 "%1%"
} else {
	Run, mednafen.exe -vb.anaglyph.preset red_blue -vb.anaglyph.rcolor 0x00baff "%1%"
}
```

> These files are included for reference and are called `ParaJVEPreRun.ahk` and `mednafenPreRun.ahk`. They are provided in source format but are built into binary executables and put on the emulators folder to be used.  
> In fact, all the emulators are called through **SHK** scripts to standardise the inputs and also add standard save and load state keys setup.  
