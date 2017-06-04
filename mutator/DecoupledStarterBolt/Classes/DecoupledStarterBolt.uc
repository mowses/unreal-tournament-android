class DecoupledStarterBolt extends StarterBolt;

var HelloWorld Master;

simulated function PostBeginPlay()
{
	getMaster();
	Super.PostBeginPlay();
}

simulated function Tick(float DeltaTime)
{
	local Rotator currRot;

	if (Master.LocalPlayer == None) {
		Super.Tick(DeltaTime);
		return;
	}

	if (Instigator ==  Master.LocalPlayer) {
		currRot = Instigator.ViewRotation;
		Master.ChangeRotationDegrees(Master.UdpComm.weapon.yaw, Master.UdpComm.weapon.pitch, Master.UdpComm.weapon.roll);
		Super.Tick(DeltaTime);
		
		// restore orientation
		Master.LocalPlayer.ClientSetRotation(currRot);
		return;
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