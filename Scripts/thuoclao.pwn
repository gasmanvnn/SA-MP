#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <progress2>
new PlayerText:TextThuocLao[MAX_PLAYERS][7];
enum thuoclao
{
	tlDangHut,
	Float:tlProgress,
	PlayerBar:tlBar,
	tlKey,
	tlSai,
}
new ThuocLao[MAX_PLAYERS][thuoclao];
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" THUOC LAO BY GASMAN");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	LoadThuocLaoText(playerid);
	ThuocLao[playerid][tlBar] = CreatePlayerProgressBar(playerid, 50.000000, 321.000000, 80.500000, 9.199999, -1429936641, 100.0000, 0);
	return 1;
}
public OnPlayerRequestSpawn(playerid)
{
    PreloadAnimThuocLao(playerid);
	return 1;
}
CMD:thuoclao(playerid,params[])
{
	new type[128];
	if(sscanf(params,"s[128]",type)) return SendClientMessage(playerid,-1,"/thuoclao [hut,trogiup,credits]");
    if (strcmp("hut", type, true, 10) == 0)
	{
	    if(ThuocLao[playerid][tlDangHut] == 1) return SendClientMessage(playerid,-1,"Ban dang hut");
		BatDauHut(playerid);
	    
	}
	else if (strcmp("trogiup", type, true, 10) == 0)
	{
	    ShowPlayerDialog(playerid,69691,0,"Tro giup thuoc lao","De hut su dung lenh /thuoclao hut\nNhan lan luoc chuot trai va phai\n\
	    LMB la Chuot Trai ,RMB la Chuot Phai\n\
	    Neu nhan sai 2 lan se bi sac thuoc\nSau khi hut se vao trang thai phe thuoc\nCo kha nang bi shock thuoc\nHoi 100% mau","Oke","");
	}
	else if (strcmp("credits", type, true, 10) == 0)
	{
	    ShowPlayerDialog(playerid,69691,0,"Credits Thuoc lao","Script by Gasman\nSscanf by Y_Less\nZcmd by ZeeX\nProgress2 by SouthClaw","Oke","");
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(ThuocLao[playerid][tlDangHut] == 1)
	{
	    
	    if(newkeys & KEY_FIRE)
	    {
     		if(ThuocLao[playerid][tlKey] == KEY_FIRE)
     		{
	     		ThuocLao[playerid][tlProgress] += 10.0;
	     		SetPlayerProgressBarValue(playerid,ThuocLao[playerid][tlBar],ThuocLao[playerid][tlProgress]);
	     		RandomTLKey(playerid);
	     		if(ThuocLao[playerid][tlProgress] >= 100.0)
	     		{
	     		    KeoThuoc(playerid);
     			}
     		}
     		else
     		{
	     		ThuocLao[playerid][tlSai]++;
	     		new saitext[128];
	     		format(saitext,sizeof(saitext),"Sai %d/2",ThuocLao[playerid][tlSai]);
	     		PlayerTextDrawSetString(playerid,TextThuocLao[playerid][5],saitext);
	     		PlayerTextDrawShow(playerid,TextThuocLao[playerid][5]);
	     		RandomTLKey(playerid);
	     		if(ThuocLao[playerid][tlSai] >= 2)
	     		{
					SacThuoc(playerid);
	     		}
     		}
	    }
	    else if(newkeys & KEY_HANDBRAKE)
	    {
            if(ThuocLao[playerid][tlKey] == KEY_HANDBRAKE)
     		{
	     		ThuocLao[playerid][tlProgress] += 10.0;
	            SetPlayerProgressBarValue(playerid,ThuocLao[playerid][tlBar],ThuocLao[playerid][tlProgress]);
	            RandomTLKey(playerid);
	            if(ThuocLao[playerid][tlProgress] >= 100.0)
	     		{
	     		    KeoThuoc(playerid);
     			}
     		}
     		else
     		{
	     		ThuocLao[playerid][tlSai]++;
	     		new saitext[128];
	     		format(saitext,sizeof(saitext),"Sai %d/2",ThuocLao[playerid][tlSai]);
	     		PlayerTextDrawSetString(playerid,TextThuocLao[playerid][5],saitext);
	     		PlayerTextDrawShow(playerid,TextThuocLao[playerid][5]);
	     		RandomTLKey(playerid);
	     		if(ThuocLao[playerid][tlSai] >= 2)
	     		{
					SacThuoc(playerid);
	     		}
     		}
	    }
	}
	return 1;
}
stock SacThuoc(playerid)
{
	GameTextForPlayer(playerid,"Sac khoi thuoc",3000,6);
    ApplyAnimation(playerid, "FAT", "IDLE_TIRED", 4.0, 0, 0, 0, 0, 3000);
    NgungHut(playerid);
	return 1;
}
stock KeoThuoc(playerid)
{
    ThuocLao[playerid][tlDangHut] = 2;
    ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_CROUCH_IN", 4.0, 0, 0, 0, 1, 0); // keothuoc
    RemovePlayerAttachedObject(playerid,5);
	RemovePlayerAttachedObject(playerid,6);
	RemovePlayerAttachedObject(playerid,7);
    SetPlayerAttachedObject(playerid, 9, 1666, 1, 0.3190, 0.3660, 0.1079, 110.9000, 24.5999, 11.4000, 0.6369, 0.6459, 2.9759, 0xFFFFFFFF, 0xFFFFFFFF);
	SetPlayerAttachedObject(playerid, 8, 3044, 2, -0.0089, 0.1399, -0.0150, 177.1999, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0xFFFFFFFF, 0xFFFFFFFF); // CIGAR attached to the Head of Gasman
    PlayAudioStreamForPlayer(playerid,"http://grg-gasman.esy.es/thuoclao.mp3");
    SetTimerEx("DangKeoThuoc",1000,0,"i",playerid);
    PlayerTextDrawSetString(playerid,TextThuocLao[playerid][2],"Dang keo...");
    PlayerTextDrawShow(playerid,TextThuocLao[playerid][2]);
	return 1;
}
forward DangKeoThuoc(playerid);
public DangKeoThuoc(playerid)
{
    ThuocLao[playerid][tlProgress] -= 20.0;
    SetPlayerProgressBarValue(playerid,ThuocLao[playerid][tlBar],ThuocLao[playerid][tlProgress]);
    if(ThuocLao[playerid][tlProgress] <= 0.0 || GetPlayerProgressBarValue(playerid,ThuocLao[playerid][tlBar]) <= 0.0)
    {
		ApplyAnimation(playerid, "SUNBATHE", "BATHERDOWN", 4.0, 0, 0, 0, 1, 0);
		SetTimerEx("TLDungDay",5000,0,"i",playerid);
  		NgungHut(playerid);
  		SetPlayerAttachedObject(playerid, 8, 3044, 2, -0.0089, 0.1399, -0.0150, 177.1999, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0xFFFFFFFF, 0xFFFFFFFF); // CIGAR attached to the Head of Gasman
    }
    else
    {
    	SetTimerEx("DangKeoThuoc",1000,0,"i",playerid);
    }
	return 1;
}
forward TLDungDay(playerid);
public TLDungDay(playerid)
{
	RemovePlayerAttachedObject(playerid,8);
    ApplyAnimation(playerid, "SUNBATHE", "SITNWAIT_OUT_W", 4.0, 0, 0, 0, 0, 0);
    SetTimerEx("PheThuocLao",3000,0,"ii",playerid,1);
	return 1;
}
forward PheThuocLao(playerid,type);
public PheThuocLao(playerid,type)
{
	GameTextForPlayer(playerid,"PHE THUOC",1000,6);
	if(type == 1)
	{
		ApplyAnimation(playerid, "CRACK", "BBALBAT_IDLE_01", 4.0, 0, 0, 0, 0, 0);
		SetTimerEx("PheThuocLao",5000,0,"ii",playerid,2);
	}
	else if(type ==2)
	{
	    ApplyAnimation(playerid, "CRACK", "BBALBAT_IDLE_02", 4.0, 0, 0, 0, 0, 0); // phe2
	    SetPlayerHealth(playerid,100);
	    switch(random(3))
	    {
	        case 1:SetTimerEx("ShockThuoc",3000,0,"ii",playerid,1);
	    }
	}
	return 1;
}
forward ShockThuoc(playerid,type);
public ShockThuoc(playerid,type)
{
    GameTextForPlayer(playerid,"SHOCK THUOC",1000,6);
	if(type == 1)
	{
	    switch(random(2))
	    {
		case 0:ApplyAnimation(playerid, "CRACK", "CRCKDETH3", 4.0, 0, 0, 0, 1, 0); // shock
		case 1:ApplyAnimation(playerid, "CRACK", "CRCKIDLE3", 4.0, 0, 0, 0, 1, 0); // shock2
		}
		SetTimerEx("ShockThuoc",3000,0,"ii",playerid,2);
	}
	else if(type == 2)
	{
	    ApplyAnimation(playerid, "SUNBATHE", "PARKSIT_W_OUT", 4.0, 0, 0, 0, 0, 0); // shockdungday
	}
	return 1;
}
stock NgungHut(playerid)
{
    ThuocLao[playerid][tlDangHut] = 0;
    ThuocLao[playerid][tlProgress] = 0.0;
    ThuocLao[playerid][tlSai] = 0;
    for(new i =0;i<7;i++)
	{
		PlayerTextDrawHide(playerid,TextThuocLao[playerid][i]);
	}
	HidePlayerProgressBar(playerid,ThuocLao[playerid][tlBar]);
	RemovePlayerAttachedObject(playerid,5);
	RemovePlayerAttachedObject(playerid,6);
	RemovePlayerAttachedObject(playerid,7);
	RemovePlayerAttachedObject(playerid,8);
	RemovePlayerAttachedObject(playerid,9);
	return 1;
}
stock BatDauHut(playerid)
{
    ThuocLao[playerid][tlDangHut] = 1;
    ThuocLao[playerid][tlProgress] = 0.0;
    ThuocLao[playerid][tlSai] = 0;
    SetPlayerArmedWeapon(playerid,0);
    ApplyAnimation(playerid, "BUDDY", "BUDDY_CROUCHRELOAD", 4.0, 0, 0, 0, 1, 0); // hut
    SetPlayerAttachedObject(playerid, 5, 1666, 1, 0.2487, 0.4408, 0.1939, 127.0998, 21.3999, 11.7999, 0.6620, 0.7839, 3.5720, 0xFFFFFFFF, 0xFFFFFFFF); // propbeerglass1 attached to the Spine of Gasman
	SetPlayerAttachedObject(playerid, 6, 1942, 1, 0.2558, 0.5037, 0.2409, 34.2000, 0.0000, 112.1998, 0.0637, 0.6539, 0.0599, 0xFFFFFFFF, 0xFFFFFFFF); // kg50 attached to the Spine of Gasman
	SetPlayerAttachedObject(playerid, 7, 1942, 1, 0.1490, 0.6419, 0.3479, 33.5000, 7.4998, 21.7999, 0.0860, 0.4699, 0.0920, 0xFFFFFFFF, 0xFFFFFFFF); // kg50 attached to the Spine of Gasman
	SetPlayerAttachedObject(playerid, 8, 18673, 1, 0.3449, -0.3939, -1.0950, -34.4000, -1.2999, 101.3000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF); // cigarette_smoke attached to the Spine of Gasman
	SetPlayerAttachedObject(playerid, 9, 1933, 5, 0.0777, 0.0399, -0.0368, 0.0000, 0.0000, 0.0000, 0.1620, 0.0419, 0.5529, 0xFFFFFFFF, 0xFFFFFFFF); // chip_stack16 attached to the Left Hand of Gasman
    SetPlayerProgressBarValue(playerid,ThuocLao[playerid][tlBar],ThuocLao[playerid][tlProgress]);
    PlayerTextDrawSetString(playerid,TextThuocLao[playerid][2],"Dang bat dau...");
    PlayerTextDrawSetString(playerid,TextThuocLao[playerid][5],"Sai 0/2");
	for(new i =0;i<7;i++)
	{
		PlayerTextDrawShow(playerid,TextThuocLao[playerid][i]);
	}
	ShowPlayerProgressBar(playerid,ThuocLao[playerid][tlBar]);
	RandomTLKey(playerid);
	return 1;
}
stock RandomTLKey(playerid)
{
    switch(random(2))
	{
		case 0:
		{
		ThuocLao[playerid][tlKey] = KEY_FIRE;
		PlayerTextDrawColor(playerid,TextThuocLao[playerid][3],-16776961);
		PlayerTextDrawColor(playerid,TextThuocLao[playerid][4],-1);
		PlayerTextDrawShow(playerid,TextThuocLao[playerid][3]);
		PlayerTextDrawShow(playerid,TextThuocLao[playerid][4]);
		}
		case 1:
		{
		ThuocLao[playerid][tlKey] = KEY_HANDBRAKE;
		PlayerTextDrawColor(playerid,TextThuocLao[playerid][4],-16776961);
		PlayerTextDrawColor(playerid,TextThuocLao[playerid][3],-1);
		PlayerTextDrawShow(playerid,TextThuocLao[playerid][3]);
		PlayerTextDrawShow(playerid,TextThuocLao[playerid][4]);
		}
	}
	return 1;
}
stock LoadThuocLaoText(playerid)
{
	TextThuocLao[playerid][0] = CreatePlayerTextDraw(playerid,45.000000, 264.000000, "Thuoc lao");
	PlayerTextDrawBackgroundColor(playerid,TextThuocLao[playerid][0], 0);
	PlayerTextDrawFont(playerid,TextThuocLao[playerid][0], 0);
	PlayerTextDrawLetterSize(playerid,TextThuocLao[playerid][0], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,TextThuocLao[playerid][0], 255);
	PlayerTextDrawSetOutline(playerid,TextThuocLao[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid,TextThuocLao[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid,TextThuocLao[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid,TextThuocLao[playerid][0], 0);

	TextThuocLao[playerid][1] = CreatePlayerTextDraw(playerid,49.000000, 277.000000, "_");
	PlayerTextDrawBackgroundColor(playerid,TextThuocLao[playerid][1], 255);
	PlayerTextDrawFont(playerid,TextThuocLao[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid,TextThuocLao[playerid][1], 0.500000, 6.000000);
	PlayerTextDrawColor(playerid,TextThuocLao[playerid][1], -1);
	PlayerTextDrawSetOutline(playerid,TextThuocLao[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid,TextThuocLao[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid,TextThuocLao[playerid][1], 1);
	PlayerTextDrawUseBox(playerid,TextThuocLao[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid,TextThuocLao[playerid][1], 103);
	PlayerTextDrawTextSize(playerid,TextThuocLao[playerid][1], 127.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid,TextThuocLao[playerid][1], 0);

	TextThuocLao[playerid][2] = CreatePlayerTextDraw(playerid,48.000000, 276.000000, "Dang bat dau...");
	PlayerTextDrawBackgroundColor(playerid,TextThuocLao[playerid][2], 255);
	PlayerTextDrawFont(playerid,TextThuocLao[playerid][2], 0);
	PlayerTextDrawLetterSize(playerid,TextThuocLao[playerid][2], 0.419999, 1.100000);
	PlayerTextDrawColor(playerid,TextThuocLao[playerid][2], -1);
	PlayerTextDrawSetOutline(playerid,TextThuocLao[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid,TextThuocLao[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid,TextThuocLao[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid,TextThuocLao[playerid][2], 0);

	TextThuocLao[playerid][3] = CreatePlayerTextDraw(playerid,51.000000, 292.000000, "LMB");
	PlayerTextDrawBackgroundColor(playerid,TextThuocLao[playerid][3], 255);
	PlayerTextDrawFont(playerid,TextThuocLao[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid,TextThuocLao[playerid][3], 0.419999, 1.100000);
	PlayerTextDrawColor(playerid,TextThuocLao[playerid][3], -16776961);
	PlayerTextDrawSetOutline(playerid,TextThuocLao[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid,TextThuocLao[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid,TextThuocLao[playerid][3], 0);

	TextThuocLao[playerid][4] = CreatePlayerTextDraw(playerid,91.000000, 292.000000, "RMB");
	PlayerTextDrawBackgroundColor(playerid,TextThuocLao[playerid][4], 255);
	PlayerTextDrawFont(playerid,TextThuocLao[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid,TextThuocLao[playerid][4], 0.419999, 1.100000);
	PlayerTextDrawColor(playerid,TextThuocLao[playerid][4], -1);
	PlayerTextDrawSetOutline(playerid,TextThuocLao[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid,TextThuocLao[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid,TextThuocLao[playerid][4], 0);

	TextThuocLao[playerid][5] = CreatePlayerTextDraw(playerid,49.000000, 306.000000, "Sai : 0/2");
	PlayerTextDrawBackgroundColor(playerid,TextThuocLao[playerid][5], 255);
	PlayerTextDrawFont(playerid,TextThuocLao[playerid][5], 0);
	PlayerTextDrawLetterSize(playerid,TextThuocLao[playerid][5], 0.390000, 0.899999);
	PlayerTextDrawColor(playerid,TextThuocLao[playerid][5], -1);
	PlayerTextDrawSetOutline(playerid,TextThuocLao[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid,TextThuocLao[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid,TextThuocLao[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid,TextThuocLao[playerid][5], 0);

	TextThuocLao[playerid][6] = CreatePlayerTextDraw(playerid,47.000000, 332.000000, "by Gasman");
	PlayerTextDrawBackgroundColor(playerid,TextThuocLao[playerid][6], 0);
	PlayerTextDrawFont(playerid,TextThuocLao[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid,TextThuocLao[playerid][6], 0.210000, 0.899999);
	PlayerTextDrawColor(playerid,TextThuocLao[playerid][6], 68);
	PlayerTextDrawSetOutline(playerid,TextThuocLao[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid,TextThuocLao[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid,TextThuocLao[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid,TextThuocLao[playerid][6], 0);

	return 1;
}
stock PreloadAnimThuocLao(playerid)
{
    ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_CROUCH_IN", 4.0, 0, 0, 0, 1, 0); // keothuoc
    ApplyAnimation(playerid, "BUDDY", "BUDDY_CROUCHRELOAD", 4.0, 0, 0, 0, 1, 0); // hut
	ApplyAnimation(playerid, "SUNBATHE", "BATHERDOWN", 4.0, 0, 0, 0, 1, 0); // NamXuongXiKhoi
	ApplyAnimation(playerid, "SUNBATHE", "SITNWAIT_OUT_W", 4.0, 0, 0, 0, 0, 0); // dungday
	ApplyAnimation(playerid, "CRACK", "BBALBAT_IDLE_01", 4.0, 0, 0, 0, 0, 0); // phe1
	ApplyAnimation(playerid, "CRACK", "BBALBAT_IDLE_02", 4.0, 0, 0, 0, 0, 0); // phe2
	ApplyAnimation(playerid, "CRACK", "CRCKDETH3", 4.0, 0, 0, 0, 1, 0); // shock
	ApplyAnimation(playerid, "CRACK", "CRCKIDLE3", 4.0, 0, 0, 0, 1, 0); // shock2
	ApplyAnimation(playerid, "SUNBATHE", "PARKSIT_W_OUT", 4.0, 0, 0, 0, 0, 0); // shockdungday
	ApplyAnimation(playerid, "FAT", "IDLE_TIRED", 4.0, 0, 0, 0, 0, 3000); // sacthuoc
	return 1;
}
