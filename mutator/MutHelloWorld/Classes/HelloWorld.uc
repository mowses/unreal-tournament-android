// https://wiki.beyondunreal.com/Legacy:UnrealScript_Hello_World
// https://wiki.beyondunreal.com/Legacy:Rotator
class HelloWorld extends Mutator;

//var Pawn LocalPlayer;
//var Bool AlreadyRunPostBeginPlay;
//var Float RuuAngle1;
//var HelloWorldUdp UdpComm;      // class member for UDP communication (UDP communication used to set the rotation of the player)
//var CustomFireWeapons CustomFireWeaponsVar;
//var int lastTS;

// Only allow one instance of this mutator.
function AddMutator(Mutator M) {
    if ( M != Self )
        Super.AddMutator(M);
}

// Do not allow CustomFireWeapons to be replaced or removed.
function bool AlwaysKeep(Actor Other) {
    if( Other.IsA('DecoupledEnforcer') )
        return true;

    return Super.AlwaysKeep(Other);
}

// Replace the default weapons by the decoupled ones
function ModifyPlayer(Pawn Other) {
    DeathMatchPlus(Level.Game).GiveWeapon( Other, "DecoupledEnforcer.DecoupledEnforcer" );
    Super.ModifyPlayer(Other);
}

// Replace weapons with the decoupled versions
function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
    if ( Other.IsA('Weapon') ) {
        if ( Other.IsA('Enforcer') ) {
            ReplaceWith( Other, "DecoupledEnforcer.DecoupledEnforcer" );
            return false;
        }
    }
    return true;
}

/*function getPlayer()
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

	Log("HelloWorld.uc mod loaded");
	AlreadyRunPostBeginPlay = True;
	RuuAngle1 = 65536 / 360;  // Since 65536 = 0 = 360, half of that equals 180, right?

	Super.PostBeginPlay(); // Run the super class function (Mutator.PostBeginPlay).
	UdpComm = Spawn(class'HelloWorldUdp');   // Here we spawn our udp class
	UdpComm.InitUdpLinkTracker();  // Here we initilalize the UDP connection
	CustomFireWeaponsVar = Spawn(class'CustomFireWeapons');   // Here we spawn our CustomFireWeapons
	SetTimer(1, True);
	Super.PostBeginPlay();
}

//function SetInitialState()  // Called after PostBeginPlay to set the initial state of the actor.
//{
//	Log("SetInitialState runs");
//}

function Tick(float DeltaTime)
{
	if (LocalPlayer == None)
		return;

	if (UdpComm.ts <= lastTS) {
		//LocalPlayer.ClientMessage("Late packed received: "$UdpComm.ts);
		return;
	}

	lastTS = UdpComm.ts;
	ChangeRotation(UdpComm.yaw, UdpComm.pitch, 0);
	//LocalPlayer.ClientMessage("curr ts: "$UdpComm.ts);
	//LocalPlayer.ClientMessage("curr orient: "$LocalPlayer.ViewRotation);
}

function ChangeRotation(Float Yaw, Float Pitch, Float Roll)
{
	local Rotator newRot;
	newRot = LocalPlayer.ViewRotation;
	
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


function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	bSuperRelevant = 1;
	if ( Other.IsA('Enforcer') ) {
		ReplaceWith(Other, "Botpack.Enforcer");
		return false;
	}
	
	bSuperRelevant = 0;
	return true;
}

// Replace the default weapon with FastRifle when a player spawn.
function ModifyPlayer(Pawn Other)
{
    DeathMatchPlus(Level.Game).GiveWeapon( Other, "CustomFireWeapons.CustomFireWeapons" );
    Super.ModifyPlayer(Other);
}*/