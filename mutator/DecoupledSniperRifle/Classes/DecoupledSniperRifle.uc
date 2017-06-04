class DecoupledSniperRifle extends SniperRifle;

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

function TraceFire(float Accuracy)
{
	local Rotator currRot;
	
	if (Master.LocalPlayer == None) {
		Super.TraceFire(Accuracy);
		return;
	}

	currRot = Master.LocalPlayer.ViewRotation;
	Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
	Super.TraceFire(Accuracy);

	// restore orientation
	Master.LocalPlayer.ClientSetRotation(currRot);
}

state Zooming
{
	simulated function Tick(float DeltaTime)
	{
		local Rotator currRot;
	
		if (Master.LocalPlayer == None) {
			Super.Tick(DeltaTime);
			return;
		}

		currRot = Master.LocalPlayer.ViewRotation;
		Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
		Super.Tick(DeltaTime);

		// DO NOT restore orientation
		// since zooming should be at weapon orientation
	}
}

simulated function Tick(float DeltaTime)
{
	local PlayerPawn P;

	if (Master.LocalPlayer == None) {
		Super.Tick(DeltaTime);
		return;
	}

	P = PlayerPawn(Owner);
	// player is using the sniper zoom
	if ((P != None) && (P.DesiredFOV != P.DefaultFOV) ) {
		Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
	}

	Super.Tick(DeltaTime);
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