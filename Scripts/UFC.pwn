/*
	[UFC]
	Ultimate Fighting Championship
	 ****************************
	 Credits - License:
	 Y_Less
	 Mauzen
	 Emmet_
	 ZeeX
	 Incognito,
	 ****************************
	 Specical thank
	 Pottus for Texture Studio
	 ****************************
	 Author Gasman
	 ****************************
	 Change Log:
	 Version 1: Release
	 Version 1.1:
	 -Random Boxes Name,
	 -Random Skin,
	 -Fix Fighting Pos,
	 Version 1.2:
	 -Combo System
	 -KnockOut
	 -Bug Pos Fixed
	 ****************************
	 COMMAND:
	 /ufc [bar,bet]
	 /ufcwave
	 /ufccheer
	 ****************************
	 
*/
#include <a_samp>
#include <sscanf2>
#include <rnpc>
#include <e_actor>
#include <easydialog>
#include <zcmd>
#include <color>
#include <streamer>
#define Callback%0(%1) forward%0(%1);\
						public%0(%1)
new fighterskin[]=
{
	18,45,80,81,96,97,146,154,203,204,252,293
	
};
new fightername[][]=
{
	"Cung Lê",
	"Brock Lesnar",
	"Vitor Belfort",
	"Jen Pulver",
	"Forrest Griffin",
	"Urijah Faber",
	"Benson Henderson",
	"Jose Aldo",
	"Shogun Rua",
	"Wanderlei Silva",
	"Rashad Evans",
	"Bas Rutten",
	"Dan Serven",
	"Cain Velasquez",
	"Lyoto Machida"
};
enum ufc
{
	Fighter[2],
	FighterHP[2],
	FighterAName[64],
	FighterBName[64],
	Text3D:FighterTextName[2],
	Text3D:FighterTextHP[2],
	ActorBar,
	ActorMC,
	ActorDJ,
	Text3D:ActorBarText,
	Text3D:ActorMCText,
	Text3D:ActorDJText,
	Dead,
	Start,
	nMove,
	cBet,
	Count = 3600000,
}
new UFC[ufc];
new UFCBetFighter[MAX_PLAYERS];
new UFCBetMoney[MAX_PLAYERS];
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Ultimate Fighting Championship");
	print("--------------------------------------\n");
	
	
	
	UFC[ActorBar] = CreateActor(292,2286.6392,-1705.6304,17.6016,91.9012);
	UFC[ActorBarText] = Attach3DTextLabelToActor(UFC[ActorBar],""COL_GREEN"Nguyen Nhat\n"COL_YELLOW"[Bartender-Beting]\n{/ufc}", -1, 0,0,0.3);
	UFC[ActorMC] = CreateActor(246,2258.8162,-1719.2513,18.6740,286.4689);
	UFC[ActorMCText] = Attach3DTextLabelToActor(UFC[ActorMC],""COL_GREEN"Linda\n"COL_YELLOW"[MC]", -1, 0,0,0.3);
	UFC[ActorDJ] = CreateActor(19,2262.7939,-1720.2301,17.6016,5.0721);
	UFC[ActorDJText] = Attach3DTextLabelToActor(UFC[ActorDJ],""COL_GREEN"A-Track\n"COL_YELLOW"[DJ]", -1, 0,0,0.3);
	SetActorInvulnerable(UFC[ActorBar]);
	SetActorInvulnerable(UFC[ActorMC]);
	SetActorInvulnerable(UFC[ActorDJ]);
	SetTimer("UFCResync",60000,1);
	SetTimer("UFCTime",1000,1);
	UFCMAP();
	UFCResync();
	return 1;
}
public OnPlayerConnect(playerid)
{
    UFCBetMoney[playerid] = 0;
    UFCBetFighter[playerid] = 3;
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid))
	{
	    if(strcmp(GetName(playerid), "FighterA", true) == 0)
    	{
			FighterSkin(playerid);
    	    SetPlayerPos(playerid,2268.7737,-1709.3164,18.3554);
    	    SetPlayerFacingAngle(playerid,232.04);
    	}
    	else if(strcmp(GetName(playerid), "FighterB", true) == 0)
    	{
    	    FighterSkin(playerid);
    	    SetPlayerPos(playerid,2273.3877,-1713.4628,18.3554);
    	    SetPlayerFacingAngle(playerid,44.1034);
    	}
    	ApplyAnimation(playerid, "FIGHT_B", "null", 4.0, 0, 0, 0, 0, 0);
    	ApplyAnimation(playerid, "FIGHT_C", "null", 4.0, 0, 0, 0, 0, 0);
    	ApplyAnimation(playerid, "FIGHT_D", "null", 4.0, 0, 0, 0, 0, 0);
    	ApplyAnimation(playerid, "FIGHT_E", "null", 4.0, 0, 0, 0, 0, 0);
    	ApplyAnimation(playerid, "ON_LOOKERS", "null", 4.0, 0, 0, 0, 0, 0);
    	ApplyAnimation(playerid, "SWAT", "null", 4.0, 0, 0, 0, 0, 0);
	}
	return 1;
}
/**Callback**/
Callback UFCBlood(objectid)
{
	DestroyObject(objectid);
	return 1;
}
Callback FighterSkin(playerid)
{
    SetPlayerSkin(playerid,fighterskin[random(sizeof(fighterskin))]);
    if(GetPlayerSkin(playerid) != 80 &&GetPlayerSkin(playerid) != 81)
    {
    SetPlayerAttachedObject(playerid, 0, 19555, 5, 0.0210, -0.0100, -0.0139, -1.8999, -77.7000, -159.8000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF); // BoxingGloveL attached to the Left Hand of Cesaro
	SetPlayerAttachedObject(playerid, 1, 19556, 6, 0.0000, 0.0000, 0.0000, 0.0000, -91.0999, 0.0000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF); // BoxingGloveR attached to the Right Hand of Cesaro
    }
	return 1;
}
Callback ConnectFighter()
{
    UFC[Fighter][0] = ConnectRNPC("FighterA");
	UFC[Fighter][1] = ConnectRNPC("FighterB");
	new randName = random(sizeof(fightername));
	format(UFC[FighterAName],64,"%s",fightername[randName]);
	randName = random(sizeof(fightername));
	format(UFC[FighterBName],64,"%s",fightername[randName]);
	
	UFC[FighterHP][0] = 100;
	UFC[FighterHP][1] = 100;
    UFC[FighterTextName][0] = CreateDynamic3DTextLabelEx(UFC[FighterAName],COLOR_YELLOW, 0,0,0.5,10.0, UFC[Fighter][0]);
	UFC[FighterTextName][1] = CreateDynamic3DTextLabelEx(UFC[FighterBName],COLOR_YELLOW, 0,0,0.5,10.0, UFC[Fighter][1]);
	UFC[FighterTextHP][0] = CreateDynamic3DTextLabelEx(""COL_GREEN"["COL_RED"IIIIIIIIII"COL_GREEN"]",-1, 0,0,0.3,10.0, UFC[Fighter][0]);
	UFC[FighterTextHP][1] = CreateDynamic3DTextLabelEx(""COL_GREEN"["COL_RED"IIIIIIIIII"COL_GREEN"]",-1, 0,0,0.3,10.0, UFC[Fighter][1]);
	UFC[cBet] = 1;
	return 1;
}
Callback UFCTime()
{
	UFC[Count]-=1000;
	if(UFC[Count] == 60000)
	{
	    SendClientMessageToAll(COLOR_RED,"[UFC]:"COL_GREEN" Ultimate Fighting Championship");
	    SendClientMessageToAll(COLOR_RED,"[UFC]:"COL_GREEN" Start after 60sec (Goto gymnasiums to view)");
	    ConnectFighter();
	    
	}
	else if(UFC[Count] <= 0)
	{
	    UFC[Count] = 3600000;
	    StartUFC();
	}
    ApplyActorAnimation(UFC[ActorDJ], "DANCING", "DNCE_M_B", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
Callback StartUFC()
{
	UFC[Start] = 1;
	UFC[cBet] = 0;
	new str[128];
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,40.0,2271.4333,-1711.7360,18.3548))
	    {
	    SendClientMessage(i,COLOR_RED,"[UFC-MC]"COL_YELLOW"Linda"COL_WHITE":Ladies and Gentlemen");
	    SendClientMessage(i,COLOR_RED,"[UFC-MC]"COL_YELLOW"Linda"COL_WHITE":Welcome to the Ultimate Fighting Championship");
	    SendClientMessage(i,COLOR_RED,"[UFC-MC]"COL_YELLOW"Linda"COL_RED":The match between two boxers");
		format(str,sizeof(str),"[UFC-MC]"COL_YELLOW"Linda"COL_LIGHTBLUE": %s "COL_WHITE" and "COL_LIGHTBLUE" %s",
		UFC[FighterAName],UFC[FighterBName]);
	    SendClientMessage(i,COLOR_RED,str);
	    format(str,sizeof(str),"~y~%s ~w~Vs ~y~%s",UFC[FighterAName],UFC[FighterBName]);
	    GameTextCombo(str);
	    }
	}
    
    SetTimer("MoveTime",500,0);
    SetTimer("UFCIdle",1000,0);
	return 1;
}
Callback MoveTime()
{
	if(UFC[Start] == 1 && UFC[nMove] == 0)
	{
		new Float:x[2],Float:y[2],Float:z[2];
		GetPlayerPos(UFC[Fighter][0],x[0],y[0],z[0]);
		GetPlayerPos(UFC[Fighter][1],x[1],y[1],z[1]);
		MoveRNPC(UFC[Fighter][0], x[1],y[1],z[1],RNPC_SPEED_WALK);
	    MoveRNPC(UFC[Fighter][1], x[0],y[0],z[0],RNPC_SPEED_WALK);
	    SetTimer("MoveTime",500,0);
    }
	return 1;
}
Callback UFCIdle()
{
    UpdateFighterText();
    ApplyAnimation(UFC[Fighter][0],"FIGHT_D", "FIGHTD_IDLE", 4.0, 1, 0, 0, 0, 0); // 
    ApplyAnimation(UFC[Fighter][1],"FIGHT_D", "FIGHTD_IDLE", 4.0, 1, 0, 0, 0, 0); //
    SetTimer("UFCFight",600,0);
	return 1;
}
Callback Combo(type,id1,id2)
{
	switch(type)
	{
		case 0:
		{
			ApplyAnimation(UFC[Fighter][id1], "FIGHT_B", "FIGHTB_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "HITB_2", 4.0, 0, 0, 0, 0, 0);
			GameTextCombo("COMBO~r~~n~BOXING");
		}
		case 1:
		{
			ApplyAnimation(UFC[Fighter][id1], "FIGHT_C", "FIGHTC_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_C", "HITC_2", 4.0, 0, 0, 0, 0, 0);
			GameTextCombo("COMBO~r~~n~KungFu");
		}
		case 2:
		{
			ApplyAnimation(UFC[Fighter][id1], "FIGHT_D", "FIGHTD_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_D", "HITD_2", 4.0, 0, 0, 0, 0, 0);
			GameTextCombo("COMBO~r~~n~KneeHead");
		}
	}
	SetTimerEx("NextCombo",500,0,"iii",type,id1,id2);
	return 1;
}
Callback NextCombo(type,id1,id2)
{
    switch(type)
	{
		case 0:
		{
			ApplyAnimation(UFC[Fighter][id1], "FIGHT_B", "FIGHTB_3", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "HITB_3", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(30);
		}
		case 1:
		{
			ApplyAnimation(UFC[Fighter][id1], "FIGHT_C", "FIGHTC_3", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_C", "HITC_3", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(30);
		}
		case 2:
		{
			ApplyAnimation(UFC[Fighter][id1], "FIGHT_D", "FIGHTD_3", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_D", "HITD_3", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(30);
		}
	}
	if(CheckFighterDead(id2) == 1)
	{
	    GameTextCombo("~r~KnockOut");
		ClearAnimations(UFC[Fighter][0]);
		ClearAnimations(UFC[Fighter][1]);
		UFCWin(id1);
		UFCStop();
	}
	else
	{
		SetTimer("UFCIdle",1000,0);
	}
	return 1;
}
Callback UFCFight()
{
    UFC[nMove] = 1;
	new ran1 = random(2),
		ran2 = random(15),id1,id2;
	new	Continue = 1;
    if(ran1 == 0)
    {
    id1 = 0,id2 = 1;
    }
    else
    {
    id1 = 1,id2 = 0;
    }
    switch(ran2)
	{
	 	case 0:
	 	{
            RandomBlood(id2);
		 	ApplyAnimation(UFC[Fighter][id1], "FIGHT_B", "FIGHTB_1", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "HITB_1", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
			switch(random(5))
			{
				case 2:
				{
				    SetTimerEx("Combo",500,0,"iii",0,id1,id2);
				    Continue = 0;
				}
			}
	 	}
	  	case 1:
	   	{
	   	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_B", "FIGHTB_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "HITB_2", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
	    case 2:
	    {
	        RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_B", "FIGHTB_3", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "HITB_3", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
    	case 3:
    	{
    	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_C", "FIGHTC_1", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_C", "HITC_1", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
			switch(random(5))
			{
				case 2:
				{
				    SetTimerEx("Combo",500,0,"iii",1,id1,id2);
				    Continue = 0;
				}
			}
   		}
	    case 4:
	    {
	        RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_C", "FIGHTC_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_C", "HITC_2", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
	    case 5:
    	{
    	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_C", "FIGHTC_3", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_C", "HITC_3", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
	    case 6:
	    {
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_C", "FightC_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "FightB_block", 4.0, 0, 0, 0, 0, 0);
   		}
   		case 7:
	    {
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_B", "FightB_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "FightB_IDLE", 4.0, 0, 0, 0, 0, 0);
   		}
   		case 8:
    	{
    	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_D", "FIGHTD_1", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_D", "HITD_1", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
			switch(random(5))
			{
				case 2:
				{
				    SetTimerEx("Combo",500,0,"iii",2,id1,id2);
				    Continue = 0;
				}
			}
   		}
   		case 9:
    	{
    	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_D", "FIGHTD_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_D", "HITD_2", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
   		case 10:
    	{
    	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_D", "FIGHTD_3", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_D", "HITD_3", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
   		case 11:
    	{
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_D", "FIGHTD_2", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_D", "FightD_IDLE", 4.0, 0, 0, 0, 0, 0);
   		}
   		case 12:
    	{
    	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_E", "FightKick", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_E", "Hit_fightkick", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
   		case 13:
    	{
    	    RandomBlood(id2);
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_E", "FightKick_B", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_E", "Hit_fightkick_B", 4.0, 0, 0, 0, 0, 0);
			UFC[FighterHP][id2] -= random(10);
   		}
   		case 14:
    	{
	    	ApplyAnimation(UFC[Fighter][id1], "FIGHT_E", "FightKick_B", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(UFC[Fighter][id2], "FIGHT_B", "FightB_IDLE", 4.0, 0, 0, 0, 0, 0);
   		}
	}
	if(CheckFighterDead(id2) == 1)
	{
	ClearAnimations(UFC[Fighter][0]);
	ClearAnimations(UFC[Fighter][1]);
	UFCWin(id1);
	UFCStop();
	}
	else if(Continue == 1)
	{
	SetTimer("UFCIdle",500,0);
	}
	return 1;
}
Callback UFCWin(id)
{
	new str[128];
	if(id == 0)
	{
	    format(str,sizeof(str),"UFC:"COL_YELLOW" %s "COL_GREEN" has won",UFC[FighterAName]);
		SendClientMessageToAll(COLOR_RED,str);
	}
	else
 	{
 	    format(str,sizeof(str),"UFC:"COL_YELLOW" %s "COL_GREEN" has won",UFC[FighterBName]);
		SendClientMessageToAll(COLOR_RED,str);
	}
	SetTimerEx("WinSalute",1000,0,"i",id);
	//SetPlayerPos(UFC[Fighter][id],2273.4878,-1711.4517,18.3548);
	for(new i =0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(UFCBetFighter[i] == id)
	        {
	            UFCBetFighter[i] = 3;
	            GivePlayerMoney(i,UFCBetMoney[i]*3);
	            UFCBetMoney[i] = 0;
	            SendClientMessage(i,COLOR_GREEN,"[UFC]:"COL_YELLOW" You has won of bet and get X3 money Betting");
	        }
	        else
	        {
	        UFCBetMoney[i] = 0;
    		UFCBetFighter[i] = 3;
    		}
	    }
	}
	return 1;
}
Callback WinSalute(id)
{
	SetPlayerFacingAngle(UFC[Fighter][id],269);
    ApplyAnimation(UFC[Fighter][id], "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0, 1);
    if(id == 0)
    {
    ApplyAnimation(UFC[Fighter][1], "SWAT", "GNSTWALL_INJURD", 4.0, 0, 0, 0, 1, 0); // 
    }
    else ApplyAnimation(UFC[Fighter][0], "SWAT", "GNSTWALL_INJURD", 4.0, 0, 0, 0, 1, 0); // 
    return 1;
}
Callback UFCStop()
{
    UFC[cBet] = 0;
    UFC[Start] = 0;
    UFC[nMove] = 0;
    UFC[FighterHP][0] = 100;
	UFC[FighterHP][1] = 100;
    UpdateFighterText();
    /**/
    SetTimer("ReposFighter",5000,0);
	return 1;
}
Callback ReposFighter()
{
    DestroyDynamic3DTextLabel(UFC[FighterTextName][0]);
    DestroyDynamic3DTextLabel(UFC[FighterTextHP][0]);
    DestroyDynamic3DTextLabel(UFC[FighterTextName][1]);
    DestroyDynamic3DTextLabel(UFC[FighterTextHP][1]);
    Kick(UFC[Fighter][0]);
    Kick(UFC[Fighter][1]);
	return 1;
}
Callback UFCResync()
{
    ResyncActor(UFC[ActorBar]);
    ResyncActor(UFC[ActorMC]);
    ResyncActor(UFC[ActorDJ]);
	return 1;
}
Dialog:UFCFABet(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(isnull(inputtext)) return DialogShow(playerid,"UFCFABet",DIALOG_STYLE_INPUT,"UFC Betting Figther A","Please enter the amount you want to bet","Input","Close");
	    if(GetPlayerMoney(playerid) < strval(inputtext)) return SendClientMessage(playerid,COLOR_RED,"You not enough money to bet");
		SendClientMessage(playerid,COLOR_LIGHTBLUE,"Bet Successfully");
		UFCBetFighter[playerid] = 0;
		UFCBetMoney[playerid] = strval(inputtext);
		GivePlayerMoney(playerid,-strval(inputtext));
	}
	return 1;
}
Dialog:UFCFBBet(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(isnull(inputtext)) return DialogShow(playerid,"UFCFBBet",DIALOG_STYLE_INPUT,"UFC Betting Figther B","Please enter the amount you want to bet","Input","Close");
	    if(GetPlayerMoney(playerid) < strval(inputtext)) return SendClientMessage(playerid,COLOR_RED,"You not enough money to bet");
	    SendClientMessage(playerid,COLOR_LIGHTBLUE,"Bet Successfully");
		UFCBetFighter[playerid] = 1;
		UFCBetMoney[playerid] = strval(inputtext);
		GivePlayerMoney(playerid,-strval(inputtext));
	}
	return 1;
}
Dialog:UFCBet(playerid, response, listitem, inputtext[])
{
	new str[128];
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
			{
			    format(str,sizeof(str),"Betting Boxes %s",UFC[FighterAName]);
				DialogShow(playerid,"UFCFABet",DIALOG_STYLE_INPUT,str,"Please enter the amount you want to bet","Input","Close");
			}
	        case 1:
			{
			    format(str,sizeof(str),"Betting Boxes %s",UFC[FighterBName]);
				DialogShow(playerid,"UFCFBBet",DIALOG_STYLE_INPUT,str,"Please enter the amount you want to bet","Input","Close");
			}
		}
	}
	return 1;
}
Dialog:UFCBar(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(GetPlayerMoney(playerid) < 10) return SendClientMessage(playerid,COLOR_GREEN,"You need $10 to buy Beer");
                ApplyActorAnimation(UFC[ActorBar], "BAR", "BARSERVE_GIVE", 4.0, 0, 0, 0, 0, 0);
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_BEER);
	            GivePlayerMoney(playerid,-10);
	        }
	        case 1:
	        {
	            if(GetPlayerMoney(playerid) < 10) return SendClientMessage(playerid,COLOR_GREEN,"You need $10 to buy Vodka");
                ApplyActorAnimation(UFC[ActorBar], "BAR", "BARSERVE_GIVE", 4.0, 0, 0, 0, 0, 0);
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_WINE);
	            GivePlayerMoney(playerid,-10);
	        }
	        case 2:
	        {
	            if(GetPlayerMoney(playerid) < 5) return SendClientMessage(playerid,COLOR_GREEN,"You need $5 to buy Water");
                ApplyActorAnimation(UFC[ActorBar], "BAR", "BARSERVE_GIVE", 4.0, 0, 0, 0, 0, 0);
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
	            GivePlayerMoney(playerid,-5);
	        }
	    }
	}
	return 1;
}

/***COMMAD**/
CMD:test(playerid,params[]) {UFC[Count] = 62000;}
CMD:test2(playerid,params[]) {UFC[Count] = 5000;}
CMD:ufcwave(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid,40.0,2271.4333,-1711.7360,18.3548)) return SendClientMessage(playerid,COLOR_RED,"You need inside gymnasiums to use this command");
	switch(strval(params))
	{
	case 1: ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0, 1);
	case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.0, 1, 0, 0, 0, 0, 1);
	case 3: ApplyAnimation(playerid, "PED", "endchat_03", 4.0, 1, 0, 0, 0, 0, 1);
	case 4: ClearAnimations(playerid);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /ufcwave [1-4]");
	}
	return 1;
}
CMD:ufccheer(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid,40.0,2271.4333,-1711.7360,18.3548)) return SendClientMessage(playerid,COLOR_RED,"You need inside gymnasiums to use this command");
	switch(strval(params))
	{
	case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.0, 1, 0, 0, 0, 0, 1);
	case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.0, 1, 0, 0, 0, 0, 1);
	case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 1, 0, 0, 0, 0, 1);
	case 4: ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0, 1);
	case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.0, 1, 0, 0, 0, 0, 1);
	case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.0, 1, 0, 0, 0, 0, 1);
	case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.0, 1, 0, 0, 0, 0, 1);
	case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.0, 1, 0, 0, 0, 0, 1);
	case 9: ClearAnimations(playerid);
	default: SendClientMessage(playerid, COLOR_WHITE, "USAGE: /ufccheer [1-9]");
	}
	return 1;
}

CMD:ufc(playerid,params[])
{
	new type[32];
	if(sscanf(params,"s[32]",type)) return SendClientMessage(playerid,COLOR_GREEN,"USAGE:/ufc [NAME:bar,bet]");
	if(strcmp(type, "bar", true) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid,5,2286.6392,-1705.6304,17.6016))
		{
            DialogShow(playerid,"UFCBar",DIALOG_STYLE_LIST,"UFC Bar","Beer\t$10\nVodka\t$10\nWater\t$5","Buy","Close");
		}
		else SendClientMessage(playerid,COLOR_RED,"You not near of UFC Bar");
	}
	else if(strcmp(type, "bet", true) == 0)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5,2286.6392,-1705.6304,17.6016))
		{
		    if(UFC[Start] == 1) return SendClientMessage(playerid,COLOR_RED,"Round is already Begun ,please wait for next round");
		    if(UFC[cBet] == 0) return SendClientMessage(playerid,COLOR_RED,"Can't Betting now");
		    new str[128];format(str,sizeof(str),"%s\n%s",UFC[FighterAName],UFC[FighterBName]);
            DialogShow(playerid,"UFCBet",DIALOG_STYLE_LIST,"UFC Bet",str,"Select","Close");
		}
		else SendClientMessage(playerid,COLOR_RED,"You not near of UFC Bar");
	}
	else
	{
	SendClientMessage(playerid,COLOR_GREEN,"USAGE:/ufc [NAME:bar,bet]");
	}
	return 1;
}

/******/
stock GameTextCombo(text[])
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i,40.0,2271.4333,-1711.7360,18.3548))
	    {
		GameTextForPlayer(i,text,2000,6);
	    }
	}
	return 1;
}

stock RandomBlood(id2)
{
    switch(random(3))
	{
		case 1:
		{
       		new Float:x,Float:y,Float:z;
       		GetPlayerPos(UFC[Fighter][id2],x,y,z);
       		SetTimerEx("UFCBlood", 100, false, "i", CreateObject(18668, x, y, z- 1.6, 0.0, 0.0, 0.0) );
   		}
	}
	return 1;
}

stock UpdateFighterText()
{
	for(new i=0;i<2;i++)
	{
		switch(UFC[FighterHP][i])
		{
	    	case 0..10:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"I"COL_BLACK"IIIIIIIII"COL_GREEN"]");
	    	case 11..20:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"II"COL_BLACK"IIIIIIII"COL_GREEN"]");
	    	case 21..30:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"III"COL_BLACK"IIIIIII"COL_GREEN"]");
	    	case 31..40:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"IIII"COL_BLACK"IIIIII"COL_GREEN"]");
	    	case 41..50:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"IIIII"COL_BLACK"IIIII"COL_GREEN"]");
	    	case 51..60:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"IIIIII"COL_BLACK"IIII"COL_GREEN"]");
	    	case 61..70:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"IIIIIII"COL_BLACK"III"COL_GREEN"]");
	    	case 71..80:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"IIIIIIII"COL_BLACK"II"COL_GREEN"]");
	    	case 81..90:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"IIIIIIIII"COL_BLACK"I"COL_GREEN"]");
	    	case 91..100:UpdateDynamic3DTextLabelText(UFC[FighterTextHP][i], -1,""COL_GREEN"["COL_RED"IIIIIIIIII"COL_GREEN"]");
	    }
    }
	return 1;
}
stock CheckFighterDead(id)
{
	if(UFC[FighterHP][id] <= 0)
		return 1;
	return 0;
}
stock GetName(playerid)
{
    new szpName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, szpName, MAX_PLAYER_NAME);
    return szpName;
}
stock UFCMAP()
{
	new tmpobjid;
	tmpobjid = CreateDynamicObject(6959,2272.091,-1722.115,1.846,90.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19448,2273.389,-1722.154,18.232,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 9524, "blokmodb", "Bow_Grimebrick", 0);
	tmpobjid = CreateDynamicObject(19355,2270.624,-1722.210,18.702,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{F81414}U{0E0101}FC", 10, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19357,2273.450,-1722.180,17.332,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "Ultimate Fighting Championship", 90, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19355,2276.254,-1722.210,18.702,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{F81414}S{0E0101}an {F81414}A{0E0101}ndreas", 50, "Ariel", 20, 1, 0, 0, 1);
	tmpobjid = CreateDynamicObject(19355,2257.853,-1722.050,18.972,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{f81414}ULTIMATE", 50, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19355,2273.503,-1722.030,14.362,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{0E0101}FIGHTING", 50, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19355,2288.263,-1722.040,18.972,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterialText(tmpobjid, 0, "{0E0101}CHAMPIONSHIP", 50, "Ariel", 20, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(6959,2272.091,-1721.564,1.846,90.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "mp_diner_wood", 0);
	tmpobjid = CreateDynamicObject(6959,2267.368,-1701.525,1.846,90.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19452,2292.684,-1717.287,18.298,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19452,2292.684,-1717.297,20.098,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19376,2287.966,-1706.266,16.583,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(1502,2289.546,-1712.615,16.601,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(1502,2292.597,-1712.615,16.601,0.000,0.000,180.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19433,2288.822,-1712.620,18.251,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19376,2287.966,-1707.897,16.583,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19433,2288.822,-1712.620,20.081,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19433,2290.912,-1712.620,20.001,90.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19433,2290.912,-1712.620,21.031,90.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19377,2287.488,-1717.299,21.758,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19377,2276.989,-1717.299,21.758,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19377,2266.499,-1717.299,21.758,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19377,2256.009,-1717.299,21.758,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19377,2256.009,-1707.669,21.758,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19377,2266.509,-1707.669,21.758,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19377,2276.989,-1707.669,21.758,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19456,2256.173,-1703.223,21.741,0.000,90.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19456,2265.803,-1703.223,21.741,0.000,90.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19456,2275.443,-1703.223,21.741,0.000,90.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19456,2283.212,-1703.223,21.741,0.000,90.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10871, "blacksky_sfse", "ws_altz_wall7_top", 0);
	tmpobjid = CreateDynamicObject(19456,2283.212,-1706.703,21.741,0.000,90.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19456,2283.212,-1710.193,21.741,0.000,90.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	tmpobjid = CreateDynamicObject(19456,2283.212,-1713.642,21.741,0.000,90.000,90.000,-1,-1,-1,100.000,300.000);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ws_rooftarmac1", 0);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateDynamicObject(8615,2294.572,-1714.419,14.843,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2292.612,-1708.111,15.042,0.000,0.000,-90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2292.612,-1703.861,15.042,0.000,0.000,-90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2292.612,-1699.610,15.042,0.000,0.000,-90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2292.612,-1697.990,15.042,0.000,0.000,-90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2289.363,-1697.029,15.042,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2285.113,-1697.029,15.042,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2280.852,-1697.029,15.042,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2278.732,-1697.029,15.042,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2277.883,-1699.379,15.042,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(3361,2273.966,-1696.825,14.578,0.000,0.000,180.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2633,2291.674,-1697.029,15.042,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2256.264,-1718.626,19.179,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2256.264,-1712.716,19.179,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2256.264,-1706.776,19.179,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19465,2253.402,-1703.942,19.179,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2258.054,-1718.626,17.319,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2258.054,-1712.756,17.319,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2258.054,-1706.825,17.319,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2260.473,-1718.626,14.859,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2260.473,-1712.716,14.859,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2260.473,-1706.816,14.859,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2257.613,-1703.976,14.859,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2258.004,-1706.635,17.129,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2258.004,-1706.455,16.889,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2258.004,-1706.215,16.649,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19464,2258.054,-1718.626,17.549,0.000,90.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19611,2259.426,-1719.107,17.695,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(19610,2259.388,-1719.107,19.338,0.000,0.000,94.399,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1667,2285.925,-1704.094,17.641,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1432,2282.712,-1710.132,16.681,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1432,2283.861,-1707.092,16.681,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1432,2282.102,-1704.122,16.681,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2800,2283.885,-1707.076,17.114,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2232,2260.340,-1716.029,18.229,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2321,2261.496,-1719.416,16.544,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2321,2261.496,-1719.416,17.034,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1954,2262.864,-1719.514,17.639,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1957,2262.041,-1719.506,17.639,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1952,2263.091,-1719.383,17.731,0.000,0.000,-20.499,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1953,2262.805,-1719.518,17.711,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1955,2262.270,-1719.382,17.741,0.000,0.000,15.699,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1956,2261.977,-1719.522,17.699,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(18652,2262.280,-1718.919,16.609,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1958,2261.431,-1719.504,17.569,0.000,0.000,180.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1670,2282.098,-1704.196,17.321,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1665,2282.932,-1709.750,17.321,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(18673,2282.906,-1709.676,15.761,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2232,2260.359,-1721.199,18.229,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(2232,2263.790,-1719.409,17.179,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(16151,2286.815,-1705.696,16.911,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1666,2285.920,-1703.175,17.621,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1545,2287.835,-1706.661,18.521,0.000,0.000,270.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1543,2282.630,-1709.673,17.251,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(1541,2287.825,-1707.814,18.281,0.000,0.000,91.099,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(14782,2252.387,-1721.223,17.541,0.000,0.000,180.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(14791,2270.978,-1711.127,18.481,0.000,0.000,0.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(18652,2270.866,-1701.059,20.889,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);
	tmpobjid = CreateDynamicObject(18652,2265.996,-1701.059,20.889,0.000,0.000,90.000,-1,-1,-1,100.000,300.000);

	return 1;
}
