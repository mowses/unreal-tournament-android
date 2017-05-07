//=============================================================================
// example got from a "WoD Quad-ShotGun."
// http://wayback.archive.org/web/20010906213826/http://planetunreal.com:80/wod/tutorials/upgradables.html
//=============================================================================
class CustomFireWeapons expands TournamentPlayer;
var Pawn LocalPlayer;
var Bool AlreadyRunPostBeginPlay;

simulated function PostBeginPlay()
{
	if (AlreadyRunPostBeginPlay)
		return;

	AlreadyRunPostBeginPlay = True;

	getPlayer();
	Log("CustomFireWeapons.uc mod loaded");
	Super.PostBeginPlay();
}

function getPlayer()
{
	local Pawn P;
	
	for( P=Level.PawnList; P!=None; P=P.NextPawn )
	{
		if ( P.bIsPlayer && P.IsA('PlayerPawn') )
		{
			LocalPlayer = P;
			return;
		}
	}

	return;
}

function Fire(float Value)
{
	Log("CustomFireWeapons.uc WEAPON WAS FIRED");
    LocalPlayer.ClientMessage("Fire pressed");
}

function AltFire(float Value)
{
	Log("CustomFireWeapons.uc WEAPON WAS ALT-FIRED");
    LocalPlayer.ClientMessage("Alt Fire pressed");
}

exec function Foo()
{
	Log("CustomFireWeapons.uc FOO RUNS");
	LocalPlayer.ClientMessage("Foo runs!");
}