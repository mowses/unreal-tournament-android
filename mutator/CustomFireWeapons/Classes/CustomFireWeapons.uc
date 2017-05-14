//=============================================================================
// example got from a "WoD Quad-ShotGun."
// http://wayback.archive.org/web/20010906213826/http://planetunreal.com:80/wod/tutorials/upgradables.html
//=============================================================================
class CustomFireWeapons expands TournamentPlayer;
var Pawn LocalPlayer;
var Float RuuAngle1;
var Bool AlreadyRunPostBeginPlay;

simulated function PostBeginPlay()
{
	if (AlreadyRunPostBeginPlay)
		return;

	AlreadyRunPostBeginPlay = True;
	RuuAngle1 = 65536 / 360;  // Since 65536 = 0 = 360, half of that equals 180, right?

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

// to make this work: go to User.ini and change line to LeftMouse=Foo
exec function Foo()
{
	local Rotator currRot;
	local Rotator weaponRot;
	currRot = LocalPlayer.ViewRotation;
	//LocalPlayer.ClientMessage("Orientation: "$currRot.Yaw$","$currRot.Pitch$","$currRot.Roll);

	weaponRot.Yaw = 0;
	weaponRot.Pitch = 0;
	weaponRot.Roll = 0;

	// changing Player Weapon Mesh:
	// in console write: set Botpack.Enforcer PlayerViewOffset (X=551,Y=0,Z=-250)
	ChangeRotationDegrees(weaponRot.Yaw, weaponRot.Pitch, weaponRot.Roll);
	Fire();
	// restore orientation
	LocalPlayer.ClientSetRotation(currRot);
}

function ChangeRotationDegrees(Float Yaw, Float Pitch, Float Roll)
{
	local Rotator newRot;
	
	newRot.Yaw = Yaw * RuuAngle1;
	newRot.Pitch = Pitch * RuuAngle1;
	newRot.Roll = Roll * RuuAngle1;
	LocalPlayer.ClientSetRotation(newRot);
}