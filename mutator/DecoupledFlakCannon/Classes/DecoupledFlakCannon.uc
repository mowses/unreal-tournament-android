class DecoupledFlakCannon extends UT_FlakCannon;

var HelloWorld Master;

function PostBeginPlay()
{
	getMaster();
	Super.PostBeginPlay();
}

// Weapon rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
	local Rotator currRot;

	if (Master.LocalPlayer == None) {
		Super.RenderOverlays(Canvas);
		return;
	}

	currRot = Master.LocalPlayer.ViewRotation;
	//LocalPlayer.ClientMessage("UdpComm.weapon.yaw:"$UdpComm.weapon.yaw);
	//LocalPlayer.ClientMessage("UdpComm.camera.yaw:"$UdpComm.camera.yaw);
	Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
	Super.RenderOverlays(Canvas);
	
	// restore orientation
	Master.LocalPlayer.ClientSetRotation(currRot);
}

function Fire(float Value)
{
	local Rotator currRot;
	
	if (Master.LocalPlayer == None) {
		Super.Fire(Value);
		return;
	}

	currRot = Master.LocalPlayer.ViewRotation;
	Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
	Super.Fire(Value);

	// restore orientation
	Master.LocalPlayer.ClientSetRotation(currRot);
}

function AltFire(float Value)
{
	local Rotator currRot;
	
	if (Master.LocalPlayer == None) {
		Super.AltFire(Value);
		return;
	}

	currRot = Master.LocalPlayer.ViewRotation;
	Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
	Super.AltFire(Value);

	// restore orientation
	Master.LocalPlayer.ClientSetRotation(currRot);
}

function getMaster()
{
	local HelloWorld HelloWorld;

	foreach allactors( class'HelloWorld', HelloWorld) {
		Master = HelloWorld;
		return;
	}
}

defaultproperties
{
	bDrawMuzzleFlash=False
}