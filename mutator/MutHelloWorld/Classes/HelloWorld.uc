// https://wiki.beyondunreal.com/Legacy:UnrealScript_Hello_World
// https://wiki.beyondunreal.com/Legacy:Rotator
class HelloWorld extends Mutator;

var Pawn LocalPlayer;
var Bool AlreadyRunPostBeginPlay;
var Float RuuAngle1;
var HelloWorldUdp UdpComm;      // class member for UDP communication (UDP communication used to set the rotation of the player)
var int lastTS;

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

function PostBeginPlay()
{
	if (AlreadyRunPostBeginPlay)
		return;

	AlreadyRunPostBeginPlay = True;
	RuuAngle1 = 65536 / 360;  // Since 65536 = 0 = 360, half of that equals 180, right?

	Super.PostBeginPlay(); // Run the super class function (Mutator.PostBeginPlay).
	UdpComm = Spawn(class'HelloWorldUdp');   // Here we spawn our udp class
	UdpComm.InitUdpLinkTracker();  // Here we initilalize the UDP connection
	SetTimer(1, True);
}

//function SetInitialState()  // Called after PostBeginPlay to set the initial state of the actor.
//{
//	Log("SetInitialState runs");
//}

function Tick(float DeltaTime)
{
	if (LocalPlayer == None)
		return;

	//if (UdpComm.ts <= lastTS)
	//	return;

	lastTS = UdpComm.ts;
	ChangeRotation(-UdpComm.yaw, UdpComm.pitch, 0);
	LocalPlayer.ClientMessage("curr ts: "$UdpComm.ts);
	LocalPlayer.ClientMessage("curr orient: "$LocalPlayer.Rotation);
}

function ChangeRotation(Float Yaw, Float Pitch, Float Roll)
{
	local Rotator newRot;
	newRot = LocalPlayer.Rotation;
	
	newRot.Yaw = Yaw * RuuAngle1;
	newRot.Pitch = Pitch * RuuAngle1;
	//newRot.Roll = Roll * RuuAngle1;
	LocalPlayer.ClientSetRotation(newRot);
	//Log("set rotation:yaw"$Yaw$"--pitch"$pitch);
	
	//LocalPlayer.SetRotation(newRot);
	//Pawn(Player).SetRotation(newRot);
}

function Timer()
{
	getPlayer();
	SetTimer(999999, False);
}