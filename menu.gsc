#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include scripts\utils;
#include scripts\main;
#include scripts\functions;


menuinit()
{
    self.menu = SpawnStruct();
    self.hud = SpawnStruct();
    self.menu.isopen = false;
    self.smoothscroll = false;
    self.scrolly = -100;
    self structure();
    self thread buttons();
}



buttons()
{
    self endon("death");
    while(true)
    {
        if(!self.menu.isopen)
        {
            if(self adsbuttonpressed() && self meleeButtonPressed())
            {
                self.menu.isopen = true;
                self MenuHud();
                self load_menu("main");
                self notify("menuopened");
                wait 0.1;
            }
        }
        else
        {
            if(self isButtonPressed("+actionslot 1"))
            {
                self.scroll--;
                self UpdateScroll();
                wait .1;
            }
            
            if(self isButtonPressed("+actionslot 2"))
            {
                self.scroll++;
                self UpdateScroll();

                wait .1;
            }
            
            if(self usebuttonpressed())
            { 
                self ExecuteFunction(self.menu.func[self.menu.current][self.scroll],self.menu.input[self.menu.current][self.scroll],self.menu.input2[self.menu.current][self.scroll]);
                self notify("selectedoption");    
                self structure();
                self load_menu(self.menu.current);    
                wait .2;
            }
            
            if(self meleebuttonpressed())
            {
                if(self.menu.parent[self.menu.current] == "exit")
                {
                    self DestroyHud();
                    self.menu.isopen = false;
                    self notify("closedmenu");
                }
                else
                {
                    self load_menu(self.menu.parent[self.menu.current]);
                    waitframe();
                }

                wait .2;
            }
        }
        waitframe();
    }
}

UpdateScroll()
{
    if ( self.scroll < 0 )
        self.scroll = self.menu.text[self.menu.current].size - 1;

    if ( self.scroll > self.menu.text[self.menu.current].size - 1 )
        self.scroll = 0;

    if ( !isdefined( self.menu.text[self.menu.current][self.scroll - 5] ) || self.menu.text[self.menu.current].size <= 10 )
    {
        for ( i = 0; i < 10; i++ )
        {
            if ( isdefined( self.menu.text[self.menu.current][i] ) )
                self.hud.option[i] = self.menu.text[self.menu.current][i];
            else
                self.hud.option[i] = "";
        }

        self.hud.scroll.y = -97 + (9.65 * self.scroll);

        


    }
    else if ( isdefined( self.menu.text[self.menu.current][self.scroll + 5] ) )
    {
        index = 0;

        for ( i = self.scroll - 5; i < self.scroll + 5; i++ )
        {
            if ( isdefined( self.menu.text[self.menu.current][i] ) )
                self.hud.option[index] = self.menu.text[self.menu.current][i];
            else
                self.hud.option[index] = "  ";
            index++;

        }

        self.hud.scroll.y = -97 + (9.65 * 5);

    }
    else
    {
        for ( i = 0; i < 10; i++ )
        {
            self.hud.option[i] = self.menu.text[self.menu.current][self.menu.text[self.menu.current].size + i - 10];
        }

        self.hud.scroll.y = -97 + 9.65 * ( self.scroll - self.menu.text[self.menu.current].size + 10 );

    }
    self.hud.text SetText(self.hud.option[0] + "\n" + self.hud.option[1] + "\n" + self.hud.option[2] + "\n" + self.hud.option[3] + "\n" + self.hud.option[4] + "\n" + self.hud.option[5] + "\n" + self.hud.option[6] + "\n" + self.hud.option[7] + "\n" + self.hud.option[8] + "\n" + self.hud.option[9]);
    countoverflow(self.hud.option[0] + "\n" + self.hud.option[1] + "\n" + self.hud.option[2] + "\n" + self.hud.option[3] + "\n" + self.hud.option[4] + "\n" + self.hud.option[5] + "\n" + self.hud.option[6] + "\n" + self.hud.option[7] + "\n" + self.hud.option[8] + "\n" + self.hud.option[9]);
    
}

menuhud()
{
    self.hud.background = self createRectangle("TOP", "CENTER", 185, -130, 170, 200, (0,0,0), 0.9, 0, "white");
    self.hud.scroll = self createRectangle("TOP", "CENTER", 185, -97, 180, 11, (0.827,0.451,0.569), 1, 1, "white");
    self.hud.leftbar = self createRectangle("TOP", "CENTER", 95, -131, 2, 200, (0.827,0.451,0.569), 0.9, 1, "white");
    self.hud.rightbar = self createRectangle("TOP", "CENTER", 275, -131, 2, 200, (0.827,0.451,0.569), 0.9, 1, "white");
    self.hud.middlebar = self createRectangle("TOP", "CENTER", 185, -102, 180, 2, (0.827,0.451,0.569), 1, 1, "white");
    self.hud.topbar = self createRectangle("TOP", "CENTER", 185, -131, 180, 2, (0.827,0.451,0.569), 1, 1, "white");
    self.hud.bottombar = self createRectangle("TOP", "CENTER", 185, -131, 180, 2, (0.827,0.451,0.569), 1, 1, "white");
    self.hud.menutitle = self createText("objective", 1, "CENTER", "CENTER", 180, -115, 2, (1,1,1), 1, "^:Trustfall");
    self.hud.text = self createText("objective", 0.8, "LEFT", "CENTER", 100, -91, 2.3, (1,1,1), 1, "placeholder");
}
//createText(font, fontscale, align, relative, x, y, sort, color, alpha, text) 

updabackground()
{
    count = self.menu.text[self.menu.current].size;
    if(count > 10)
    count = 10;
    self.hud.background SetShader("white", 180, 38 + ( count * 10 ));
    self.hud.leftbar SetShader("white", 2, 40 + ( count * 10 ));
    self.hud.rightbar SetShader("white", 2, 40 + ( count * 10 ));
    self.hud.bottombar.y =  -93 + (count * 10);
}


destroyhud()
{
    self.hud.background destroy();
    self.hud.middlebar destroy();
    self.hud.topbar destroy();
    self.hud.rightbar destroy();
    self.hud.leftbar destroy();
    self.hud.bottombar destroy();
    self.hud.scroll Destroy();
    self.hud.menutitle destroy();
    self.hud.text Destroy();
}


Structure()
{
    self create_menu("main", "exit");
    self add_option("main",  "Misc", ::load_menu,undefined,"Misc");
    self add_option("main",  "Toggles", ::load_menu,undefined,"Toggles");
    self add_option("main",  "Aimbot", ::load_menu,undefined,"Aimbot");
    self add_option("main",  "Weapons", ::load_menu,undefined,"Weapons");
    self add_option("main",  "Binds", ::load_menu,undefined,"Binds");
    self add_option("main",  "Lobby", ::load_menu,undefined,"Lobby");
    self add_option("main",  "Players", ::load_menu,undefined,"Players");

    self create_menu("Misc", "main");
    self add_option("Misc","Give Vish", ::givevish);
    self add_option("Misc","Spawn Bounce", ::spawnbounce);
    self add_option("Misc","Delete Bounce", ::deletebounce);
    self add_option("Misc","Give Cowboy", ::givecowboy);
    self add_option("Misc","Give $6000", ::givedamoney);
    self add_option("Misc","Give 5 Skill Points", ::givedapoints);

    self create_menu("Binds", "main");
    self add_option("Binds","Nac Mod", ::load_menu,undefined,"Nac Mod");
    self add_option("Binds","Instaswap", ::load_menu,undefined,"Instaswap");
    self add_option("Binds","CCB", ::load_menu,undefined,"CCB");
    self add_option("Binds","Bolt Movement", ::load_menu,undefined,"Bolt Movement");
    self add_option("Binds","Scavenger", ::load_menu,undefined,"Scavenger");
    self add_option("Binds","Velocity", ::load_menu,undefined,"Velocity");
    self add_option("Binds","Equipment", ::load_menu,undefined,"Equipment");
    self add_option("Binds","Animations", ::load_menu,undefined,"Animations");
    self add_option("Binds","OMA", ::load_menu,undefined,"OMA");
    self add_bind("Binds","Canswap",::canswapbind,"canswap");
    self add_bind("Binds","Illusion",::illusionbind,"illusion");
    self add_bind("Binds","Altswap",::altswapbind,"altswap");
    self add_bind("Binds","Houdini",::houdinibind,"houdini");
    self add_bind("Binds","Mala",::malabind,"mala");
    self add_bind("Binds","Hitmarker",::hitmarkerbind,"hitmarker");
    self add_bind("Binds","Damage",::damagebind,"damage");
    self add_bind("Binds","Pred Vision",::predvisionbind,"predvision");
    self add_bind("Binds","Static Vision",::staticvisionbind,"staticvision");
    self add_bind("Binds","Gryphon Vision",::gryphonvisionbind,"gryphonvision");
    self add_bind("Binds","EMP",::empbind,"emp");
    self add_bind("Binds","Flash",::flashbind,"flash");
    self add_bind("Binds","STZ Tilt",::stztiltbind,"stztiltbind");
    self add_bind("Binds","Gunlock",::gunlockbind,"gunlock");
    self add_bind("Binds","Jspin",::jspinbind,"jspin");
    self add_bind("Binds","Carepackage Stall",::carepackstallbind,"carepackstall");
    self add_bind("Binds","Links Jitter",::linksjitterbind,"linksjitter");

    self create_menu("OMA", "Binds");
    self add_option("OMA","Bar Time", ::changeomatime,"[" + getdvarfloat("omatime") + "]");
    self add_bind("OMA","OMA Bar",::omabarbind,"omabar");
    self add_bind("OMA","OMA Shax",::omashaxbind,"omashax");
    self add_bind("OMA","OMA Sprint",::omasprintbind,"omasprint");

    self create_menu("Equipment", "Binds");
    self add_option("Equipment","Weapon", ::changeeqbindweap,"[" + getdvar("eqbindweap") + "]");
    self add_option("Equipment","Putaway", ::toggleeqbindputaway,getdvar("eqbindputaway"));
    self add_bind("Equipment","Bind",::eqbind,"eqbind");

    self create_menu("Velocity", "Binds");
    self add_option("Velocity","Dvar -> velocity", ::veloplaceholder);
    self add_bind("Velocity","Bind",::velocitybind,"velocitybind");

    self create_menu("Animations", "Binds");
    self add_bind("Animations","Sprint In",::sprintinbind,"sprintin");
    self add_bind("Animations","Sprint Loop",::sprintloopbind,"sprintloop");
    self add_bind("Animations","Slide",::slidebind,"slide");
    self add_bind("Animations","Glide",::glidebind,"glide");
    self add_bind("Animations","Reload",::reloadbind,"reload");
    self add_bind("Animations","Empty Reload",::emptyreloadbind,"emptyreload");
    self add_bind("Animations","Melee",::meleebind,"melee");
    self add_bind("Animations","Lunge",::lungebind,"lunge");
    self add_bind("Animations","Mantle",::mantlebind,"mantle");
    self add_bind("Animations","Smooth",::smoothbind,"smooth");

    self create_menu("Bolt Movement", "Binds");
    self add_option("Bolt Movement","Save Point", ::savebolt);
    self add_option("Bolt Movement","Delete Point", ::deletebolt,"[" + getDvarInt("function_boltcount") + "]");
    self add_option("Bolt Movement","Speed", ::boltspeed,"[" + getDvarfloat("bolttime") + "]");
    self add_bind("Bolt Movement","Bind",::boltbind,"bolt");
    self add_option("Bolt Movement","Record Movement", ::record_movement);
    self add_option("Bolt Movement","Remove Last Point", ::removepoint,"[" + self.pers["movpos"] + "]");
    self add_bind("Bolt Movement","Play Movement",::playmovementbind,"playmovementbind");

    self create_menu("CCB", "Binds");
    self add_bind("CCB","Bind",::changeclassbind,"ccb");
    self add_option("CCB","Wrap Limit", ::changeccblimit,"[" + getdvarint("ccblimit") + "]");
    self add_option("CCB","Canswaps", ::toggleccbcanswap,getdvar("ccbcanswap"));

    self create_menu("Instaswap", "Binds");
    self add_option("Instaswap","First Weapon", ::selectfirstinstaswap,"[" + getdvar("firstweaponinstaswapname") + "]");
    self add_option("Instaswap","Second Weapon", ::selectsecondinstaswap,"[" + getdvar("secondweaponinstaswapname") + "]");
    self add_bind("Instaswap","Bind",::instaswapbind,"instaswap");

    self create_menu("Nac Mod", "Binds");
    self add_option("Nac Mod","First Weapon", ::selectfirstnac,"[" + getdvar("firstweaponnacname") + "]");
    self add_option("Nac Mod","Second Weapon", ::selectsecondnac,"[" + getdvar("secondweaponnacname") + "]");
    self add_bind("Nac Mod","Bind",::nacbind,"nac");

    self create_menu("Scavenger", "Binds");
    self add_bind("Scavenger","Bind",::scavengerbind,"scavenger");
    self add_option("Scavenger","Real Scavenger", ::togglerealscavenger,getdvar("realscavenger"));


    self create_menu("Aimbot", "main");
    self add_option("Aimbot",  "Aimbot",::toggleaimbot,getdvar("aimbot"));
    self add_option("Aimbot",  "Aimbot Weapon",::selectaimbotweapon,"[" + getdvar("aimbot_weapon_name") + "]");
    self add_option("Aimbot",  "Aimbot Range",::changeaimbotrange,"[" + getdvarint("aimbot_range") + "]");
    self add_option("Aimbot",  "Hitmarker Aimbot",::togglehitmarkeraimbot,getdvar("hitmarkeraimbot"));
    self add_option("Aimbot",  "Hitmarker Aimbot Weapon",::hitmarkeraimbotweapon,"[" + getdvar("hitmarkeraimbotweaponname") + "]");
    self add_option("Aimbot",  "Equipment Aimbot",::eqaimbot,getdvar("eqaimbot"));
    self add_option("Aimbot",  "Equipment Aimbot Weapon",::selecteqaimbotweapon,"[" + getdvar("eqaimbotweaponname") + "]");
    self add_option("Aimbot",  "End Game Screen",::toggleendgame, getdvar("endgame"));

    self create_menu("Lobby", "main");
    self add_option("Lobby",  "Spawn Bot",::SpawnBot);
    self add_option("Lobby",  "Kick Bots",::kickbots);
    self add_option("Lobby",  "Bots To Crosshair",::botstoch);
    self add_option("Lobby",  "Bots Look At Me",::botslookatme);
    self add_option("Lobby",  "Gravity",::changegravity,"[" + getdvarint("g_gravity") + "]");
    self add_option("Lobby",  "Move Speed",::changemovespeed,"[" + getdvarint("g_speed") + "]");
    self add_option("Lobby",  "Timescale",::changetimescale,"[" + getdvarfloat("pantimescale") + "]");

    self create_menu("Toggles", "main");
    self add_option("Toggles",  "God Mode",::togglegodmode,getdvar("godmode"));
    self add_option("Toggles",  "Freeze Monsters",::togglefreezedumbass,getdvar("freezedumbass"));
    self add_option("Toggles",  "Noclip Bind",::toggleufobind,getdvar("ufobind"));
    if(getdvar("alwayscanswap") != "specific")
    self add_option("Toggles",  "Always Canswap",::togglealwayscanswap,getdvar("alwayscanswap"));
    else
    self add_option("Toggles",  "Always Canswap",::togglealwayscanswap,"[" + getdvar("canswapweaponname") + "]");

    self add_option("Toggles",  "Smooth Canswaps",::togglesmoothcanswaps,getdvar("smoothcanswaps"));
    self add_option("Toggles",  "Smooth Canswap Wait Time",::changesmoothcanswapwait,"[" + getdvarfloat("smoothcanswapwait") + "]");

    self add_option("Toggles",  "Instashoot",::toggleinstashoots,getdvar("instashoot"));


    if(getdvar("instashootweapon") == "[ALL]")
    self add_option("Toggles",  "Instashoot Weapon",::toggleinstashootweapon,getdvar("instashootweapon"));
    else
    self add_option("Toggles",  "Instashoot Weapon",::toggleinstashootweapon,"[" + getdvar("instashootweaponname") + "]");

    self add_option("Toggles",  "STZ Tilt",::togglestztilt,getdvar("stztilt"));
    self add_option("Toggles",  "Head Bounces",::toggleheadbounces,getdvar("headbounces"));
    self add_option("Toggles",  "Instaswaps",::toggleeqswap,getdvar("eqswap"));
    self add_option("Toggles",  "Instant Equipment",::toggleinstaeq,getdvar("instaeq"));
    self add_option("Toggles",  "Use Radius",::togglepickupradius,getdvar("dapickup"));
    self add_option("Toggles",  "Infinite Equipment",::toggleinfeq,getdvar("infeq"));

    self create_menu("Weapons", "main");
    self add_option("Weapons",  "Refill Ammo", ::refillammo);
    self add_option("Weapons",  "Drop Weapon", ::dropdagun);
    self add_option("Weapons",  "Take Weapon", ::takedaweapon);
    self add_option("Weapons",  "Guns", ::load_menu,undefined,"Guns");
    self create_menu("Guns", "Weapons");
    self add_option("Guns",  "RPG", ::givedaweapon,undefined,"alienspit_mp");
    self add_option("Guns",  "Soflam", ::givedaweapon,undefined,"aliensoflam_mp");
    self add_option("Guns",  "C4", ::givedaweapon,undefined,"breach_plant_mp");
    self add_option("Guns",  "RPG 2", ::givedaweapon,undefined,"alienrhinoslam_mp");
    self add_option("Guns",  "Semtex", ::givedaweapon,undefined,"alien_li_semtex_proj");
    self add_option("Guns",  "Shield", ::givedaweapon,undefined,"iw5_alienriotshield3_mp");
    self add_option("Guns",  "Shield 2", ::givedaweapon,undefined,"iw5_alienriotshield1_mp");
    self add_option("Guns",  "Javelin", ::givedaweapon,undefined,"switchblade_babyfast_mp");
    self add_option("Guns",  "Frag", ::givedaweapon,undefined,"alien_minion_explosion");
    self add_option("Guns",  "Betty", ::givedaweapon,undefined,"alienbetty_mp");
    self add_option("Guns",  "Trophy", ::givedaweapon,undefined,"alientrophy_mp");
    self add_option("Guns",  "Vector", ::givedaweapon,undefined,"alienmelee_mp");
    self add_option("Guns",  "Laptop", ::givedaweapon,undefined,"switchblade_laptop_mp");
    self add_option("Guns",  "Drone", ::givedaweapon,undefined,"alienbackupuav_mp");
    self add_option("Guns",  "Minigun", ::givedaweapon,undefined,"iw6_alienminigun4_mp");
    self add_option("Guns",  "Fun Gun", ::givedaweapon,undefined,"alienims_projectiledamage_mp");
    self add_option("Guns",  "Propane Tank", ::givedaweapon,undefined,"alienpropanetank_mp");
    self add_option("Guns",  "Canister", ::givedaweapon,undefined,"alienmortar_shell_mp");
    self add_option("Guns",  "Drill", ::givedaweapon,undefined,"alienbomb_mp");
    self add_option("Guns",  "VKS", ::givedaweapon,undefined,"iw6_alienvks_mp+vksscope");
    self add_option("Guns",  "Honey Badger", ::givedaweapon,undefined,"iw6_alienhoneybadger_mp");




    self create_menu("Players", "main");
    foreach(player in level.players)
    {
        self add_option("Players",  player.name, ::load_menu,undefined,player.name);
        self create_menu(player.name, "Players");
        self add_option(player.name, "Kick", ::kickdumbass,undefined,player);
        self add_option(player.name, "To Crosshair", ::playertocrosshair,undefined,player);
    }

}


