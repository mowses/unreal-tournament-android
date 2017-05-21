//=============================================================================
// example got from a "WoD Quad-ShotGun."
// http://wayback.archive.org/web/20010906213826/http://planetunreal.com:80/wod/tutorials/upgradables.html
//=============================================================================
class CustomFireWeapons extends SniperRifle;

var Pawn LocalPlayer;
var Bool AlreadyRunPostBeginPlay;
var float RuuAngle1;  // Since 65536 = 0 = 360, half of that equals 180, right?;

function PostBeginPlay()
{
	if (AlreadyRunPostBeginPlay)
		return;

	AlreadyRunPostBeginPlay = True;
	RuuAngle1 = 65536 / 360;
	getPlayer();
	Super.PostBeginPlay(); // Run the super class function (Mutator.PostBeginPlay).
	
}

// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	local Rotator currRot;

	if (LocalPlayer == None) {
		Super.RenderOverlays(Canvas);
		return;
	}

	currRot = LocalPlayer.ViewRotation;
	ChangeRotationDegrees(0,0,0);
	Super.RenderOverlays(Canvas);
	// restore orientation
	LocalPlayer.ClientSetRotation(currRot);
}

state Idle
{
	function Fire( float Value )
	{
		local Rotator currRot;
		
		if (LocalPlayer == None) {
			Super.Fire(Value);
			return;
		}
	
		currRot = LocalPlayer.ViewRotation;
		ChangeRotationDegrees(0,0,0);
		Super.Fire(Value);
		// restore orientation
		LocalPlayer.ClientSetRotation(currRot);
	}
}

function ChangeRotationDegrees(Float Yaw, Float Pitch, Float Roll)
{
	local Rotator newRot;
	
	newRot.Yaw = Yaw * RuuAngle1;
	newRot.Pitch = Pitch * RuuAngle1;
	newRot.Roll = Roll * RuuAngle1;
	LocalPlayer.ClientSetRotation(newRot);
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