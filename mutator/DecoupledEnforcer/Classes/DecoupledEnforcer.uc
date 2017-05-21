class DecoupledEnforcer extends Enforcer;

var Pawn LocalPlayer;
var Bool AlreadyRunPostBeginPlay;
var float RuuAngle1;  // Since 65536 = 0 = 360, half of that equals 180, right?;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (AlreadyRunPostBeginPlay)
		return;

	AlreadyRunPostBeginPlay = True;
	RuuAngle1 = 65536 / 360;
	getPlayer();
	
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
	//ChangeRotationDegrees(0,0,0);
	Super.RenderOverlays(Canvas);
	// restore orientation
	LocalPlayer.ClientSetRotation(currRot);
}

function TraceFire(float Accuracy)
{
	local Rotator currRot;
	
	if (LocalPlayer == None) {
		Super.TraceFire(Accuracy);
		return;
	}

	currRot = LocalPlayer.ViewRotation;
	ChangeRotationDegrees(0,0,0);
	Super.TraceFire(Accuracy);
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

defaultproperties
{
	bDrawMuzzleFlash=False
}