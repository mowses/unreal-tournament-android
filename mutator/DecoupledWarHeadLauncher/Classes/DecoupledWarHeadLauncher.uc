class DecoupledWarHeadLauncher extends WarHeadLauncher;

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

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Rotator currRot;
	local Projectile projectile;
	
	if (Master.LocalPlayer == None) {
		return Super.ProjectileFire(ProjClass, ProjSpeed, bWarn);
	}

	currRot = Master.LocalPlayer.ViewRotation;
	Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
	projectile = Super.ProjectileFire(ProjClass, ProjSpeed, bWarn);

	// restore orientation
	Master.LocalPlayer.ClientSetRotation(currRot);

	return projectile;
}

state Guiding
{
	simulated function Tick(float DeltaTime)
	{
		if (Master.LocalPlayer == None) {
			Super.Tick(DeltaTime);
			return;
		}

		if ( GuidedShell != None && !GuidedShell.bDestroyed) {
			Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
		} else {
			GotoState('Finishing');
		}

		Super.Tick(DeltaTime);
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