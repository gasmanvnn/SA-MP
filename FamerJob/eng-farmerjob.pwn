/*
					|------------INFOMATION---------------|
					|   SCRIPT NAME: Farmer Job Beta1     |
					|   Author     : Gasman(NhatNguyen)   |
					|   Creadits   :+Team SA-MP for SAMP  |
					|      +Incognito for Streamer plugin |
					|   Version Language: English         |
					|   sorry for my very bad English     |
					|-------------------------------------|
					Please don't remove the credits and author
*/
#include <a_samp>
#include <zcmd>
#include <streamer>
native IsValidVehicle(vehicleid);
#define function%0(%1) forward%0(%1);public%0(%1)
/*DEFINE PRESSED KEY*/
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
/*---------------------------------SCRIPT EDIT---------------------------------*/
/*
FJ Pos hire vehicle is positions to rent vehicle
FJ Pos Get paddy sack is positions to get paddy sack
FJ Transport is positions to transport paddy
Time_Updatepaddy is time paddy grow default is 5000ms(5s)
*/
#define MAX_PADDYS 100

#define FJPosHireVehicle -123.0217,-32.4668,3.1172
#define FJPosGetPaddySack -102.7191,-35.4960,3.9605
#define FJPosTransport  1350.87219, -1771.08533, 12.48870
#define FJAreaPos       -273.4105,-60.5778,-122.2512,60.6611//minx,miny,maxx,maxy

#define DIALOG_FJHIREVEHICLE 		(2322)
#define DIALOG_FJGETPADDYSACK       (2323)
#define DIALOG_FJUNHIREVEHICLE      (2324)

#define TIME_UPDATEPADDY            (5000)
/*-----------------------------------------------------------------------------*/
new FJArea;
enum fj
{
	pPaddyUsed[MAX_PADDYS] = 0,
	pPaddyObject[MAX_PADDYS],
	pPaddyProgress[MAX_PADDYS],
	pPaddyFillWater[MAX_PADDYS],
	Float:pPaddyPosX[MAX_PADDYS],
	Float:pPaddyPosY[MAX_PADDYS],
	Float:pPaddyPosZ[MAX_PADDYS],
	Text3D:pPaddyText[MAX_PADDYS],
	/////////////////////////////
	pPaddyHarvestUsed[MAX_PADDYS],
	pPaddyHarvestObject[MAX_PADDYS],
	Float:pPaddyHarvestPosX[MAX_PADDYS],
	Float:pPaddyHarvestPosY[MAX_PADDYS],
	Float:pPaddyHarvestPosZ[MAX_PADDYS],
	Text3D:pPaddyHarvestText[MAX_PADDYS],
	/////////////////////////////
	pHasHireVehicle,
	pVehicleHire,
	pTrailerVehicleHire,
	pPaddyInTrailer,
	Text3D:pTrailerText,
	////////////////////////////
	pPaddyHarvestInVehicle,
	pPaddyHarvestInVehicleObject[5],
	////////////////////////////
	pUpdateTime,
}
new PlayerInfo[MAX_PLAYERS][fj];
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("[|]Gasman Farmer job loaded");
	print("--------------------------------------\n");
	FJArea = CreateDynamicRectangle(FJAreaPos);
	CreateDynamic3DTextLabel("Pickup paddy harvest sack and press 'H' to sell",-1,FJPosTransport,5.0);
	CreateDynamic3DTextLabel("Press 'Y' to hire vehicle",-1,FJPosHireVehicle,5.0);
	CreateDynamic3DTextLabel("Press 'Y' to get paddy sack",-1,FJPosGetPaddySack,5.0);
	CreateDynamicPickup(19606,1,FJPosHireVehicle);
	CreateDynamicPickup(19606,1,FJPosGetPaddySack);
	CreateDynamicPickup(19606,1,FJPosTransport);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
public OnPlayerSpawn(playerid)
{
	ApplyAnimation(playerid,"CARRY","null",0,0,0,0,0,0);
	PlayerInfo[playerid][pUpdateTime] = SetTimerEx("UpdatePaddy",TIME_UPDATEPADDY,1,"i",playerid);
	return 1;
}
public OnPlayerDisconnect(playerid,reason)
{
	KillTimer(PlayerInfo[playerid][pUpdateTime]);
	if(IsValidVehicle(PlayerInfo[playerid][pVehicleHire])) DestroyVehicle(PlayerInfo[playerid][pVehicleHire]);
	if(IsValidVehicle(PlayerInfo[playerid][pTrailerVehicleHire])) DestroyVehicle(PlayerInfo[playerid][pTrailerVehicleHire]);
	if(IsValidDynamic3DTextLabel(PlayerInfo[playerid][pTrailerText])) DestroyDynamic3DTextLabel(PlayerInfo[playerid][pTrailerText]);
	for(new i =0;i<MAX_PADDYS;i++)
	{
	    if(PlayerInfo[playerid][pPaddyUsed][i] == 1)
	    {
	    DestroyPaddy(playerid,i);
	    }
        if(PlayerInfo[playerid][pPaddyHarvestUsed][i] == 1)
        {
        DestroyPaddyHarvest(playerid,i);
        }
	}
    for(new i=0;i<5;i++)
    {
    	if(IsValidObject(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][i]))
     	{
     		DestroyObject(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][i]);
      	}
    }
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_FJHIREVEHICLE:
	    {
	        if(response)
	        {
	            if(GetPlayerMoney(playerid) < 100) return SendClientMessage(playerid,-1,"[FarmerJob]:You need $100 to rent vehicle");
	            GivePlayerMoney(playerid,-100);
	            PlayerInfo[playerid][pHasHireVehicle] = 1;
				if(listitem == 0)
				{
				PlayerInfo[playerid][pVehicleHire]=CreateVehicle(531,FJPosHireVehicle,0.0,-1,-1,20000);
				PlayerInfo[playerid][pTrailerVehicleHire] = CreateVehicle(610,FJPosHireVehicle,0.0,-1,-1,90000);
				new string[128];
				PlayerInfo[playerid][pPaddyInTrailer] = 0;
				format(string,sizeof(string),"Trailer Owner {4cff00}%s\nPaddy :{4cff00}%d",GetName(playerid),PlayerInfo[playerid][pPaddyInTrailer]);
				PlayerInfo[playerid][pTrailerText] = CreateDynamic3DTextLabel(string,-1,FJPosHireVehicle,5.0,INVALID_PLAYER_ID,PlayerInfo[playerid][pTrailerVehicleHire]);
				SetTimerEx("AttachTrailer",1000,0,"ii",PlayerInfo[playerid][pVehicleHire],PlayerInfo[playerid][pTrailerVehicleHire]);
				PutPlayerInVehicle(playerid,PlayerInfo[playerid][pVehicleHire],0);
				}
				else if(listitem == 1)
				{
				PlayerInfo[playerid][pVehicleHire]=CreateVehicle(532,FJPosHireVehicle,0.0,-1,-1,20000);
				PutPlayerInVehicle(playerid,PlayerInfo[playerid][pVehicleHire],0);
				}
				else if(listitem == 2)
				{
			 	PlayerInfo[playerid][pVehicleHire]=CreateVehicle(478,FJPosHireVehicle,0.0,-1,-1,20000);
			 	PutPlayerInVehicle(playerid,PlayerInfo[playerid][pVehicleHire],0);
				}
	        }
	    }
	    case DIALOG_FJUNHIREVEHICLE:
	    {
	        if(response)
	        {
	            if(IsValidVehicle(PlayerInfo[playerid][pVehicleHire]))
	            {
		            GivePlayerMoney(playerid,50);
		            PlayerInfo[playerid][pHasHireVehicle] = 0;
		            DestroyVehicle(PlayerInfo[playerid][pVehicleHire]);
		            if(IsValidVehicle(PlayerInfo[playerid][pTrailerVehicleHire]))
					{
					PlayerInfo[playerid][pPaddyInTrailer] = 0;
					DestroyVehicle(PlayerInfo[playerid][pTrailerVehicleHire]);
					DestroyDynamic3DTextLabel(PlayerInfo[playerid][pTrailerText]);
					}
	            }
	        }
	    }
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	
	if(PRESSED(KEY_YES))
	{
	    if(IsPlayerInRangeOfPoint(playerid,2,FJPosHireVehicle))
	    {
	        if(PlayerInfo[playerid][pHasHireVehicle] == 0)
	        {
	    	ShowPlayerDialog(playerid,DIALOG_FJHIREVEHICLE,DIALOG_STYLE_LIST,"Farmer Job vehicle rent",
	    	"Tractor(Sowing) $100\nCombine Harvester(Harvest) $100\nWalton(transport) $100","Hire","Close");
	    	}
	    	else
	    	{
		    	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == PlayerInfo[playerid][pVehicleHire])
				{
					ShowPlayerDialog(playerid,DIALOG_FJUNHIREVEHICLE,0,"Farmer job vehicle rent","You want no rent vehicle anymore?\n\
					you will get 50% money","Yes","No");
				}
				else
				{
					SendClientMessage(playerid,-1,"[FarmerJob]:You need in vehicle your rent");
				}
	    	}
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2,FJPosGetPaddySack))
	    {
	        if(!IsValidVehicle(PlayerInfo[playerid][pVehicleHire]) ||!IsValidVehicle(PlayerInfo[playerid][pTrailerVehicleHire])) return SendClientMessage(playerid,-1,"[FarmerJob]:You need rent vehicle before");
	        if(GetPVarInt(playerid,"HasGetPaddySack") == 1) return SendClientMessage(playerid,-1,"[FarmerJob]:You already get paddy sack");
	        if(PlayerInfo[playerid][pPaddyInTrailer] != 0) return SendClientMessage(playerid,-1,"[FarmerJob]:You need sowing all paddy in this trailer to continue get paddy sack");
        	ApplyAnimation(playerid, "CARRY", "LIFTUP", 4.0, 0, 0, 0, 0,0); // nhatlenkieu1
			SetPVarInt(playerid,"HasGetPaddySack",1);
			SetTimerEx("CarrySack",1000,0,"i",playerid);
			SetPlayerAttachedObject(playerid, 9, 2060, 1, 0.170999, 0.363000, 0.000000, 0.000000, 93.700012, 0.000000, 0.713000, 0.650000, 1.000000, 0, 0);
	    }
	}
	if(PRESSED(KEY_WALK))
	{
		if(IsValidVehicle(PlayerInfo[playerid][pTrailerVehicleHire]) && GetPVarInt(playerid,"HasGetPaddySack") == 1)
		{
			new Float:x,Float:y,Float:z;
			GetVehiclePos(PlayerInfo[playerid][pTrailerVehicleHire],x,y,z);
			if(IsPlayerInRangeOfPoint(playerid,2,x,y,z))
			{
			    if(PlayerInfo[playerid][pPaddyInTrailer] == 0)
			    {
			    ApplyAnimation(playerid, "CARRY", "PUTDWN105", 4.0, 0, 0, 0, 0,0); // datxuongkieu2
			    PlayerInfo[playerid][pPaddyInTrailer] = 10;
			    RemovePlayerAttachedObject(playerid,9);
			    SetPVarInt(playerid,"HasGetPaddySack",0);
			    new string[128];
				format(string,sizeof(string),"Trailer Owner {4cff00}%s\nPaddy :{4cff00}%d",GetName(playerid),PlayerInfo[playerid][pPaddyInTrailer]);
				UpdateDynamic3DTextLabelText(PlayerInfo[playerid][pTrailerText],-1,string);
			    }
			    else
			    {
			    SendClientMessage(playerid,-1,"[FarmerJob]:You need sowing all paddy in this trailer to continue get paddy sack");
			    }
			}
			else
			{
			SendClientMessage(playerid,-1,"[FarmerJob]:You need near trailer");
			}
		}
	}
	if(PRESSED(KEY_FIRE))
	{
	    if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == PlayerInfo[playerid][pVehicleHire])
	    {
	        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 531 && IsPlayerInDynamicArea(playerid,FJArea,1))
	        {
	            if(PlayerInfo[playerid][pPaddyInTrailer] > 0 && CheckPaddyFreeSlot(playerid,1)!= -1)
	            {
		        new Float:x,Float:y,Float:z;
		        GetVehiclePos(PlayerInfo[playerid][pTrailerVehicleHire],x,y,z);
		        PlayerInfo[playerid][pPaddyInTrailer] -= 1;
		        new string[128];
				format(string,sizeof(string),"Trailer Owner {4cff00}%s\nPaddy :{4cff00}%d",GetName(playerid),PlayerInfo[playerid][pPaddyInTrailer]);
				UpdateDynamic3DTextLabelText(PlayerInfo[playerid][pTrailerText],-1,string);
		        CreatePaddy(playerid,CheckPaddyFreeSlot(playerid,1),0,x,y,z-2);
		        }
		        else
		        {
		        SendClientMessage(playerid,-1,"[FarmerJob]:No have paddy in trailer or full slot");
		        }
	        }
	        else if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 532 && IsPlayerInDynamicArea(playerid,FJArea,1))
	        {
	            for(new i =0;i<MAX_PADDYS;i++)
	            {
	                if(PlayerInfo[playerid][pPaddyUsed][i] == 1)
	    			{
	    			    new Float:x,Float:y,Float:z;
						GetDynamicObjectPos(PlayerInfo[playerid][pPaddyObject][i],x,y,z);
						if(IsPlayerInRangeOfPoint(playerid,4,x,y,z))
						{
						    if(PlayerInfo[playerid][pPaddyProgress][i] >= 100)
						    {
						    DestroyPaddy(playerid,i);
						    //CreatePaddyHarvest(playerid,CheckPaddyFreeSlot(playerid,2),x,y,z);
						    SetTimerEx("CreatePaddyHarvest",2000,0,"iifff",playerid,CheckPaddyFreeSlot(playerid,2),x,y,z+1);
						    return 1;
						    }
						    else
						    {
						    SendClientMessage(playerid,-1,"[FarmerJob]:This paddy can not harvest");
						    }
						}
	    			}
	            }
	        }
	    }
	}
	if(PRESSED(KEY_NO))
	{
	    if(GetPVarInt(playerid,"HasPickupPaddy") == 0)
	    {
			for(new i =0;i<MAX_PADDYS;i++)
	  		{
	    		if(PlayerInfo[playerid][pPaddyHarvestUsed][i] == 1)
	   			{
			    	new Float:x,Float:y,Float:z;
					GetDynamicObjectPos(PlayerInfo[playerid][pPaddyHarvestObject][i],x,y,z);
					if(IsPlayerInRangeOfPoint(playerid,3,x,y,z))
					{
					ApplyAnimation(playerid, "CARRY", "LIFTUP", 4.0, 0, 0, 0, 0,0); // nhatlenkieu1
					SetPVarInt(playerid,"HasPickupPaddy",1);
					SetTimerEx("CarrySack",1000,0,"i",playerid);
					SetPlayerAttachedObject(playerid, 8, 2060, 1, 0.170999, 0.363000, 0.000000, 0.000000, 93.700012, 0.000000, 0.713000, 0.650000, 1.000000, 0, 0);
					DestroyPaddyHarvest(playerid,i);
					return 1;
					}
	 			}
	    	}
    	}
    	else
    	{
    	    new Float:x,Float:y,Float:z;
    	    GetPlayerPos(playerid,x,y,z);
    	    ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0,0); // datxuongkieu1
    	    RemovePlayerAttachedObject(playerid,8);
    	    CreatePaddyHarvest(playerid,CheckPaddyFreeSlot(playerid,2),x,y,z-0.8);
    	    SetPVarInt(playerid,"HasPickupPaddy",0);
    	    return 1;
    	}
	}
	if(PRESSED(KEY_CTRL_BACK))
	{
		new Float:x,Float:y,Float:z;
		GetVehiclePos(PlayerInfo[playerid][pVehicleHire],x,y,z);
		if(IsPlayerInRangeOfPoint(playerid,2,FJPosTransport))
		{
		    if(GetPVarInt(playerid,"HasPickupPaddy") == 1)
	    	{
	    	    SetPVarInt(playerid,"HasPickupPaddy",0);
	    	    ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0,0); // datxuongkieu2
	    	    RemovePlayerAttachedObject(playerid,8);
	    	    GivePlayerMoney(playerid,100);
	    	    return 1;
	    	}
		}
		if(GetVehicleModel(PlayerInfo[playerid][pVehicleHire]) == 478 && IsPlayerInRangeOfPoint(playerid,3,x,y,z))
		{
		    if(GetPVarInt(playerid,"HasPickupPaddy") == 1)
	    	{
	    	    if(PlayerInfo[playerid][pPaddyHarvestInVehicle] < 5)
	    	    {
	    	    SetPVarInt(playerid,"HasPickupPaddy",0);
	    	    ApplyAnimation(playerid, "CARRY", "PUTDWN105", 4.0, 0, 0, 0, 0,0); // datxuongkieu2
	    	    RemovePlayerAttachedObject(playerid,8);
	    	    PlayerInfo[playerid][pPaddyHarvestInVehicle] += 1;
	    	    AddPaddyObjectToVehicle(playerid);
	    	    }
	    	    else
	    	    {
	    	    SendClientMessage(playerid,-1,"[FarmerJob]:Full , please transport this");
	    	    }
	    	}
	    	else
	    	{
	    	    if(PlayerInfo[playerid][pPaddyHarvestInVehicle] > 0)
	    	    {
	    	    DestroyObject(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][PlayerInfo[playerid][pPaddyHarvestInVehicle]-1]);
	    	    PlayerInfo[playerid][pPaddyHarvestInVehicle]-=1;
	    	    ApplyAnimation(playerid, "CARRY", "LIFTUP105", 4.0, 0, 0, 0, 0,0); // nhatlenkieu2
	    	    SetPlayerAttachedObject(playerid, 8, 2060, 1, 0.170999, 0.363000, 0.000000, 0.000000, 93.700012, 0.000000, 0.713000, 0.650000, 1.000000, 0, 0);
	    	    SetPVarInt(playerid,"HasPickupPaddy",1);
	    	    SetTimerEx("CarrySack",1000,0,"i",playerid);
	    	    }
	    	    else
	    	    {
	    	    SendClientMessage(playerid,-1,"[FarmerJob]:No paddy on this vehicle");
	    	    }
	    	}
		}
	}
	return 1;
}
///////////////////////////
CMD:info(playerid,params[])
{
	new string[1024];
	strcat(string,"Farmer job by Gasman version Beta release\n");
	strcat(string,"Features Sowing | Harvest |Sprinklers(In Develop)");
	ShowPlayerDialog(playerid,1323,0,"Farmer job info",string,"Close","");
	return 1;
}
CMD:transport(playerid,params[])
{
	if(IsPlayerInAnyVehicle(playerid) && GetVehicleModel(PlayerInfo[playerid][pVehicleHire]) == 478 && GetPlayerVehicleID(playerid) == PlayerInfo[playerid][pVehicleHire])
	{
        if(PlayerInfo[playerid][pPaddyHarvestInVehicle] > 0)
   	    {
   	        SetPlayerCheckpoint(playerid,FJPosTransport,5.0);
   	        /*GivePlayerMoney(playerid,PlayerInfo[playerid][pPaddyHarvestInVehicle]*100);
   	        PlayerInfo[playerid][pPaddyHarvestInVehicle] = 0;
   	        for(new i=0;i<5;i++)
   	        {
   	            if(IsValidObject(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][i]))
   	            {
   	        	DestroyObject(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][i]);
   	        	}
   	        }*/
   	    }
   	    else
   	    {
   	    	SendClientMessage(playerid,-1,"[FarmerJob]:No paddy on this vehicle");
   	    }
	}
	return 1;
}
///////////////////////function

function AddPaddyObjectToVehicle(playerid)
{
	switch(PlayerInfo[playerid][pPaddyHarvestInVehicle])
	{
	    case 1:
	    {
	    PlayerInfo[playerid][pPaddyHarvestInVehicleObject][0] = CreateObject(2060,0,0,-1000,0,0,0,100);
		AttachObjectToVehicle(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][0],PlayerInfo[playerid][pVehicleHire], -0.375000,-1.275000,0.150000,0.000000,0.000000,0.000000);
		}
		case 2:
		{
		PlayerInfo[playerid][pPaddyHarvestInVehicleObject][1] = CreateObject(2060,0,0,-1000,0,0,0,100);
		AttachObjectToVehicle(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][1],PlayerInfo[playerid][pVehicleHire], -0.375000,-1.725000,0.150000,0.000000,0.000000,0.000000);
		}
		case 3:
		{
		PlayerInfo[playerid][pPaddyHarvestInVehicleObject][2] = CreateObject(2060,0,0,-1000,0,0,0,100);
		AttachObjectToVehicle(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][2],PlayerInfo[playerid][pVehicleHire], -0.375000,-2.250000,0.150000,0.000000,0.000000,0.000000);
		}
		case 4:
		{
		PlayerInfo[playerid][pPaddyHarvestInVehicleObject][3] = CreateObject(2060,0,0,-1000,0,0,0,100);
		AttachObjectToVehicle(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][3],PlayerInfo[playerid][pVehicleHire], 0.524999,-1.875000,0.150000,0.000000,0.000000,89.099983);
		}
		case 5:
		{
		PlayerInfo[playerid][pPaddyHarvestInVehicleObject][4] = CreateObject(2060,0,0,-1000,0,0,0,100);
		AttachObjectToVehicle(PlayerInfo[playerid][pPaddyHarvestInVehicleObject][4],PlayerInfo[playerid][pVehicleHire], 0.149999,-1.875000,0.375000,0.000000,0.000000,89.099990);
		}
	}
	return 1;
}
function UpdatePaddy(playerid)
{
	for(new i =0;i<MAX_PADDYS;i++)
	{
	    if(PlayerInfo[playerid][pPaddyUsed][i] == 1)
	    {
	        if(PlayerInfo[playerid][pPaddyProgress][i] < 100)
			{
			    /*if(PlayerInfo[playerid][pPaddyProgress][i] > 50)
				{
				    if(PlayerInfo[playerid][pPaddyFillWater][i] == 0)
				    {
				    new string[128];
				    format(string,sizeof(string),"Paddy Owner %s\nSlot %d\nProgress :%d\nNEED WATER",GetName(playerid),i,PlayerInfo[playerid][pPaddyProgress][i]);
				    UpdateDynamic3DTextLabelText(PlayerInfo[playerid][pPaddyText][i],-1,string);
				    return 1;
				    }
				}*/
			    PlayerInfo[playerid][pPaddyProgress][i] += 1;
				if(PlayerInfo[playerid][pPaddyProgress][i] == 50)
				{
				new Float:x,Float:y,Float:z;
				GetDynamicObjectPos(PlayerInfo[playerid][pPaddyObject][i],x,y,z);
				MoveDynamicObject(PlayerInfo[playerid][pPaddyObject][i],x,y,z+1,2);
				DestroyDynamic3DTextLabel(PlayerInfo[playerid][pPaddyText][i]);
				PlayerInfo[playerid][pPaddyText][i]=CreateDynamic3DTextLabel("",-1,x,y,z+2,5.0);
				}
				new string[128];
			    format(string,sizeof(string),"{fff600}Paddy Owner %s\nSlot {ff0000}%d\nProgress :{00f6ff}%d",GetName(playerid),i,PlayerInfo[playerid][pPaddyProgress][i]);
			    UpdateDynamic3DTextLabelText(PlayerInfo[playerid][pPaddyText][i],-1,string);
			    if(PlayerInfo[playerid][pPaddyProgress][i] == 100)
				{
				format(string,sizeof(string),"{7b1487}CAN HARVEST\n{fff600}Paddy Owner %s\nSlot {ff0000}%d\nProgress :{00f6ff}%d",GetName(playerid),i,PlayerInfo[playerid][pPaddyProgress][i]);
			    UpdateDynamic3DTextLabelText(PlayerInfo[playerid][pPaddyText][i],-1,string);
				}
			}
	    }
	}
	return 1;
}
function CarrySack(playerid)
{
	ApplyAnimation(playerid, "CARRY", "CRRY_PRTIAL", 4.0, 0, 0, 0, 1, 100); // dangrinh
    return 1;
}
function AttachTrailer(vehicleid,trailerid)
{
    AttachTrailerToVehicle(trailerid,vehicleid);
    return 1;
}
function CheckPaddyFreeSlot(playerid,type)
{
	for(new i =0;i<MAX_PADDYS;i++)
	{
		switch(type)
		{
			case 1:
			{
			    if(PlayerInfo[playerid][pPaddyUsed][i] == 0)
			    {
			        return i;
			    }
	        }
	        case 2:
	        {
	            if(PlayerInfo[playerid][pPaddyHarvestUsed][i] == 0)
			    {
			        return i;
			    }
	        }
	    }
	}
	return -1;
}
function CreatePaddyHarvest(playerid,id,Float:x,Float:y,Float:z)
{
	if(PlayerInfo[playerid][pPaddyHarvestUsed][id] == 1) return 1;
	PlayerInfo[playerid][pPaddyHarvestUsed][id] = 1;
    PlayerInfo[playerid][pPaddyHarvestPosX][id] = x;
    PlayerInfo[playerid][pPaddyHarvestPosY][id] = y;
    PlayerInfo[playerid][pPaddyHarvestPosZ][id] = z;
    PlayerInfo[playerid][pPaddyHarvestObject][id] = CreateDynamicObject(2060,x,y,z,0.0,0.0,0.0);
    new string[128];
    format(string,sizeof(string),"{fff600}Paddy harvest Owner %s\nSlot {ff0000}%d\n{ffffff}Key 'N' to pickup",GetName(playerid),id);
    PlayerInfo[playerid][pPaddyHarvestText][id] = CreateDynamic3DTextLabel(string,-1,x,y,z,5.0);
	return 1;
}
function DestroyPaddyHarvest(playerid,id)
{
    if(PlayerInfo[playerid][pPaddyHarvestUsed][id] == 0) return 1;
    PlayerInfo[playerid][pPaddyHarvestUsed][id] = 0;
    PlayerInfo[playerid][pPaddyHarvestPosX][id] = 0.0;
    PlayerInfo[playerid][pPaddyHarvestPosY][id] = 0.0;
    PlayerInfo[playerid][pPaddyHarvestPosZ][id] = 0.0;
    if(IsValidDynamic3DTextLabel(PlayerInfo[playerid][pPaddyHarvestText][id])) DestroyDynamic3DTextLabel(PlayerInfo[playerid][pPaddyHarvestText][id]);
    if(IsValidDynamicObject(PlayerInfo[playerid][pPaddyHarvestObject][id])) DestroyDynamicObject(PlayerInfo[playerid][pPaddyHarvestObject][id]);
	return 1;
}
function CreatePaddy(playerid,id,progress,Float:x,Float:y,Float:z)
{
	if(PlayerInfo[playerid][pPaddyUsed][id] == 1) return 1;
	PlayerInfo[playerid][pPaddyUsed][id] = 1;
    PlayerInfo[playerid][pPaddyPosX][id] = x;
    PlayerInfo[playerid][pPaddyPosY][id] = y;
    PlayerInfo[playerid][pPaddyPosZ][id] = z;
    PlayerInfo[playerid][pPaddyProgress][id] = progress;
    PlayerInfo[playerid][pPaddyObject][id] = CreateDynamicObject(19473,x,y,z,0.0,0.0,0.0);
    new string[128];
    format(string,sizeof(string),"{fff600}Paddy Owner %s\nSlot {ff0000}%d\nProgress :{00f6ff}%d",GetName(playerid),id,PlayerInfo[playerid][pPaddyProgress][id]);
    PlayerInfo[playerid][pPaddyText][id] = CreateDynamic3DTextLabel(string,-1,x,y,z,5.0);
	return 1;
}
function DestroyPaddy(playerid,id)
{
    if(PlayerInfo[playerid][pPaddyUsed][id] == 0) return 1;
    PlayerInfo[playerid][pPaddyUsed][id] = 0;
    PlayerInfo[playerid][pPaddyPosX][id] = 0.0;
    PlayerInfo[playerid][pPaddyPosY][id] = 0.0;
    PlayerInfo[playerid][pPaddyPosZ][id] = 0.0;
    PlayerInfo[playerid][pPaddyProgress][id] = 0;
    if(IsValidDynamic3DTextLabel(PlayerInfo[playerid][pPaddyText][id])) DestroyDynamic3DTextLabel(PlayerInfo[playerid][pPaddyText][id]);
    if(IsValidDynamicObject(PlayerInfo[playerid][pPaddyObject][id])) DestroyDynamicObject(PlayerInfo[playerid][pPaddyObject][id]);
    return 1;
}
stock GetName(playerid)
{
    new pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
    return pName;
}
/*===============================END SCRIPT====================================*/
/*=============================WELCOME TO GvC==================================*/
/*==============================forum.gvc.vn===================================*/
