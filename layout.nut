// Attract Mode front end
// Syskeuomorphic
// A simple Attract Mode layout that intends to mimic the look and feel of classical videogames and computer systems displays
// Fred Rique (Farique) (c) 2018 - 2019
// https://github.com/farique1/Syskeuomorphic

class UserConfig </ help="A system skeuomorphic layout" />
{
	</ label="Cycle media custom key",
		help="Custom key to cycle through snap, flyer and overview",
		options="custom1,custom2,custom3,custom4,custom5,custom6",
		order=1 />
	cycleMediaKey = "custom1";

	</ label="Alt display custom key",
		help="Custom key to change to the alternate display (if exists)",
		options="custom1,custom2,custom3,custom4,custom5,custom6",
		order=2 />
	altDisplayKey = "custom2";

	</ label="Keyboard help key",
		help="Key to show the keyboard commands",
		is_input="yes",
		order=3 />
	keybHelpKey = "H";

	</ label="Overview scroll down key",
		help="Key to scroll down the overview window text",
		is_input="yes",
		order=4 />
	keybOvrvwDown = "W";

	</ label="Overview scroll up key",
		help="Key to scroll up the overview window text",
		is_input="yes",
		order=5 />
	keybOvrvwUp = "S";

	</ label="Joystick help key",
		help="Joystick button to show the joystick commands",
		is_input="yes",
		order=6 />
	jstkHelpKey = "Joy0 Button9";

	</ label="Overview scroll down button",
		help="Joystick button to scroll down the overview window text",
		is_input="yes",
		order=7 />
	jstkOvrvwDown = "Joy0 PovYpos";

	</ label="Overview scroll up button",
		help="Joystick button to scroll up the overview window text",
		is_input="yes",
		order=8 />
	jstkOvrvwUp = "Joy0 PovYneg";

	</ label="Info texts scroll speed",
		help="Scroll speed of the game information texts",
		order=9 />
	scrlSpeed = 0.2;

	</ label="Info texts scroll delay",
		help="Wait time (in miliseconds) before the game information texts scroll starts",
		order=10 />
	scrlDelay = 1000;

	</ label="Scroll bar duration",
		help="The visualization time of the list scroll bar (in miliseconds): -1 = Always off; 10000 = Always on.",
		order=11 />
	scrBarDur = 1000;
}

// Initialize
	fe.layout.width=1920;
	fe.layout.height=1080;

// Variables
	local my_config = fe.get_config()
	local month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"] // for the date display
	local famd // Filter Name Background (filterBG) right margin adjustment
	local pcme; local pcmd; local pcms // First column margins: Left; Right; Upper
	local scme; local scmd; local scms; local scmi // Second column margins: Left; Right; Upper; Lower
	local seti; local sepo // List Total Items; Selected Position 
	local LargSel; local LargSelGo = false // Selected initial width; Selected unravel animation start - end
	local tcme; local tcmd; local tipy // Third column margins: Left; Right; Time Position Y
	local bapd; local bape; local baps; local balt // Selected Bar: Right; Left; Upper; Height
	local lst; local fil; local fi2; local fib; local sel; local ent // Colors: List; Filter; Filter Alt; Filter BG; Selected; Selected Entrie
	local plc; local inf; local inl; local bar; local ovr; local ovb; local ovo // Colors: Played Cnt; Info Upp; Info Low; Sel Bar; Overview; Ovw BG; Ovw Borders
	local font; local cs; local csp; local csg; local ls; local lsp // Fonts: Font; Char Spacing; Char Spc Small; Char Spc Big; Line Spacing; Line Spc Small
	local snaP; local flrP; local ovrP; local ovrO; local scb // Media position: Snaps; Flyers; Overviews; Overviews Borders; Scroll Bar Adjustments
	local bgimg; local helpK; local helpJ // Images: Background; Help Keyboard; Help Joystick
	local is_PovYposK; local is_PovYnegK; local is_PovYposJ; local is_PovYnegJ // Overview direction scroll control Keyboard and Joystick
	local is_down_helpK; local is_down_helpJ; local now // Help screen keys, Keyboard and Joystick; Current Date
	local sysName; local currentDisplay = "" // System Name; Display Name
	local altLay = ""; local hasAlt = false // Alternate layout extension; Has Alternate display boolean
	local artVa = "100" // Media visualization bitmask
	local line; local lineMin // overview scroll topmost line (first_line_hint); first_line_hint offset
	local _scrlMsg = [0,0,0,0]; local scrlSze = [0,0,0,0]; local wd // Scroll info fe.text; Scroll info width; Scroll info whole width
	mg <- ["","","",""]; m2 <- ["","","",""] // Scroll text actual content; Scroll text compose helper
	le <- [0,0,0,0]; l2 <- [0,0,0,0]; tstop <- [0,0,0,0]; go <- [1,1,1,1] // Scrol text: Lenght; Lenght helper; Stop Time; Move boolean
	scrollStart <- [true,true,true,true] // If Scroll text needs to scroll
	ScrlDelay <- my_config["scrlDelay"].tofloat(); ScrlSpeed <- my_config["scrlSpeed"].tofloat() // Scroll text config: Delay; Speed
	local scrBarDur = my_config["scrBarDur"].tofloat(); local scrBarGo = false; local scrBarTmr = 0 // Scroll bar config: Duration; Move; Timer
	local cycleMediaKey = my_config["cycleMediaKey"]; local altDisplayKey = my_config["altDisplayKey"]; // Custom keys config: Media; Alt display
	local keybHelpKey = my_config["keybHelpKey"]; local keybOvrvwDown = my_config["keybOvrvwDown"]; local keybOvrvwUp = my_config["keybOvrvwUp"] // Keys config: Help; Ovrvw down; Ovrvw Up
	local jstkHelpKey = my_config["jstkHelpKey"]; local jstkOvrvwDown = my_config["jstkOvrvwDown"]; local jstkOvrvwUp = my_config["jstkOvrvwUp"] // Buttons config: Help; Ovrvw down; Ovrvw Up

// Layout
	fe.layout.font = "Gelasio-Regular"
	local bg = fe.add_image( "" )
	local _snap = fe.add_artwork( "snap" );
	_snap.preserve_aspect_ratio = true
	_snap.visible = 1
	local _altsnap = fe.add_artwork( "altsnap" );
	_altsnap.preserve_aspect_ratio = true
	_altsnap.visible = 0
	local _flyer = fe.add_artwork( "flyer" );
	_flyer.preserve_aspect_ratio = true
	_flyer.visible=0;
	local _overviewOsc = fe.add_text( "",0,0,0,0 )
	_overviewOsc.visible=0
	_overviewOsc.nomargin = true
	local _overview = fe.add_text( "[Overview]",0,0,0,0)
	_overview.word_wrap = true
	_overview.margin = 20
	_overview.visible = 0
	local _sysName = fe.add_text( "",0,0,0,0)
	_sysName.nomargin = true
	local _dashBar = fe.add_text( "",0,0,0,0)
	_dashBar.align = Align.Left
	_dashBar.nomargin = true
	local _barra = fe.add_text( "",0,0,0,0)
	_barra.nomargin = true
	local _listbox = fe.add_listbox(0,0,0,0)
	_listbox.align = Align.Left
	_listbox.nomargin = true
	local _selec = fe.add_text( "[Title]",0,0,0,0)
	_selec.align = Align.Left
	_selec.nomargin = true
	local _filterBG = fe.add_text( "",0,0,0,0)
	_filterBG.nomargin = true
	local _filter = fe.add_text( "[FilterName]",0,0,0,0)
	_filter.align = Align.Right
	_filter.nomargin = true
	local _games = fe.add_text( "games",0,0,0,0)
	_games.align = Align.Right
	_games.nomargin = true
	local _lSize = fe.add_text( "[ListSize]",0,0,0,0 )
	_lSize.align = Align.Right
	_lSize.nomargin = true
	local _lEntry = fe.add_text( "[ListEntry]",0,0,0,0)
	_lEntry.align = Align.Right
	_lEntry.nomargin = true
	local _pCount = fe.add_text( "[PlayedCount]",0,0,0,0)
	_pCount.align = Align.Right
	_pCount.nomargin = true
	local _timesPlayed = fe.add_text( "times played",0,0,0,0)
	_timesPlayed.align = Align.Right
	_timesPlayed.nomargin = true
	local _pTime = fe.add_text( "[PlayedTime]",0,0,0,0)
	_pTime.align = Align.Right
	_pTime.nomargin = true
	local _dTime = fe.add_text( "",0,0,0,0)
	_dTime.align = Align.Right
	_dTime.nomargin = true
	local _dDate = fe.add_text( "",0,0,0,0)
	_dDate.align = Align.Right
	_dDate.nomargin = true
	_scrlMsg[0] = fe.add_text( "[Name]",0,0,0,0)
	_scrlMsg[0].align = Align.Right
	_scrlMsg[0].nomargin = true
	_scrlMsg[1] = fe.add_text( "[Category]",0,0,0,0)
	_scrlMsg[1].align = Align.Right
	_scrlMsg[1].nomargin = true
	_scrlMsg[2] = fe.add_text( "[!formatMY]",0,0,0,0)
	_scrlMsg[2].align = Align.Right
	_scrlMsg[2].nomargin = true
	_scrlMsg[3] = fe.add_text( "[Extra]",0,0,0,0)
	_scrlMsg[3].align = Align.Right
	_scrlMsg[3].nomargin = true
	local _helpJ = fe.add_image( "", 0, 0, 1920, 1080 )
	_helpJ.visible=false
	local _helpK = fe.add_image( "", 0, 0, 1920, 1080 )
	_helpK.visible=false
	local _scroll = fe.add_text("", 0, 0, 1920, 0) // Invisible box to measure the text size to see if it needs to scroll
	_scroll.align = Align.Right
	_scroll.nomargin = true
	_scroll.visible = false
	local _scrlBar = fe.add_text( "",0,0,0,0)
	_scrlBar.nomargin = true


	local _teste = fe.add_text("",0,0,0,0)

// Custom Overlay Layout
	local mcs = 28
	local overlay_bg = fe.add_image( "images\\Menus.png", 0, 0, 1920, 1080 )
	overlay_bg.visible = false
	local overlay_listbox = fe.add_listbox( 560, 420, 800, 300 )
	overlay_listbox.rows = 6
	overlay_listbox.charsize = mcs
	overlay_listbox.selbg_alpha = 0
	overlay_listbox.set_rgb( 255, 255, 255 )
	overlay_listbox.set_sel_rgb( 87, 49, 249 )
	overlay_listbox.visible = false
	local overlay_label = fe.add_text( "", 560, 360, 800, mcs )
	overlay_label.charsize = mcs
	overlay_label.style = Style.Bold
	overlay_label.set_rgb( 255, 255, 255 ) 
	overlay_label.visible = false
	fe.overlay.set_custom_controls( overlay_label, overlay_listbox )

function transition_callback( ttype, var, ttime )
{
	switch ( ttype )
	{
		case Transition.ShowOverlay:
			overlay_bg.visible = true
			overlay_listbox.visible = true
			overlay_label.visible = true
			break

		case Transition.HideOverlay:
			overlay_bg.visible = false
			overlay_listbox.visible = false
			overlay_label.visible = false
			break

		case Transition.FromOldSelection:
		case Transition.StartLayout:
		case Transition.ToNewList:
			if ( var == 0 || var == 2 ) AdequaDisplay()
			ScrollText()
			FilterColor()
			DashBar()
			ScrollBar()

			LargSel = scmd - scme // Selected width = listbox width
			LargSelGo = true // Start Selected animation
			line = lineMin // first_line_hint line number = min position with offset
			_overview.first_line_hint = line

			// * Test text - above filter name *
			// _teste.msg =  currentDisplay.name // _filter.msg
			// print ( _filter.msg+"\n" )
			// print ( fe.filters.len()+"\n" )
			// for (local f=0; f < fe.filters.len(); f++) {
			// 	print ( fe.filters[f].name+"\n" )
			// }
			// print ( fe.filters[fe.list.filter_index].size+"\n" )

			break

		case Transition.ToNewSelection:
			LargSelGo = false
			_selec.width = scmd - scme
			break
	}
	return false
}
fe.add_transition_callback( "transition_callback" )

function on_signal( signal )
{
	// Cycle media visibility through string 'bitmask' - Snap, Flyer and Overview
	if ( signal == cycleMediaKey ) {
		local artVb = artVa.slice(2,3)
		local artVc = artVa.slice(0,2)
		artVa = artVb + artVc

		ShowSnapOrAlt()
		_flyer.visible = artVa.slice(1,2).tointeger()
		_overview.visible = artVa.slice(2,3).tointeger()
		_overviewOsc.visible = ovo[3] * artVa.slice(2,3).tointeger()
	}

	// The only way I managed to send custom information from Attract Mode to the Emulator.
	if ( signal == altDisplayKey ) {
		if ( hasAlt == true ) {
			if (altLay == "") {
				altLay = "_Alt"
				// Use MOVE to rename Layout_STD.txt
				fe.plugin_command( "cmd", "/c move layouts\\Syskeuomorphic\\Layout_STD.txt layouts\\Syskeuomorphic\\Layout_ALT.txt" )
			} else {
				altLay = ""
				// Use MOVE to rename Layout_ALT.txt
				fe.plugin_command( "cmd", "/c move layouts\\Syskeuomorphic\\Layout_ALT.txt layouts\\Syskeuomorphic\\Layout_STD.txt" )
			}
			ShowSnapOrAlt()
			AdequaDisplay()
			FilterColor()
			ScrollBar()
			_overview.first_line_hint = line
		}
	}

	return false
}
fe.add_signal_handler(this, "on_signal")

function update_realtime( ttime )
{
	// Info text scroll
	for (local f=0; f < 4; f++)
	{
		if (scrollStart[f]) {
			tstop[f] = ttime
			scrollStart[f] = false
		}
		if (go[f] == 1) {
			if (ttime > tstop[f] + ScrlDelay) {
				if ( l2[f] < le[f] + 4 ) {
					l2[f] += ScrlSpeed
					m2[f] = mg[f].slice(l2[f])
					_scrlMsg[f].msg = m2[f]
				}else{
					l2[f] = 0
					tstop[f] = ttime
				}
			}
		}
	}

	// Scroll bar timer
	if ( scrBarGo == true ) {
		scrBarTmr = ttime
		scrBarGo = false
	}
	if ( ttime > scrBarTmr + scrBarDur && _scrlBar.visible == true && scrBarDur < 10000 ) {
		_scrlBar.visible = false
	}

	// Widen selected width
	if ( LargSelGo == true ) {
		LargSel += 10
		_selec.width = LargSel
		if ( LargSel >  tcmd-scme-csp*4 ) LargSelGo = false
	}

	// Time and date
	now = date()
	_dTime.msg = now.hour + ":" + now.min
	_dDate.msg =  month[now.month]+ " " + now.day + ", " + now.year

	// Help screens
	is_down_helpK = fe.get_input_state( keybHelpKey )
	is_down_helpJ = fe.get_input_state( jstkHelpKey )
	_helpK.visible = is_down_helpK
	_helpJ.visible = is_down_helpJ

	// Overview swcroll
	is_PovYposK = fe.get_input_state ( keybOvrvwDown )
	is_PovYposJ = fe.get_input_state ( jstkOvrvwDown )
	if (is_PovYposJ || is_PovYposK) {
		line++
		line > _overview.first_line_hint + lineMin+1 ? (line = _overview.first_line_hint + lineMin+1) : (line)
		_overview.first_line_hint = line
	}

	is_PovYnegK = fe.get_input_state ( keybOvrvwUp )
	is_PovYnegJ = fe.get_input_state ( jstkOvrvwUp )
	if (is_PovYnegJ || is_PovYnegK) {
		line--
		line < lineMin ? (line = lineMin) : (line)
		_overview.first_line_hint = line
	}
}
fe.add_ticks_callback( this, "update_realtime" )

// Conform display to system characteristics and geometry
function AdequaDisplay()
{
	currentDisplay = fe.displays[fe.list.display_index]

	DisplayData()

	if ( hasAlt == true ) {
		bg.file_name = "images\\" + bgimg + altLay + ".png"
	} else {
		bg.file_name = "images\\" + bgimg + ".png"
	}

	_snap.set_pos( snaP[0], snaP[1], snaP[2]-snaP[0], snaP[3]-snaP[1] )
	_altsnap.set_pos( snaP[0], snaP[1], snaP[2]-snaP[0], snaP[3]-snaP[1] )
	_flyer.set_pos( flrP[0], flrP[1], flrP[2]-flrP[0], flrP[3]-flrP[1] )

	_overviewOsc.set_pos( ovrO[0], ovrO[1], ovrO[2], ovrO[3] )
	_overviewOsc.set_bg_rgb( ovo[0], ovo[1], ovo[2] )
	_overviewOsc.visible = ovo[3] * artVa.slice(2,3).tointeger() // Make border invisible if not showing overview

	_overview.set_pos( ovrP[0], ovrP[1], ovrP[2]-ovrP[0], ovrP[3]-ovrP[1] )
	_overview.set_rgb( ovr[0], ovr[1], ovr[2] );
	_overview.set_bg_rgb( ovb[0], ovb[1], ovb[2] );
	_overview.bg_alpha = ovb[3] * 255 // * 255 transforms bol (0,1) into alpha (0,255)
	_overview.font = font
	_overview.charsize = csp
	_overview.align = Align.Left

	_sysName.set_pos( scme, -3*ls+scms, scmd-scme, csg )
	_sysName.set_rgb( lst[0], lst[1], lst[2] )
	_sysName.font = font
	_sysName.charsize = csg
	_sysName.align = Align.Left
	if ( sysName == "default" ) {
		_sysName.msg = currentDisplay.name
	} else {
		_sysName.msg = sysName
	}

	// If system is MSX show dashline
	// TODO: Implement a more versatile routine
	// to accomodate different configs for other systems
	if ( currentDisplay.name == "MSX" ) {
		_dashBar.set_pos( scme, sepo*ls+scms, tcmd, cs )
		_dashBar.set_rgb( sel[0], sel[1], sel[2] )
		_dashBar.font = font
		_dashBar.charsize = cs
		_dashBar.visible = true
	} else {
		_dashBar.visible = false		
	}

	_barra.set_pos( bape, baps, bapd-bape, balt )
	_barra.set_bg_rgb( bar[0], bar[1], bar[2] )
	_barra.visible = bar[3]

	_listbox.set_pos( scme, scms, scmd-scme, scmi-scms )
	_listbox.set_rgb( lst[0], lst[1], lst[2] )
	_listbox.set_sel_rgb( sel[0], sel[1], sel[2] )
	_listbox.sel_alpha = 0
	_listbox.font = font
	_listbox.rows = seti
	_listbox.charsize = cs
	_listbox.selbg_alpha = 0

	_selec.set_pos( scme, sepo*ls+pcms, scmd-scme, cs )
	_selec.set_rgb( sel[0], sel[1], sel[2] )
	_selec.font = font
	_selec.charsize = cs

	_filterBG.set_pos (pcme, baps-(sepo*ls), pcmd-pcme+famd, balt )
	_filterBG.set_bg_rgb( fib[0], fib[1], fib[2] )

	_filter.set_pos( pcme, pcms, pcmd-pcme, cs )
	_filter.set_rgb( fil[0], fil[1], fil[2] )
	_filter.font = font
	_filter.charsize = cs

	_games.set_pos( pcme, pcms+lsp+(cs-csp), pcmd-pcme, csp )
	_games.set_rgb( fil[0], fil[1], fil[2] );
	_games.font = font
	_games.charsize = csp

	_lSize.set_pos( pcme, pcms+(lsp*2)+(cs-csp), pcmd-pcme, csp )
	_lSize.set_rgb( fil[0], fil[1], fil[2] )
	_lSize.font = font
	_lSize.charsize = csp

	_lEntry.set_pos( pcme, sepo*ls+pcms, pcmd-pcme, cs )
	_lEntry.set_rgb( ent[0], ent[1], ent[2] )
	_lEntry.font = font
	_lEntry.charsize = csp

	_pCount.set_pos( tcme, sepo*ls+pcms, tcmd-tcme, cs )
	_pCount.set_rgb( plc[0], plc[1], plc[2] )
	_pCount.font = font
	_pCount.charsize = cs

	_timesPlayed.set_pos( tcme, (sepo+1)*ls+pcms, tcmd-tcme, cs )
	_timesPlayed.set_rgb( lst[0], lst[1], lst[2] )
	_timesPlayed.font = font
	_timesPlayed.charsize = csp

	_pTime.set_pos( tcme, (sepo+1)*ls+pcms+lsp, tcmd-tcme, cs )
	_pTime.set_rgb( lst[0], lst[1], lst[2] )
	_pTime.font = font
	_pTime.charsize = csp

	_dTime.set_pos( tcme, (tipy)*ls+pcms, tcmd-tcme, cs )
	_dTime.set_rgb(  inf[0], inf[1], inf[2] )
	_dTime.font = font
	_dTime.charsize = cs+(cs-csp)

	_dDate.set_pos ( tcme, (tipy)*ls+pcms+ls, tcmd-tcme, csp )
	_dDate.set_rgb(  inf[0], inf[1], inf[2] )
	_dDate.font = font
	_dDate.charsize = csp

	_scrlMsg[0].set_pos( tcme, ((seti-1)*ls+pcms)+(cs-csp)-(lsp*3), tcmd-tcme, csp ) // Name
	_scrlMsg[0].set_rgb( inl[0], inl[1], inl[2] )
	_scrlMsg[0].font = font
	_scrlMsg[0].charsize = csp
	scrlSze[0] = tcmd-tcme

	_scrlMsg[1].set_pos( tcme, ((seti-1)*ls+pcms)+(cs-csp)-(lsp*2), tcmd-tcme, csp ) // Category
	_scrlMsg[1].set_rgb( inl[0], inl[1], inl[2] )
	_scrlMsg[1].font = font
	_scrlMsg[1].charsize = csp
	scrlSze[1] = tcmd-tcme

	_scrlMsg[2].set_pos( tcme, (seti-1)*ls+pcms+(cs-csp)-lsp, tcmd-tcme, csp ) // Copyright
	_scrlMsg[2].set_rgb( inl[0], inl[1], inl[2] )
	_scrlMsg[2].font = font
	_scrlMsg[2].charsize = csp
	scrlSze[2] = tcmd-tcme

	_scrlMsg[3].set_pos( tcme, ((seti-1)*ls+pcms)+(cs-csp), tcmd-tcme, csp ) // Extras
	_scrlMsg[3].set_rgb( inl[0], inl[1], inl[2] )
	_scrlMsg[3].font = font
	_scrlMsg[3].charsize = csp
	scrlSze[3] = tcmd-tcme

	_scrlBar.set_bg_rgb( lst[0], lst[1], lst[2] )
	_scrlBar.bg_alpha = 255

	_helpK.file_name = "images\\" + helpK
	_helpJ.file_name = "images\\" + helpJ

	_teste.set_pos( pcme, scms-cs, pcmd-pcme, cs )
	_teste.set_rgb( fil[0], fil[1], fil[2] )
	_teste.font = font
	_teste.charsize = cs
}

function ScrollBar()
{
	local percVis = (seti.tofloat() / fe.list.size)
	if ( percVis > 0.99 || scrBarDur == -1 ) { //my_config["ShowScrlBar"] == "Yes") {
		_scrlBar.visible = false
	} else {
		scrBarGo = true
		_scrlBar.visible = true
		local barAreaY = scmi-scb[1]-scms-scb[0]
		local barSize = barAreaY * percVis
		local barPos = scms.tofloat()+ scb[0] + fe.list.index * ((barAreaY - barSize) / fe.list.size.tofloat())
		_scrlBar.set_pos( scme + scb[2], barPos, scb[3], barSize )
	}
}

function ScrollText()
{
	mg[0] = fe.game_info(Info.Name)
	mg[1] = fe.game_info(Info.Category)
	mg[2] = FormatMY()
	mg[3] = fe.game_info(Info.Extra)

	for (local f=0; f < 4; f++)
	{
		_scroll.font = font
		_scroll.charsize = csp
		_scroll.msg = mg[f]
		wd = _scroll.msg_width
		le[f] = mg[f].len()
		m2[f] = mg[f]
		mg[f] += " :: " + mg[f]
		l2[f] = 0
		go[f] = 0
		if (scrlSze[f] < wd+cs) {
			go[f] = 1
			_scrlMsg[f].align = Align.Left	
		} else {
			_scrlMsg[f].align = Align.Right	
		}
		scrollStart[f] = true
		_scrlMsg[f].msg = m2[f]
	}
}

// Change firter name color if not the main filter
function FilterColor()
{
	if ( fe.list.filter_index == 0 ) {
		_filterBG.visible = 0
		_filter.set_rgb( fil[0], fil[1], fil[2] )
	} else {
		_filterBG.visible = fib[3]
		_filter.set_rgb( fi2[0], fi2[1], fi2[2] )
	}
}

// How to "-" * x in Squirrel?
function DashBar()
{
	if ( _dashBar.visible == true ) {
		local gt = split( fe.game_info( Info.Title ), "()[]{}" );
		local gc = fe.game_info( Info.PlayedCount );
		local bl = 66 - gt[0].len() - gc.len();
		local bt = "                                                                     ";
		local st = "---------------------------------------------------------------------";
		_dashBar.msg = bt.slice( 0, gt[0].len()+1 ) + st.slice( 0, bl )
	}
}

// Show original or alternate Snap
function ShowSnapOrAlt()
{
	if ( hasAlt == true ) {
		if (altLay == "") {
			_altsnap.visible = false
			_snap.visible = artVa.slice(0,1).tointeger()
		} else {
			_snap.visible = false
			_altsnap.visible = artVa.slice(0,1).tointeger()
		}
	} else {
		_altsnap.visible = false
		_snap.visible = artVa.slice(0,1).tointeger()
	}
}

function FormatMY()
{
	local m = fe.game_info( Info.Manufacturer )
	local y = fe.game_info( Info.Year )

	if (( m.len() > 0 ) && ( y.len() > 0 )) {
		return m + " " + y
	} else if (( m.len() > 0 ))	{
		return m
	} else	{
		return y
	}
	return m.len();
}

// Systems characteristics and geometry
function DisplayData()
{
	switch ( currentDisplay.name )
	{
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

		case "Odyssey2":
			cs  = 16; csp = cs; csg = cs
			ls  = 30; lsp = ls 
			famd = 0
			seti =  24; sepo = floor(seti / 2)
			pcme =   0; pcmd = 160; pcms = 178
			scme = 176; scmd = 690; scms = pcms - 7; scmi = scms + seti * ls
			tcme = 700; tcmd =1170; tipy = -3
			bape = scme; bapd = tcmd + 2; balt = 2
			baps = (sepo) * ls + pcms + 20
			lst = [255, 255, 255]
			fil = [119, 230, 235]
			fi2 = [ 42, 170, 190]
			fib = [  0,   0,   0, 0]
			sel = [198, 184, 106]
			ent = [198, 184, 106]
			plc = [198, 184, 106]
			inf = [ 86, 196, 105]
			inl = [ 86, 196, 105]
			ovr = [255, 255, 255]
			ovb = [  0,   0,   0, 0]
			ovo = [  0,   0,   0, 0]
			bar = [148,  48, 159, 1]
			scb = [  7,   7,  -8, 1]
			snaP = [1227, 69, 1819, 952]
			flrP = [1227, 85, 1819, 910]
			ovrP = [1227, 80, 1819, 910]
			ovrO = [   0,  0,    0,   0]
			lineMin = 36; line = lineMin
			hasAlt = false
			sysName = ""
			font = "Odyssey2 Type New"
			bgimg = "Odyssey2WideFree"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_Odyssey2J.png"
			break

		case "ZX81":
			cs  = 16; csp = cs; csg = cs
			ls  = 19; lsp = ls 
			famd = 4
			seti =  38; sepo = floor(seti / 2)
			pcme =   0; pcmd = 160; pcms = 170
			scme = 176; scmd = 690; scms = pcms - 2; scmi = scms + seti * ls
			tcme = 700; tcmd =1165; tipy = -5
			bape = scme; bapd = tcmd + 4; balt = cs
			baps = (sepo) * ls + pcms + 2
			lst = [  0,   0,   0]
			fil = [  0,   0,   0]
			fi2 = [255, 255, 255]
			fib = [  1,   1,   1, 1]
			sel = [255, 255, 255]
			ent = [  0,   0,   0]
			plc = [255, 255, 255]
			inf = [  0,   0,   0]
			inl = [  0,   0,   0]
			ovr = [  0,   0,   0]
			ovb = [  0,   0,   0, 0]
			ovo = [  0,   0,   0, 0]
			bar = [  1,   1,   1, 1]
			scb = [  2,   2,  -8, 1]
			snaP = [1220,  90, 1828, 902]
			flrP = [1220,  81, 1828, 913]
			ovrP = [1220,  90, 1828, 902]
			ovrO = [   0,   0,    0,   0]
			lineMin = 49; line = lineMin
			hasAlt = false
			sysName = ""
			font = "ZX81 Lower Clean"
			bgimg = "ZX81Wide"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_ZX81J.png"
			break

		case "Vectrex":
			cs  = 16; csp = 11; csg = 25
			ls  = 31; lsp = 22 
			famd = 0
			seti =  23; sepo = floor(seti / 2)
			pcme =  43; pcmd = 162; pcms = 180
			scme = 174; scmd = 690; scms = pcms - 8; scmi = scms + seti * ls
			tcme = 700; tcmd =1160; tipy =  -3.5
			bape = scme; bapd=1162; balt = 1
			baps = (sepo) * ls + pcms + 16
			lst = [161, 225, 245]
			fil = [245, 120, 120]
			fi2 = [255, 150, 150]
			fib = [  0,   0,   0, 0]
			sel = [235, 185, 140]
			ent = [235, 185, 140]
			plc = [235, 185, 140]
			inf = [245, 120, 120]
			inl = [161, 225, 245]
			ovr = [170, 170, 170]
			ovb = [  0,   0,   0, 0]
			ovo = [  0,   0,   0, 0]
			bar = [200, 150,  70, 0]
			scb = [  5,   9,  -8, 1]
			snaP = [1241,153, 1794, 846]
			flrP = [1241,153, 1794, 846]
			ovrP = [1290,215, 1750, 800]
			ovrO = [   0,  0,    0,   0]
			lineMin = 32; line = lineMin
			hasAlt = true
			sysName = ""
			font = "Vectrex Fake Raster"
			bgimg = "VectrexWide"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_Virtual BoyJ.png"
			if (altLay == "_Alt") {
				lst = [170, 170, 170]
				fil = [170, 170, 170]
				fi2 = [255, 255, 255]
				sel = [255, 255, 255]
				ent = [255, 255, 255]
				plc = [255, 255, 255]
				inf = [170, 170, 170]
				inl = [170, 170, 170]
				ovr = [170, 170, 170]
				bar = [170, 170, 170, 1]
				ovrP = [1241,110, 1794, 880]
				lineMin = 42; line = lineMin
			}
			break

		case "TRS Color 2":
			cs  = 24; csp = cs; csg = cs
			ls  = cs; lsp = ls
			famd = 7
			seti =  32; sepo = floor(seti / 2)
			pcme =  40; pcmd = 162; pcms = 172
			scme = 184; scmd = 665; scms = pcms; scmi = scms + seti * ls
			tcme = 665; tcmd =1135; tipy = -3
			bape = scme + 1; bapd = tcmd + 7; balt = 20
			baps = (sepo) * ls + pcms + 7
			lst = [  0,  64,   0]
			fil = [  0,  64,   0]
			fi2 = [  0, 255,   0]
			fib = [  0,  64,   0, 1]
			sel = [  0, 255,   0]
			ent = [  0,  64,   0]
			plc = [  0, 255,   0]
			inf = [  0,  64,   0]
			inl = [  0,  64,   0]
			ovr = [  0, 255,   0]
			ovb = [  0,  64,   0, 1]
			ovo = [  1,   1,   1, 1]
			bar = [  0,  64,   0, 1]
			scb = [  7,   0,  -8, 1]
			snaP = [1231,  90, 1807, 904]
			flrP = [1231,  92, 1807, 900]
			ovrP = [1163,  40, 1880,1040]
			ovrO = [1163,   0, 1920,1080]
			lineMin = 40; line = lineMin
			hasAlt = false
			sysName = ""
			font = "CoCo Lower Clean"
			bgimg = "TRSColor2Split"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_TRS Color 2J.png"
			break

		case "MSX":
			cs  = 18; csp = cs; csg = cs
			ls  = cs; lsp = ls 
			famd = 0
			seti =  42; sepo = floor(seti / 2)
			pcme =  40; pcmd = 164; pcms = 180
			scme = 188; scmd = 665; scms = pcms; scmi = scms + seti * ls
			tcme = 665; tcmd =1140; tipy = -4
			bape = scme; bapd = tcmd; balt = cs
			baps = (sepo) * ls + pcms
			lst = [255, 255, 255]
			fil = [255, 255, 255]
			fi2 = [  1,   1,   1]
			fib = [  0,   0,   0, 0]
			sel = [  1,   1,   1]
			ent = [255, 255, 255]
			plc = [255, 255, 255]
			inf = [255, 255, 255]
			inl = [255, 255, 255]
			ovr = [  1,   1,   1]
			ovb = [204, 204, 204, 1]
			ovo = [204, 204, 204, 1]
			bar = [255, 255, 255, 0]
			scb = [  2,   0, -12, 1]
			snaP = [1225,  90, 1817, 904]
			flrP = [1225,  89, 1817, 904]
			ovrP = [1163,  40, 1880,1040]
			ovrO = [1163,   0, 1920,1080]
			lineMin = 55; line = lineMin
			hasAlt = false
			sysName = ""
			font = "MSX Screen 0 New"
			bgimg = "MSXSplit"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_MSXJ.png"
			break

		case "Amiga":
			cs  = 24; csp = cs; csg = cs
			ls  = 27; lsp = ls
			famd = 0
			seti =  28; sepo = floor(seti / 2)
			pcme =  10; pcmd = 160; pcms = 182
			scme = 184; scmd = 695; scms = pcms - 2; scmi = scms + seti * ls
			tcme = 719; tcmd =1140; tipy = -3
			bape = scme - 2; bapd = tcmd + 4; balt = 24
			baps = (sepo) * ls + pcms + 3
			lst = [  0,   0,   0]
			fil = [  0,   0,   0]
			fi2 = [255, 255, 255]
			fib = [  0,   0,   0, 0]
			sel = [255, 255, 255]
			ent = [  0,   0,   0]
			plc = [255, 255, 255]
			inf = [  0,   0,   0]
			inl = [  0,   0,   0]
			ovr = [  0,   0,   0]
			ovb = [177, 177, 177, 1]
			ovo = [177, 177, 177, 1]
			bar = [106, 142, 195, 1]
			scb = [  2,   4, -10, 1]
			snaP = [1228, 92, 1812, 899]
			flrP = [1228, 92, 1812, 899]
			ovrP = [1163, 40, 1880,1040]
			ovrO = [1163,  0, 1920,1080]
			lineMin = 40; line = lineMin
			hasAlt = false
			sysName = ""
			font = "Amiga 1200"
			bgimg = "AmigaSplit"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_AmigaJ.png"
			break

		case "Virtual Boy":
			cs  = 26; csp = cs; csg = cs
			ls  = 29; lsp = ls 
			famd = 0
			seti =  25; sepo = floor(seti / 2)
			pcme =   0; pcmd = 160; pcms = 160
			scme = 188; scmd = 690; scms = pcms; scmi = scms + seti * ls
			tcme = 700; tcmd =1160; tipy = -3
			bape = scme; bapd = tcmd + 2; balt = 2
			baps = (sepo + 1) * ls + pcms + 2
			lst = [170,   0,   0]
			fil = [170,   0,   0]
			fi2 = [255,   0,   0]
			fib = [  0,   0,   0, 0]
			sel = [255,   0,   0]
			ent = [170,   0,   0]
			plc = [255,   0,   0]
			inf = [170,   0,   0]
			inl = [170,   0,   0]
			ovr = [170,   0,   0]
			ovb = [  0,   0,   0, 0]
			ovo = [  0,   0,   0, 0]
			bar = [ 85,   0,   0, 1]
			scb = [ 20,  -5,  -12, 1]
			snaP = [1227, 69, 1800, 952]
			flrP = [1227, 85, 1800, 910]
			ovrP = [1227, 85, 1800, 880]
			ovrO = [   0,  0,    0,   0]
			lineMin = 28; line = lineMin
			hasAlt = true
			sysName = ""
			font = "PixelOperatorMono-Bold"
			bgimg = "VirtualBoyWide"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_Virtual BoyJ.png"
			if (altLay == "_Alt") {
				lst = [170,   0, 170]
				fil = [170,   0, 170]
				fi2 = [255,   0, 255]
				sel = [255,   0, 255]
				ent = [170,   0, 170]
				plc = [255,   0, 255]
				inf = [170,   0, 170]
				inl = [170,   0, 170]
				ovr = [170,   0, 170]
				bar = [ 85,   0,  85, 1]
			}
			break

		case "Arcade":
			cs  = 26; csp = 18; csg = 75
			ls  = 39; lsp = 20
			famd = 0
			seti =  19; sepo = floor(seti / 2)
			pcme =   0; pcmd = 160; pcms = 160
			scme = 180; scmd = 800; scms = pcms - 7; scmi = scms + seti * ls
			tcme = 810; tcmd =1165; tipy = -2
			bape = scme; bapd = tcmd + 2; balt = 2
			baps = (sepo + 1) * ls + pcms - 9
			lst = [153, 139,  97]
			fil = [153, 139,  97]
			fi2 = [110, 102,  78]
			fib = [  0,   0,   0, 0]
			sel = [  0,   0,   0]
			ent = [153, 139,  97]
			plc = [110, 102,  78]
			inf = [153, 139,  97]
			inl = [110, 102,  78]
			ovr = [  0,   0,   0]
			ovb = [  0,   0,   0, 0]
			ovo = [  0,   0,   0, 0]
			bar = [153, 139,  97, 1]
			scb = [ 10,   6,  -9, 1]
			snaP = [1230, 90, 1808, 902]
			flrP = [1230, 90, 1808, 902]
			ovrP = [1230, 90, 1808, 902]
			ovrO = [   0,  0,    0,   0]
			lineMin = 34; line = lineMin
			hasAlt = false
			sysName = "default"
			font = "Gelasio-Regular"
			bgimg = "SalaBGSkeu"
			helpK = "Help_Keyboard.png"
			helpJ = "Help_ArcadeJ.png"
			break
	}
}

// Framerate
	// local monitor = fe.add_text ("",0,0,fe.layout.width,100)
	// monitor.align = Align.Centre
	// monitor.set_bg_rgb (255,0,0)
	// monitor.charsize = 50

	// local monitor2 = fe.add_text ("",0,0,1,1)
	// local monitor_tick0 = 0
	// local monitor_x0 = 0

	// fe.add_ticks_callback(this,"monitortick")

	// function monitortick(tick_time){
	// 	monitor2.x ++
	// 	if (monitor2.x - monitor_x0 == 10) {
	// 		monitor.msg = 10000/(tick_time - monitor_tick0)
	// 		monitor_tick0 = tick_time
	// 		monitor_x0 = monitor2.x
	// 	}

	// 	if (monitor2.x >= 1080) {
	// 		monitor2.x = 0
	// 		monitor_x0 = 0
	// 		monitor_tick0=0
	// 	}
	// }
