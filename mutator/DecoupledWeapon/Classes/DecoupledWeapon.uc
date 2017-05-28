/*class DecoupledWeapon extends Weapon;

var HelloWorld Master;

function PostBeginPlay()
{
	getMaster();
	Super.PostBeginPlay();
}

function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Pawn PawnOwner;
	local Rotator PawnViewRot;

	PawnOwner = Pawn(Owner);
	PawnViewRot = PawnOwner.ViewRotation;
	
	Master.LocalPlayer.ClientMessage("curr orient: "$Master.LocalPlayer.ViewRotation);
	if (PawnOwner == Master.LocalPlayer) {
		PawnViewRot.Yaw = Master.UdpComm.camera.yaw;
		PawnViewRot.Pitch = Master.UdpComm.camera.pitch;
		PawnViewRot.Roll = Master.UdpComm.camera.roll;
	}

	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnViewRot,X,Y,Z);
	StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	AdjustedAim = PawnOwner.AdjustAim(1000000, StartTrace, 2*AimError, False, False);	
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000;
	X = vector(AdjustedAim);
	EndTrace += (10000 * X); 
	Other = PawnOwner.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
	ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
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
}*/