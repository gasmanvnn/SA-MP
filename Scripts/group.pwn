#include <a_samp>
#include <easydb>
#include <zcmd>
#include <sscanf2>
new Group_Table;
new GroupMember_Table;
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Group system by Gasman Loaded");
	print("--------------------------------------\n");
	DB_Open("Group.db");
	Group_Table = DB_VerifyTable("Groups","id");
	GroupMember_Table = DB_VerifyTable("GroupMembers","id");
	DB_VerifyColumn(Group_Table,"GroupName", DB_TYPE_STRING,"");
	DB_VerifyColumn(Group_Table,"GroupMotd", DB_TYPE_STRING,"");
	////////////////////////////////////////////////////////////
	DB_VerifyColumn(GroupMember_Table,"UserName", DB_TYPE_STRING,"");
	DB_VerifyColumn(GroupMember_Table,"GroupName", DB_TYPE_STRING,"");
	DB_VerifyColumn(GroupMember_Table,"GroupLeader",DB_TYPE_NUMBER,0);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}
public OnPlayerSpawn(playerid)
{
    if(IsPlayerInGroup(playerid) == 1)
    {
  		new id = DB_RetrieveKey(Group_Table,"GroupName",GetPlayerGroup(playerid));
    	if(id != DB_INVALID_KEY)
    	{
			new str[256],motd[128];
			DB_GetStringEntry(Group_Table, id,"GroupMotd",motd);
			format(str,sizeof(str),"{F81414}[GROUP MOTD]: {00C0FF}%s",motd);
			SendClientMessage(playerid,-1,str);
   		}
    }
	return 1;
}
CMD:grouphelp(playerid,params[])
{
	SendClientMessage(playerid,-1,"{F81414}----------------------------------{6EF83C}GROUP HELP{F81414}-----------------------------------");
	SendClientMessage(playerid,-1,"{00C0FF}/creategroup, /invitegroup, /kickgroup");
	SendClientMessage(playerid,-1,"{00C0FF}/acceptgroup, /leavegroup, /gc, /groupmember");
	SendClientMessage(playerid,-1,"{00C0FF}/deletegroup, /makegroupleader, /changegroupmotd");
	return 1;
}
CMD:groupmember(playerid,params[])
{
	new gname[30],pname[MAX_PLAYER_NAME+1],str[1024],str2[128],id, query[256];
	if(sscanf(params,"s[30]",gname)) return SendClientMessage(playerid,-1,"/groupmember [group name]");
	if(strlen(gname) > 30)return SendClientMessage(playerid,-1,"Name of group max is 30 Char");
	new DBResult:result;
	id = DB_RetrieveKey(Group_Table,"GroupName",gname);
 	if(id != DB_INVALID_KEY)
  	{
	format(query, sizeof query, "SELECT * FROM `GroupMembers` WHERE `GroupName`='%s'", DB::Escape(gname));
	result = DB::Query(query);
	for(new a;a<db_num_rows(result);a++)
	{
	    db_get_field_assoc(result, "UserName", pname, sizeof pname);
		strcat(str,pname);
  		strcat(str,"\n");
		db_next_row(result);
	}
	format(str2,sizeof(str2),"Member Group : %s",gname);
	ShowPlayerDialog(playerid,1337,0,str2,str,"Close","");
	}
	else SendClientMessage(playerid,-1,"Invalid Group name");
	return 1;
}
CMD:creategroup(playerid,params[])
{
	new name[30],motd[128];
	if(sscanf(params,"s[30]s[128]",name,motd)) return SendClientMessage(playerid,-1,"/creategroup [name] [motd]");
	if(IsPlayerInGroup(playerid) == 1) return SendClientMessage(playerid,-1,"You already in group");
	if(strlen(name) > 30)return SendClientMessage(playerid,-1,"Name of group max is 30 Char");
	new id = DB_RetrieveKey(Group_Table,"GroupName",name);
	if(id != DB_INVALID_KEY) return SendClientMessage(playerid,-1,"Name group is already used");
	CreateGroup(playerid,name,motd);
	return 1;
}
CMD:changegroupmotd(playerid,params[])
{
	new motd[128],str[256];
	if(IsPlayerInGroup(playerid) != 1) return SendClientMessage(playerid,-1,"You are not in group");
	if(IsPlayerGroupLeader(playerid) != 1) return SendClientMessage(playerid,-1,"You are not group leader");
	if(sscanf(params,"s[128]",motd))return SendClientMessage(playerid,-1,"/changegroupmotd [motd]");
	new id = DB_RetrieveKey(Group_Table,"GroupName",GetPlayerGroup(playerid));
	if(id != DB_INVALID_KEY)
	{
		DB_SetStringEntry(Group_Table,id,"GroupMotd",motd);
		format(str,sizeof(str),"Leader %s has change group motd",GetName(playerid));
		SendGroupMessage(GetPlayerGroup(playerid),str);
		format(str,sizeof(str),"[NEW MOTD]:{F81414} %s",motd);
		SendGroupMessage(GetPlayerGroup(playerid),str);
	}
	return 1;
}
CMD:kickgroup(playerid,params[])
{
    new userid;
	if(IsPlayerInGroup(playerid) != 1) return SendClientMessage(playerid,-1,"You are not in group");
	if(IsPlayerGroupLeader(playerid) != 1) return SendClientMessage(playerid,-1,"You are not group leader");
	if(sscanf(params,"u",userid))return SendClientMessage(playerid,-1,"/kickgroup [playerid]");
	if(!IsPlayerConnected(userid))return SendClientMessage(playerid,-1,"Invalid Player ID");
	if(userid == playerid) return SendClientMessage(playerid,-1,"You can not kick you");
	if(IsPlayerGroupLeader(userid) == 1) return SendClientMessage(playerid,-1,"You can not kick group leader");
	if(strcmp(GetPlayerGroup(playerid), GetPlayerGroup(userid), true, 30) == 0)
	{
		new id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(userid));
		if(id != DB_INVALID_KEY)
	    	DB_DeleteRow(GroupMember_Table,id);
		SendClientMessage(userid,-1,"You got kicked out of the group");
		SendClientMessage(playerid,-1,"You kicked player out group");
	}
	else SendClientMessage(playerid,-1,"Player not in your group");
	return 1;
}
CMD:makegroupleader(playerid,params[])
{
	new userid,make;
    if(IsPlayerInGroup(playerid) != 1) return SendClientMessage(playerid,-1,"You are not in group");
	if(IsPlayerGroupLeader(playerid) != 1) return SendClientMessage(playerid,-1,"You are not group leader");
	if(sscanf(params,"ui",userid,make))return SendClientMessage(playerid,-1,"/makegroupleader [playerid] [make 0-1]");
	if(!IsPlayerConnected(userid))return SendClientMessage(playerid,-1,"Invalid Player ID");
	if(userid == playerid) return SendClientMessage(playerid,-1,"You can not make you");
	if(strcmp(GetPlayerGroup(playerid), GetPlayerGroup(userid), true, 30) == 0)
	{
		new id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(userid));
		if(id != DB_INVALID_KEY)
	    	DB_SetIntEntry(GroupMember_Table,id,"GroupLeader",make);
		SendClientMessage(userid,-1,"You've become Group leader");
		SendClientMessage(playerid,-1,"You Make player become group leader");
	}
	else SendClientMessage(playerid,-1,"Player not in your group");
	return 1;
}
CMD:invitegroup(playerid,params[])
{
	new userid,str[128];
	if(IsPlayerInGroup(playerid) != 1) return SendClientMessage(playerid,-1,"You are not in group");
	if(IsPlayerGroupLeader(playerid) != 1) return SendClientMessage(playerid,-1,"You are not group leader");
	if(sscanf(params,"u",userid))return SendClientMessage(playerid,-1,"/invitegroup [playerid]");
	if(!IsPlayerConnected(userid))return SendClientMessage(playerid,-1,"Invalid Player ID");
	if(userid == playerid) return SendClientMessage(playerid,-1,"You can not invite you");
	if(IsPlayerInGroup(userid) == 1) return SendClientMessage(playerid,-1,"Player already in any group");
	format(str,sizeof(str),"%s has invited you to group %s (/acceptgroup) to accept suggestion",GetName(playerid),
	GetPlayerGroup(playerid));
	SendClientMessage(userid,-1,str);
	SetPVarInt(userid,"InviteGroup",1);
	SetPVarString(userid,"InviteGroupName",GetPlayerGroup(playerid));
	return 1;
}
CMD:acceptgroup(playerid,params[])
{
	if(GetPVarInt(playerid,"InviteGroup") != 1) return SendClientMessage(playerid,-1,"You do not receive invitations.");
	new namegroup[30];
	GetPVarString(playerid,"InviteGroupName",namegroup,sizeof(namegroup));
	
	new id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
	if(id != DB_INVALID_KEY)
	    DB_DeleteRow(GroupMember_Table,id);

	DB_CreateRow(GroupMember_Table,"UserName",GetName(playerid));
	id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
    DB_SetStringEntry(GroupMember_Table,id,"GroupName",namegroup,30);
    DB_SetIntEntry(GroupMember_Table,id,"GroupLeader",0);
	return 1;
}
CMD:leavegroup(playerid,params[])
{
    if(IsPlayerInGroup(playerid) != 1) return SendClientMessage(playerid,-1,"You are not in group");
    if(IsPlayerGroupLeader(playerid) == 1) return SendClientMessage(playerid,-1,"Leader can not leave group /deletegroup");
    new id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
	if(id != DB_INVALID_KEY)
	    DB_DeleteRow(GroupMember_Table,id);
	return 1;
}
CMD:deletegroup(playerid,params[])
{
    if(IsPlayerInGroup(playerid) != 1) return SendClientMessage(playerid,-1,"You are not in group");
    if(IsPlayerGroupLeader(playerid) != 1) return SendClientMessage(playerid,-1,"You are not group leader");
    new gname[30];
    format(gname,sizeof(gname),"%s",GetPlayerGroup(playerid));
    new id = DB_RetrieveKey(Group_Table,"GroupName",gname);
    if(id != DB_INVALID_KEY)
        DB_DeleteRow(Group_Table,id);
	for(new i = 0, j = DB::CountRows(GroupMember_Table); i < j; i++)
	{
        id = DB_RetrieveKey(GroupMember_Table,"GroupName",gname);
        if(id != DB_INVALID_KEY)
        {
        DB_DeleteRow(GroupMember_Table,id);
        }
	}
	new str[128];
	format(str,sizeof(str),"You has been delete group %s",gname);
	SendClientMessage(playerid,-1,str);
	return 1;
}
CMD:groupchat(playerid,params[]) return cmd_gc(playerid,params);
CMD:gc(playerid,params[])
{
    if(IsPlayerInGroup(playerid) != 1) return SendClientMessage(playerid,-1,"You are not in group");
    new text[128],str[256];
    if(sscanf(params,"s[128]",text)) return SendClientMessage(playerid,-1,"/gc [text]");
    if(IsPlayerGroupLeader(playerid) == 1)
    {
    format(str,sizeof(str),"{6EF83C}[GC-%s]{F81414}[LEADER]{FFFFFF}%s :{00C0FF} %s",GetPlayerGroup(playerid),GetName(playerid),text);
    }
    else
    {
    format(str,sizeof(str),"{6EF83C}[GC-%s]{F3FF02}[MEMBER]{FFFFFF}%s :{00C0FF} %s",GetPlayerGroup(playerid),GetName(playerid),text);
    }
    SendGroupMessage(GetPlayerGroup(playerid),str);
	return 1;
}
stock CreateGroup(playerid,namegroup[],motdgroup[])
{
	new id = DB_RetrieveKey(Group_Table,"GroupName",namegroup);
	if(id != DB_INVALID_KEY) return 1;
	DB_CreateRow(Group_Table,"GroupName",namegroup);
	id = DB_RetrieveKey(Group_Table,"GroupName",namegroup);
	DB_SetStringEntry(Group_Table,id,"GroupMotd",motdgroup,128);
	
	id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
	if(id != DB_INVALID_KEY)
	    DB_DeleteRow(GroupMember_Table,id);
    DB_CreateRow(GroupMember_Table,"UserName",GetName(playerid));
    id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
    DB_SetStringEntry(GroupMember_Table,id,"GroupName",namegroup,30);
    DB_SetIntEntry(GroupMember_Table,id,"GroupLeader",1);
	return 1;
}
stock SendGroupMessage(group[],message[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerInGroup(i) == 1)
		{
			if(IsPlayerConnected(i) == 1)
			{
				if(strcmp(group, GetPlayerGroup(i), true, 30) == 0)
				{
					SendClientMessage(i, -1,message);
				}
			}
		}
	}
	return 1;
}
stock IsPlayerInGroup(playerid)
{
	new id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
	if(id != DB_INVALID_KEY) return 1;
	return 0;
}
stock IsPlayerGroupLeader(playerid)
{
    new id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
	if(id != DB_INVALID_KEY)
	{
	    if(DB_GetIntEntry(GroupMember_Table,id,"GroupLeader") == 1)
	    {
	    	return 1;
	    }
	}
	return 0;
}
stock GetPlayerGroup(playerid)
{
	new name[30];
    new id = DB_RetrieveKey(GroupMember_Table,"UserName",GetName(playerid));
	if(id != DB_INVALID_KEY)
	{
	    DB_GetStringEntry(GroupMember_Table,id,"GroupName",name);
	}
	return name;
}
stock GetName(playerid)
{
    new szpName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, szpName, MAX_PLAYER_NAME);
    return szpName;
}
