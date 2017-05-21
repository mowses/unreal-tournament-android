class DecoupledEnforcer extends Enforcer;

var Pawn LocalPlayer;
var Bool AlreadyRunPostBeginPlay;
var float RuuAngle1;  // Since 65536 = 0 = 360, half of that equals 180, right?;
var HelloWorldUdp UdpComm;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (AlreadyRunPostBeginPlay)
		return;

	AlreadyRunPostBeginPlay = True;
	RuuAngle1 = 65536 / 360;
	getPlayer();
	getUdp();
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
	//LocalPlayer.ClientMessage("UdpComm.weapon.yaw:"$UdpComm.weapon.yaw);
	//LocalPlayer.ClientMessage("UdpComm.camera.yaw:"$UdpComm.camera.yaw);
	ChangeRotationDegrees(UdpComm.weapon.yaw, UdpComm.weapon.pitch, UdpComm.weapon.roll);
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
	ChangeRotationDegrees(UdpComm.weapon.yaw, UdpComm.weapon.pitch, UdpComm.weapon.roll);
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

/**
 * make this object get the UdpComm from master
**/
function getUdp()
{
	local HelloWorld HelloWorld;

	foreach allactors( class'HelloWorld', HelloWorld) {
		UdpComm = HelloWorld.UdpComm;
	}
}

defaultproperties
{
	bDrawMuzzleFlash=False
}