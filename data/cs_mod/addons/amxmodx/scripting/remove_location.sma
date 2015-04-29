/**
*	Plugin removes location from radio messages.
*	They are enabled under both conditions:
*	 enabling of CSBots under CS 1.6 AND when map has location data (it is contained in nav files)
*	It is not supported in CS 1.6 without editing \resource\cstrike_english.txt
*	  (adding string: "Game_radio_location" "%s1 @ %s2 (RADIO): %s3")
*/

#include <amxmodx>

#define PLUGIN "Remove Location from Radio"
#define VERSION "0.1"
#define AUTHOR "Safety1st"

#define print_radio 5	// destination type for TextMsg

public plugin_init() {
	register_plugin( PLUGIN, VERSION, AUTHOR )

	register_message( get_user_msgid("TextMsg"), "MsgTextMsg" )
}

public MsgTextMsg( msgid, dest, receiver ) {
	static szRadioLoc[] = "#Game_radio_location"
	static szRadio[] = "#Game_radio"
	static szText[32]

	#define ARG_DEST_TYPE 1
	#define ARG_PREDEFINED_STRING 3
	#define ARG_LOCATION 5
	#define ARG_RADIOCMD 6

	if( get_msg_arg_int(ARG_DEST_TYPE) != print_radio )
		return

	get_msg_arg_string( ARG_PREDEFINED_STRING, szText, charsmax(szText) )
	if( strcmp( szText, szRadioLoc ) )
		return

	set_msg_arg_string( ARG_PREDEFINED_STRING, szRadio )
	get_msg_arg_string( ARG_RADIOCMD, szText, charsmax(szText) )
	set_msg_arg_string( ARG_LOCATION, szText )
	set_msg_arg_string( ARG_RADIOCMD, "" )
}
