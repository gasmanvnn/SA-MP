/*
GiftCode system by Gasman
*/

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <ssi-ini>
forward SuDungGiftCode(playerid,type);
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("GiftCode system");
	print("--------------------------------------\n");
	if(!fexist("GiftCode.ini"))
 	{
 	file_Create("GiftCode.ini");
 	}
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
public SuDungGiftCode(playerid,type)
{
	if(type == 1)
	{
	    GivePlayerMoney(playerid,1000);
	    return 1;
	}
	else if(type == 2)
	{
	    GivePlayerMoney(playerid,2000);
	    return 1;
	}
	return 1;
}
CMD:giftcode(playerid,params[])
{
	if(GetPVarInt(playerid,"DaSuDungGiftCode") == 1) return SendClientMessage(playerid,-1,"Ban da su dung gift code");
	new giftcode[128];
	if(sscanf(params,"s[128]",giftcode)) return SendClientMessage(playerid,-1,"/giftcode [code]");
	file_Open("GiftCode.ini");
	if(file_IsKey(giftcode))
	{
	CallLocalFunction("SuDungGiftCode","ii",playerid,file_GetVal(giftcode));
	file_RemoveKey(giftcode);
	}
	else
	{
	SendClientMessage(playerid,-1,"Gift code sai hoac da duoc su dung");
	}
	file_Save("GiftCode.ini");
	file_Close();
	return 1;
}
CMD:addgcode(playerid,params[])
{
	new codestring[128],type;
	if(sscanf(params,"s[128]i",codestring,type)) return SendClientMessage(playerid,-1,"/addgcode [GiftCode] [type]");
 	if(!fexist("GiftCode.ini"))
 	{
 	file_Create("GiftCode.ini");
 	}
 	file_Open("GiftCode.ini");
 	file_SetVal(codestring,type);
 	file_Save("GiftCode.ini");
 	file_Close();
 	new string[128];
 	format(string,sizeof(string),"%s |Type :%d",codestring,type);
 	SendClientMessage(playerid,-1,"Ban da add gift code: ");
	SendClientMessage(playerid,-1,string);
	return 1;
}
CMD:removegcode(playerid,params[])
{
    new codestring[128];
	if(sscanf(params,"s[128]",codestring)) return SendClientMessage(playerid,-1,"/removegcode [GiftCode]");
	file_Open("GiftCode.ini");
	if(file_IsKey(codestring))
	{
	SendClientMessage(playerid,-1,"Da remove ma giftcode");
	file_RemoveKey(codestring);
	}
	else
	{
	SendClientMessage(playerid,-1,"Ma khong hop le");
	}
	file_Save("GiftCode.ini");
	file_Close();
	return 1;
}
