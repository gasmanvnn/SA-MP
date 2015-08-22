
/*
native ShowGKeyPad(playerid,keypadid,match,selectcolor);
native HideGKeyPad(playerid);
*/
#include <a_samp>

#define INVALID_GKEYPAD_MATCH -1
#define INVALID_GKEYPAD_ID	  -1
static Text:GKeyPad[34];
static PlayerText:GPKeyPad[MAX_PLAYERS];
static GKeyPadMatch[MAX_PLAYERS],
		GKeyPadID[MAX_PLAYERS],
		GKeyPadOpened[MAX_PLAYERS],
		GKeyPadValue[MAX_PLAYERS],GKeyPadCNum[MAX_PLAYERS][6],GKeyPadCount[MAX_PLAYERS];
forward OnPlayerEnterGKeyPad(playerid,success,keypadid,value,match);
/********Hook function**********/

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("[G]Keypad by Gasman");
	print("--------------------------------------\n");
	LoadGKeyPadTextDraw();
	#if defined gkp_OnFilterScriptInit
		return gkp_OnFilterScriptInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnFilterScriptInit
	#undef OnFilterScriptInit
#else
	#define _ALS_OnFilterScriptInit
#endif
 
#define OnFilterScriptInit gkp_OnFilterScriptInit
#if defined gkp_OnFilterScriptInit
	forward gkp_OnFilterScriptInit();
#endif

#else

public OnGameModeInit()
{
	print("\n--------------------------------------");
	print("[G]Keypad by Gasman");
	print("--------------------------------------\n");
	LoadGKeyPadTextDraw();
	#if defined gkp_OnGameModeInit
		return gkp_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
 
#define OnGameModeInit gkp_OnGameModeInit
#if defined gkp_OnGameModeInit
	forward gkp_OnGameModeInit();
#endif

#endif

public OnPlayerConnect(playerid)
{
	GKeyPadMatch[playerid] = INVALID_GKEYPAD_MATCH;
	GKeyPadID[playerid] = INVALID_GKEYPAD_ID;
	GKeyPadOpened[playerid] = 0;
	GKeyPadValue[playerid] = 000000;
	GKeyPadCount[playerid] = 0;
	for(new i =0;i<6;i++)GKeyPadCNum[playerid][i]=0;
	GPKeyPad[playerid] = CreatePlayerTextDraw(playerid,562.000000, 285.000000, "000000");
	PlayerTextDrawAlignment(playerid,GPKeyPad[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid,GPKeyPad[playerid], 0);
	PlayerTextDrawFont(playerid,GPKeyPad[playerid], 2);
	PlayerTextDrawLetterSize(playerid,GPKeyPad[playerid], 0.260000, 1.200000);
	PlayerTextDrawColor(playerid,GPKeyPad[playerid], -2139062017);//255);
	PlayerTextDrawSetOutline(playerid,GPKeyPad[playerid], 0);
	PlayerTextDrawSetProportional(playerid,GPKeyPad[playerid], 1);
	PlayerTextDrawSetShadow(playerid,GPKeyPad[playerid], 1);

	#if defined gkp_OnPlayerConnect
		return gkp_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
 
#define OnPlayerConnect gkp_OnPlayerConnect
#if defined gkp_OnPlayerConnect
	forward gkp_OnPlayerConnect(playerid);
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == GKeyPad[33])
		HideGKeyPad(playerid);
	if(clickedid == GKeyPad[31])
		GKeyPadEnter(playerid);
	if(clickedid == GKeyPad[32])
		GKeypadRemoveNumber(playerid);
	if(clickedid == GKeyPad[21])
		GKeypadAddNumber(playerid,1);
	if(clickedid == GKeyPad[22])
		GKeypadAddNumber(playerid,2);
	if(clickedid == GKeyPad[23])
		GKeypadAddNumber(playerid,3);
	if(clickedid == GKeyPad[24])
		GKeypadAddNumber(playerid,4);
	if(clickedid == GKeyPad[25])
		GKeypadAddNumber(playerid,5);
	if(clickedid == GKeyPad[26])
		GKeypadAddNumber(playerid,6);
	if(clickedid == GKeyPad[27])
		GKeypadAddNumber(playerid,7);
	if(clickedid == GKeyPad[28])
		GKeypadAddNumber(playerid,8);
	if(clickedid == GKeyPad[29])
		GKeypadAddNumber(playerid,9);
	if(clickedid == GKeyPad[30])
		GKeypadAddNumber(playerid,0);
	#if defined gkp_OnPlayerClickTextDraw
		return gkp_OnPlayerClickTextDraw(playerid, _:clickedid)
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
 
#define OnPlayerClickTextDraw gkp_OnPlayerClickTextDraw
#if defined gkp_OnPlayerClickTextDraw
	forward gkp_OnPlayerClickTextDraw(playerid, _:clickedid)
#endif
/**************************STOCK**************************/
stock ShowGKeyPad(playerid,keypadid,match,selectcolor=-1)
{
	if(match > 999999 || match < 0)
	{
		printf("[GKeyPad]:Error Match max value (%d) keypad id %d",match,keypadid);
		return 0;
	}
	for(new i =0;i<34;i++)
	{
	    TextDrawShowForPlayer(playerid,GKeyPad[i]);
	}
	PlayerTextDrawSetString(playerid,GPKeyPad[playerid],"000000");
	PlayerTextDrawShow(playerid,GPKeyPad[playerid]);
	PlayerTextDrawShow(playerid,GPKeyPad[playerid]);
	GKeyPadMatch[playerid] = match;
	GKeyPadID[playerid] = keypadid;
	GKeyPadValue[playerid] = 000000;
	GKeyPadOpened[playerid] = 1;
	GKeyPadCount[playerid] = 0;
	SelectTextDraw(playerid,selectcolor);
	return 1;
}
stock HideGKeyPad(playerid)
{
	for(new i =0;i<34;i++)
	{
	    TextDrawHideForPlayer(playerid,GKeyPad[i]);
	}
	PlayerTextDrawHide(playerid,GPKeyPad[playerid]);
	GKeyPadMatch[playerid] = INVALID_GKEYPAD_MATCH;
	GKeyPadID[playerid] = INVALID_GKEYPAD_ID;
	GKeyPadValue[playerid] = 000000;
	GKeyPadOpened[playerid] = 0;
	GKeyPadCount[playerid] = 0;
	CancelSelectTextDraw(playerid);
	return 1;
}
static stock GKeyPadEnter(playerid)
{
	new stn1[10],stn2[10];
	if(GKeyPadValue[playerid] == GKeyPadMatch[playerid])
	{
		format(stn1,sizeof(stn1),"%06d",GKeyPadValue[playerid]);
		format(stn2,sizeof(stn2),"%06d",GKeyPadMatch[playerid]);
		CallLocalFunction("OnPlayerEnterGKeyPad", "ddddd", playerid, 1,GKeyPadID[playerid],strval(stn1),strval(stn2));
		HideGKeyPad(playerid);
	}
	else
	{
		format(stn1,sizeof(stn1),"%06d",GKeyPadValue[playerid]);
		format(stn2,sizeof(stn2),"%06d",GKeyPadMatch[playerid]);
		CallLocalFunction("OnPlayerEnterGKeyPad", "ddddd", playerid, 0,GKeyPadID[playerid],strval(stn1),strval(stn2));
		GKeyPadValue[playerid] = 000000;
		GKeyPadCount[playerid] = 0;
		for(new i =0;i<6;i++)GKeyPadCNum[playerid][i]=0;
		GKeypadUpdateDisplay(playerid);
	}
	return 1;
}
static stock GKeypadAddNumber(playerid,number)
{
	if(GKeyPadValue[playerid] >= 99999)
		return 0;
	GKeyPadCNum[playerid][GKeyPadCount[playerid]] = GKeyPadValue[playerid];
	GKeyPadCount[playerid]++;
	GKeyPadValue[playerid] = (GKeyPadValue[playerid] * 10) + number;
	
	GKeypadUpdateDisplay(playerid);
	return 1;
}
static stock GKeypadRemoveNumber(playerid)
{	
	if(GKeyPadCount[playerid] <= 0)
		return 0;
	GKeyPadCount[playerid]--;
	GKeyPadValue[playerid] = GKeyPadCNum[playerid][GKeyPadCount[playerid]];
	
	GKeypadUpdateDisplay(playerid);
	return 1;
}
static GKeypadUpdateDisplay(playerid)
{
	new str[10];
	format(str,sizeof(str), "%06d", GKeyPadValue[playerid]);
	PlayerTextDrawSetString(playerid,GPKeyPad[playerid],str);
	PlayerTextDrawShow(playerid,GPKeyPad[playerid]);
	return 1;
}
stock IsGKeyPadOpened(playerid) if(GKeyPadOpened[playerid] == 1) return 1;else return 0;

static stock LoadGKeyPadTextDraw()
{
	GKeyPad[0] = TextDrawCreate(606.000000, 273.000000, "_");
	TextDrawBackgroundColor(GKeyPad[0], 255);
	TextDrawFont(GKeyPad[0], 1);
	TextDrawLetterSize(GKeyPad[0], 0.500000, 15.500005);
	TextDrawColor(GKeyPad[0], 255);
	TextDrawSetOutline(GKeyPad[0], 0);
	TextDrawSetProportional(GKeyPad[0], 1);
	TextDrawSetShadow(GKeyPad[0], 1);
	TextDrawUseBox(GKeyPad[0], 1);
	TextDrawBoxColor(GKeyPad[0], 255);
	TextDrawTextSize(GKeyPad[0], 520.000000, 0.000000);
	TextDrawSetSelectable(GKeyPad[0], 0);

	GKeyPad[1] = TextDrawCreate(518.000000, 265.000000, "LD_DRV:tvcorn");
	TextDrawBackgroundColor(GKeyPad[1], 255);
	TextDrawFont(GKeyPad[1], 4);
	TextDrawLetterSize(GKeyPad[1], 0.500000, 1.000000);
	TextDrawColor(GKeyPad[1], -1);
	TextDrawSetOutline(GKeyPad[1], 0);
	TextDrawSetProportional(GKeyPad[1], 1);
	TextDrawSetShadow(GKeyPad[1], 1);
	TextDrawUseBox(GKeyPad[1], 1);
	TextDrawBoxColor(GKeyPad[1], 255);
	TextDrawTextSize(GKeyPad[1], 50.000000, 80.000000);
	TextDrawSetSelectable(GKeyPad[1], 0);

	GKeyPad[2] = TextDrawCreate(608.000000, 265.000000, "LD_DRV:tvcorn");
	TextDrawBackgroundColor(GKeyPad[2], 255);
	TextDrawFont(GKeyPad[2], 4);
	TextDrawLetterSize(GKeyPad[2], 0.500000, 1.000000);
	TextDrawColor(GKeyPad[2], -1);
	TextDrawSetOutline(GKeyPad[2], 0);
	TextDrawSetProportional(GKeyPad[2], 1);
	TextDrawSetShadow(GKeyPad[2], 1);
	TextDrawUseBox(GKeyPad[2], 1);
	TextDrawBoxColor(GKeyPad[2], 255);
	TextDrawTextSize(GKeyPad[2], -50.000000, 84.000000);
	TextDrawSetSelectable(GKeyPad[2], 0);

	GKeyPad[3] = TextDrawCreate(608.000000, 415.000000, "LD_DRV:tvcorn");
	TextDrawBackgroundColor(GKeyPad[3], 255);
	TextDrawFont(GKeyPad[3], 4);
	TextDrawLetterSize(GKeyPad[3], 0.500000, 1.000000);
	TextDrawColor(GKeyPad[3], -1);
	TextDrawSetOutline(GKeyPad[3], 0);
	TextDrawSetProportional(GKeyPad[3], 1);
	TextDrawSetShadow(GKeyPad[3], 1);
	TextDrawUseBox(GKeyPad[3], 1);
	TextDrawBoxColor(GKeyPad[3], 255);
	TextDrawTextSize(GKeyPad[3], -50.000000, -81.000000);
	TextDrawSetSelectable(GKeyPad[3], 0);

	GKeyPad[4] = TextDrawCreate(518.000000, 415.000000, "LD_DRV:tvcorn");
	TextDrawBackgroundColor(GKeyPad[4], 255);
	TextDrawFont(GKeyPad[4], 4);
	TextDrawLetterSize(GKeyPad[4], 0.500000, 1.000000);
	TextDrawColor(GKeyPad[4], -1);
	TextDrawSetOutline(GKeyPad[4], 0);
	TextDrawSetProportional(GKeyPad[4], 1);
	TextDrawSetShadow(GKeyPad[4], 1);
	TextDrawUseBox(GKeyPad[4], 1);
	TextDrawBoxColor(GKeyPad[4], 255);
	TextDrawTextSize(GKeyPad[4], 50.000000, -81.000000);
	TextDrawSetSelectable(GKeyPad[4], 0);

	GKeyPad[5] = TextDrawCreate(561.000000, 273.000000, "GPad");
	TextDrawAlignment(GKeyPad[5], 2);
	TextDrawBackgroundColor(GKeyPad[5], 255);
	TextDrawFont(GKeyPad[5], 2);
	TextDrawLetterSize(GKeyPad[5], 0.250000, 0.799998);
	TextDrawColor(GKeyPad[5], -1);
	TextDrawSetOutline(GKeyPad[5], 0);
	TextDrawSetProportional(GKeyPad[5], 1);
	TextDrawSetShadow(GKeyPad[5], 1);
	TextDrawSetSelectable(GKeyPad[5], 0);

	GKeyPad[6] = TextDrawCreate(526.000000, 300.000000, "-");
	TextDrawBackgroundColor(GKeyPad[6], 255);
	TextDrawFont(GKeyPad[6], 1);
	TextDrawLetterSize(GKeyPad[6], 5.099997, 0.699998);
	TextDrawColor(GKeyPad[6], -1);
	TextDrawSetOutline(GKeyPad[6], 0);
	TextDrawSetProportional(GKeyPad[6], 1);
	TextDrawSetShadow(GKeyPad[6], 1);
	TextDrawSetSelectable(GKeyPad[6], 0);

	GKeyPad[7] = TextDrawCreate(525.000000, 240.000000, "-");
	TextDrawBackgroundColor(GKeyPad[7], -2139062017);
	TextDrawFont(GKeyPad[7], 1);
	TextDrawLetterSize(GKeyPad[7], 5.209994, 9.000000);
	TextDrawColor(GKeyPad[7], 255);
	TextDrawSetOutline(GKeyPad[7], 1);
	TextDrawSetProportional(GKeyPad[7], 1);
	TextDrawSetSelectable(GKeyPad[7], 0);


	GKeyPad[8] = TextDrawCreate(537.000000, 268.000000, "-");
	TextDrawAlignment(GKeyPad[8], 2);
	TextDrawBackgroundColor(GKeyPad[8], -2139062017);
	TextDrawFont(GKeyPad[8], 2);
	TextDrawLetterSize(GKeyPad[8], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[8], 255);
	TextDrawSetOutline(GKeyPad[8], 1);
	TextDrawSetProportional(GKeyPad[8], 1);
	TextDrawSetSelectable(GKeyPad[8], 0);

	GKeyPad[9] = TextDrawCreate(563.000000, 268.000000, "-");
	TextDrawAlignment(GKeyPad[9], 2);
	TextDrawBackgroundColor(GKeyPad[9], -2139062017);
	TextDrawFont(GKeyPad[9], 2);
	TextDrawLetterSize(GKeyPad[9], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[9], 255);
	TextDrawSetOutline(GKeyPad[9], 1);
	TextDrawSetProportional(GKeyPad[9], 1);
	TextDrawSetSelectable(GKeyPad[9], 0);

	GKeyPad[10] = TextDrawCreate(589.000000, 268.000000, "-");
	TextDrawAlignment(GKeyPad[10], 2);
	TextDrawBackgroundColor(GKeyPad[10], -2139062017);
	TextDrawFont(GKeyPad[10], 2);
	TextDrawLetterSize(GKeyPad[10], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[10], 255);
	TextDrawSetOutline(GKeyPad[10], 1);
	TextDrawSetProportional(GKeyPad[10], 1);
	TextDrawSetSelectable(GKeyPad[10], 0);

	GKeyPad[11] = TextDrawCreate(537.000000, 292.000000, "-");
	TextDrawAlignment(GKeyPad[11], 2);
	TextDrawBackgroundColor(GKeyPad[11], -2139062017);
	TextDrawFont(GKeyPad[11], 2);
	TextDrawLetterSize(GKeyPad[11], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[11], 255);
	TextDrawSetOutline(GKeyPad[11], 1);
	TextDrawSetProportional(GKeyPad[11], 1);
	TextDrawSetSelectable(GKeyPad[11], 0);

	GKeyPad[12] = TextDrawCreate(563.000000, 292.000000, "-");
	TextDrawAlignment(GKeyPad[12], 2);
	TextDrawBackgroundColor(GKeyPad[12], -2139062017);
	TextDrawFont(GKeyPad[12], 2);
	TextDrawLetterSize(GKeyPad[12], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[12], 255);
	TextDrawSetOutline(GKeyPad[12], 1);
	TextDrawSetProportional(GKeyPad[12], 1);
	TextDrawSetSelectable(GKeyPad[12], 0);

	GKeyPad[13] = TextDrawCreate(589.000000, 292.000000, "-");
	TextDrawAlignment(GKeyPad[13], 2);
	TextDrawBackgroundColor(GKeyPad[13], -2139062017);
	TextDrawFont(GKeyPad[13], 2);
	TextDrawLetterSize(GKeyPad[13], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[13], 255);
	TextDrawSetOutline(GKeyPad[13], 1);
	TextDrawSetProportional(GKeyPad[13], 1);
	TextDrawSetSelectable(GKeyPad[13], 0);

	GKeyPad[14] = TextDrawCreate(537.000000, 316.000000, "-");
	TextDrawAlignment(GKeyPad[14], 2);
	TextDrawBackgroundColor(GKeyPad[14], -2139062017);
	TextDrawFont(GKeyPad[14], 2);
	TextDrawLetterSize(GKeyPad[14], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[14], 255);
	TextDrawSetOutline(GKeyPad[14], 1);
	TextDrawSetProportional(GKeyPad[14], 1);
	TextDrawSetSelectable(GKeyPad[14], 0);

	GKeyPad[15] = TextDrawCreate(563.000000, 316.000000, "-");
	TextDrawAlignment(GKeyPad[15], 2);
	TextDrawBackgroundColor(GKeyPad[15], -2139062017);
	TextDrawFont(GKeyPad[15], 2);
	TextDrawLetterSize(GKeyPad[15], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[15], 255);
	TextDrawSetOutline(GKeyPad[15], 1);
	TextDrawSetProportional(GKeyPad[15], 1);
	TextDrawSetSelectable(GKeyPad[15], 0);

	GKeyPad[16] = TextDrawCreate(589.000000, 316.000000, "-");
	TextDrawAlignment(GKeyPad[16], 2);
	TextDrawBackgroundColor(GKeyPad[16], -2139062017);
	TextDrawFont(GKeyPad[16], 2);
	TextDrawLetterSize(GKeyPad[16], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[16], 255);
	TextDrawSetOutline(GKeyPad[16], 1);
	TextDrawSetProportional(GKeyPad[16], 1);
	TextDrawSetSelectable(GKeyPad[16], 0);

	GKeyPad[17] = TextDrawCreate(537.000000, 340.000000, "-");
	TextDrawAlignment(GKeyPad[17], 2);
	TextDrawBackgroundColor(GKeyPad[17], -2139062017);
	TextDrawFont(GKeyPad[17], 2);
	TextDrawLetterSize(GKeyPad[17], 1.900000, 10.000000);
	TextDrawColor(GKeyPad[17], 255);
	TextDrawSetOutline(GKeyPad[17], 1);
	TextDrawSetProportional(GKeyPad[17], 1);
	TextDrawSetSelectable(GKeyPad[17], 0);

	GKeyPad[18] = TextDrawCreate(563.000000, 340.000000, "-");
	TextDrawAlignment(GKeyPad[18], 2);
	TextDrawBackgroundColor(GKeyPad[18], -2139062017);
	TextDrawFont(GKeyPad[18], 2);
	TextDrawLetterSize(GKeyPad[18], 1.360000, 10.000000);
	TextDrawColor(GKeyPad[18], 255);
	TextDrawSetOutline(GKeyPad[18], 1);
	TextDrawSetProportional(GKeyPad[18], 1);
	TextDrawSetSelectable(GKeyPad[18], 0);

	GKeyPad[19] = TextDrawCreate(589.000000, 340.000000, "-");
	TextDrawAlignment(GKeyPad[19], 2);
	TextDrawBackgroundColor(GKeyPad[19], -2139062017);
	TextDrawFont(GKeyPad[19], 2);
	TextDrawLetterSize(GKeyPad[19], 2.000000, 10.000000);
	TextDrawColor(GKeyPad[19], 255);
	TextDrawSetOutline(GKeyPad[19], 1);
	TextDrawSetProportional(GKeyPad[19], 1);
	TextDrawSetSelectable(GKeyPad[19], 0);

	GKeyPad[20] = TextDrawCreate(563.000000, 358.000000, "-");
	TextDrawAlignment(GKeyPad[20], 2);
	TextDrawBackgroundColor(GKeyPad[20], -2139062017);
	TextDrawFont(GKeyPad[20], 2);
	TextDrawLetterSize(GKeyPad[20], 1.400000, 10.000000);
	TextDrawColor(GKeyPad[20], 255);
	TextDrawSetOutline(GKeyPad[20], 1);
	TextDrawSetProportional(GKeyPad[20], 1);
	TextDrawSetSelectable(GKeyPad[20], 0);

	GKeyPad[21] = TextDrawCreate(536.500000, 313.000000, "1");
	TextDrawAlignment(GKeyPad[21], 2);
	TextDrawBackgroundColor(GKeyPad[21], 255);
	TextDrawFont(GKeyPad[21], 2);
	TextDrawLetterSize(GKeyPad[21], 0.500000, 1.000000);
	TextDrawColor(GKeyPad[21], -2139062017);
	TextDrawSetOutline(GKeyPad[21], 0);
	TextDrawSetProportional(GKeyPad[21], 1);
	TextDrawSetShadow(GKeyPad[21], 1);
	TextDrawUseBox(GKeyPad[21], 1);
	TextDrawBoxColor(GKeyPad[21], 0);
	TextDrawTextSize(GKeyPad[21], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[21], 1);

	GKeyPad[22] = TextDrawCreate(562.500000, 313.000000, "2");
	TextDrawAlignment(GKeyPad[22], 2);
	TextDrawBackgroundColor(GKeyPad[22], 255);
	TextDrawFont(GKeyPad[22], 2);
	TextDrawLetterSize(GKeyPad[22], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[22], -2139062017);
	TextDrawSetOutline(GKeyPad[22], 0);
	TextDrawSetProportional(GKeyPad[22], 1);
	TextDrawSetShadow(GKeyPad[22], 1);
	TextDrawUseBox(GKeyPad[22], 1);
	TextDrawBoxColor(GKeyPad[22], 0);
	TextDrawTextSize(GKeyPad[22], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[22], 1);

	GKeyPad[23] = TextDrawCreate(588.500000, 313.000000, "3");
	TextDrawAlignment(GKeyPad[23], 2);
	TextDrawBackgroundColor(GKeyPad[23], 255);
	TextDrawFont(GKeyPad[23], 2);
	TextDrawLetterSize(GKeyPad[23], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[23], -2139062017);
	TextDrawSetOutline(GKeyPad[23], 0);
	TextDrawSetProportional(GKeyPad[23], 1);
	TextDrawSetShadow(GKeyPad[23], 1);
	TextDrawUseBox(GKeyPad[23], 1);
	TextDrawBoxColor(GKeyPad[23], 0);
	TextDrawTextSize(GKeyPad[23], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[23], 1);

	GKeyPad[24] = TextDrawCreate(536.500000, 337.000000, "4");
	TextDrawAlignment(GKeyPad[24], 2);
	TextDrawBackgroundColor(GKeyPad[24], 255);
	TextDrawFont(GKeyPad[24], 2);
	TextDrawLetterSize(GKeyPad[24], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[24], -2139062017);
	TextDrawSetOutline(GKeyPad[24], 0);
	TextDrawSetProportional(GKeyPad[24], 1);
	TextDrawSetShadow(GKeyPad[24], 1);
	TextDrawUseBox(GKeyPad[24], 1);
	TextDrawBoxColor(GKeyPad[24], 0);
	TextDrawTextSize(GKeyPad[24], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[24], 1);

	GKeyPad[25] = TextDrawCreate(562.500000, 337.000000, "5");
	TextDrawAlignment(GKeyPad[25], 2);
	TextDrawBackgroundColor(GKeyPad[25], 255);
	TextDrawFont(GKeyPad[25], 2);
	TextDrawLetterSize(GKeyPad[25], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[25], -2139062017);
	TextDrawSetOutline(GKeyPad[25], 0);
	TextDrawSetProportional(GKeyPad[25], 1);
	TextDrawSetShadow(GKeyPad[25], 1);
	TextDrawUseBox(GKeyPad[25], 1);
	TextDrawBoxColor(GKeyPad[25], 0);
	TextDrawTextSize(GKeyPad[25], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[25], 1);

	GKeyPad[26] = TextDrawCreate(588.500000, 337.000000, "6");
	TextDrawAlignment(GKeyPad[26], 2);
	TextDrawBackgroundColor(GKeyPad[26], 255);
	TextDrawFont(GKeyPad[26], 2);
	TextDrawLetterSize(GKeyPad[26], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[26], -2139062017);
	TextDrawSetOutline(GKeyPad[26], 0);
	TextDrawSetProportional(GKeyPad[26], 1);
	TextDrawSetShadow(GKeyPad[26], 1);
	TextDrawUseBox(GKeyPad[26], 1);
	TextDrawBoxColor(GKeyPad[26], 0);
	TextDrawTextSize(GKeyPad[26], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[26], 1);

	GKeyPad[27] = TextDrawCreate(536.500000, 361.000000, "7");
	TextDrawAlignment(GKeyPad[27], 2);
	TextDrawBackgroundColor(GKeyPad[27], 255);
	TextDrawFont(GKeyPad[27], 2);
	TextDrawLetterSize(GKeyPad[27], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[27], -2139062017);
	TextDrawSetOutline(GKeyPad[27], 0);
	TextDrawSetProportional(GKeyPad[27], 1);
	TextDrawSetShadow(GKeyPad[27], 1);
	TextDrawUseBox(GKeyPad[27], 1);
	TextDrawBoxColor(GKeyPad[27], 0);
	TextDrawTextSize(GKeyPad[27], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[27], 1);

	GKeyPad[28] = TextDrawCreate(562.500000, 361.000000, "8");
	TextDrawAlignment(GKeyPad[28], 2);
	TextDrawBackgroundColor(GKeyPad[28], 255);
	TextDrawFont(GKeyPad[28], 2);
	TextDrawLetterSize(GKeyPad[28], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[28], -2139062017);
	TextDrawSetOutline(GKeyPad[28], 0);
	TextDrawSetProportional(GKeyPad[28], 1);
	TextDrawSetShadow(GKeyPad[28], 1);
	TextDrawUseBox(GKeyPad[28], 1);
	TextDrawBoxColor(GKeyPad[28], 0);
	TextDrawTextSize(GKeyPad[28], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[28], 1);

	GKeyPad[29] = TextDrawCreate(588.500000, 361.000000, "9");
	TextDrawAlignment(GKeyPad[29], 2);
	TextDrawBackgroundColor(GKeyPad[29], 255);
	TextDrawFont(GKeyPad[29], 2);
	TextDrawLetterSize(GKeyPad[29], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[29], -2139062017);
	TextDrawSetOutline(GKeyPad[29], 0);
	TextDrawSetProportional(GKeyPad[29], 1);
	TextDrawSetShadow(GKeyPad[29], 1);
	TextDrawUseBox(GKeyPad[29], 1);
	TextDrawBoxColor(GKeyPad[29], 0);
	TextDrawTextSize(GKeyPad[29], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[29], 1);

	GKeyPad[30] = TextDrawCreate(562.500000, 385.000000, "0");
	TextDrawAlignment(GKeyPad[30], 2);
	TextDrawBackgroundColor(GKeyPad[30], 255);
	TextDrawFont(GKeyPad[30], 2);
	TextDrawLetterSize(GKeyPad[30], 0.290000, 1.000000);
	TextDrawColor(GKeyPad[30], -2139062017);
	TextDrawSetOutline(GKeyPad[30], 0);
	TextDrawSetProportional(GKeyPad[30], 1);
	TextDrawSetShadow(GKeyPad[30], 1);
	TextDrawUseBox(GKeyPad[30], 1);
	TextDrawBoxColor(GKeyPad[30], 0);
	TextDrawTextSize(GKeyPad[30], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[30], 1);

	GKeyPad[31] = TextDrawCreate(536.500000, 386.000000, "OK");
	TextDrawAlignment(GKeyPad[31], 2);
	TextDrawBackgroundColor(GKeyPad[31], 255);
	TextDrawFont(GKeyPad[31], 2);
	TextDrawLetterSize(GKeyPad[31], 0.190000, 0.899999);
	TextDrawColor(GKeyPad[31], -2139062017);
	TextDrawSetOutline(GKeyPad[31], 1);
	TextDrawSetProportional(GKeyPad[31], 1);
	TextDrawUseBox(GKeyPad[31], 1);
	TextDrawBoxColor(GKeyPad[31], 0);
	TextDrawTextSize(GKeyPad[31], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[31], 1);

	GKeyPad[32] = TextDrawCreate(588.500000, 386.000000, "DEL");
	TextDrawAlignment(GKeyPad[32], 2);
	TextDrawBackgroundColor(GKeyPad[32], 255);
	TextDrawFont(GKeyPad[32], 2);
	TextDrawLetterSize(GKeyPad[32], 0.170000, 0.899999);
	TextDrawColor(GKeyPad[32], -2139062017);
	TextDrawSetOutline(GKeyPad[32], 1);
	TextDrawSetProportional(GKeyPad[32], 1);
	TextDrawUseBox(GKeyPad[32], 1);
	TextDrawBoxColor(GKeyPad[32], 0);
	TextDrawTextSize(GKeyPad[32], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[32], 1);

	GKeyPad[33] = TextDrawCreate(562.500000, 403.000000, "X");
	TextDrawAlignment(GKeyPad[33], 2);
	TextDrawBackgroundColor(GKeyPad[33], 255);
	TextDrawFont(GKeyPad[33], 2);
	TextDrawLetterSize(GKeyPad[33], 0.170000, 0.899999);
	TextDrawColor(GKeyPad[33], -2139062017);
	TextDrawSetOutline(GKeyPad[33], 1);
	TextDrawSetProportional(GKeyPad[33], 1);
	TextDrawUseBox(GKeyPad[33], 1);
	TextDrawBoxColor(GKeyPad[33], 0);
	TextDrawTextSize(GKeyPad[33], 10.000000, 10.000000);
	TextDrawSetSelectable(GKeyPad[33], 1);
	return 1;
}
