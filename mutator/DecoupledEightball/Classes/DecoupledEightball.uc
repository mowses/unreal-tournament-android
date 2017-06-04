class DecoupledEightball extends UT_Eightball;

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

function Actor CheckTarget()
{
	local Rotator currRot;
	local Actor retActor;
	
	if (Master.LocalPlayer == None) {
		return Super.CheckTarget();
	}

	currRot = Master.LocalPlayer.ViewRotation;
	Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
	retActor = Super.CheckTarget();

	// restore orientation
	Master.LocalPlayer.ClientSetRotation(currRot);

	return retActor;
}

state NormalFire
{
	function AnimEnd()
	{
		local Rotator currRot;
		
		if (Master.LocalPlayer == None) {
			Super.AnimEnd();
			return;
		}

		currRot = Master.LocalPlayer.ViewRotation;
		Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
		Super.AnimEnd();

		// restore orientation
		Master.LocalPlayer.ClientSetRotation(currRot);
	}
}

state Idle
{
	function Timer()
	{
		local Rotator currRot;
		
		if (Master.LocalPlayer == None) {
			Super.Timer();
			return;
		}

		currRot = Master.LocalPlayer.ViewRotation;
		Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
		Super.Timer();

		// restore orientation
		Master.LocalPlayer.ClientSetRotation(currRot);
	}
}

state FireRockets
{
	function BeginState()
	{
		local Rotator currRot;
		
		if (Master.LocalPlayer == None) {
			Super.BeginState();
			return;
		}

		currRot = Master.LocalPlayer.ViewRotation;
		Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
		Super.BeginState();

		// restore orientation
		Master.LocalPlayer.ClientSetRotation(currRot);
	}
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