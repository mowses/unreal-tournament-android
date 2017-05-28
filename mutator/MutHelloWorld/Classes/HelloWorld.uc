// https://wiki.beyondunreal.com/Legacy:UnrealScript_Hello_World
// https://wiki.beyondunreal.com/Legacy:Rotator
class HelloWorld extends Mutator;

var Pawn LocalPlayer;
var Bool AlreadyRunPostBeginPlay;
var Float RuuAngle1;
var HelloWorldUdp UdpComm;      // class member for UDP communication (UDP communication used to set the rotation of the player)

// Only allow one instance of this mutator.
function AddMutator(Mutator M) {
	if ( M != Self )
		Super.AddMutator(M);
}

// Do not allow our custom weapons to be replaced or removed.
function bool AlwaysKeep(Actor Other) {
	if( Other.IsA('DecoupledEnforcer') ||
		Other.IsA('DecoupledShockRifle')
	)
		return true;

	return Super.AlwaysKeep(Other);
}

// Replace the default weapons by the decoupled ones
function ModifyPlayer(Pawn Other) {
	local DeathMatchPlus DM;
	local Inventory inv;
	
	DM = DeathMatchPlus(Level.Game);

	if ( DM == None) {
		Super.ModifyPlayer(Other);
		return;
	}

	/*// replace weapons from inventory (do not work if returns false from CheckReplacement)
	inv = Other.FindInventoryType(class'Enforcer');
	if (inv != None)
	{
		inv.DropInventory(); // Remove it from Player's Inventory
		inv.Destroy(); // Remove it from the game
		DM.GiveWeapon( Other, "DecoupledEnforcer.DecoupledEnforcer" );
	}*/
	
	Super.ModifyPlayer(Other);
}

// Replace weapons with the decoupled versions
function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
	if ( Other.IsA('Weapon') ) {
		if ( Other.IsA('Enforcer') && !Other.IsA('DecoupledEnforcer') ) {
			ReplaceWith( Other, "DecoupledEnforcer.DecoupledEnforcer" );
			return false;
		}
		else if ( Other.IsA('ShockRifle') && !Other.IsA('DecoupledShockRifle') ) {
			ReplaceWith( Other, "DecoupledShockRifle.DecoupledShockRifle" );
			return false;
		}
	}
	return true;
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (AlreadyRunPostBeginPlay)
		return;

	Log("HelloWorld.uc mod loaded");
	AlreadyRunPostBeginPlay = True;
	RuuAngle1 = 65536 / 360;  // Since 65536 = 0 = 360, half of that equals 180, right?

	UdpComm = Spawn(class'HelloWorldUdp');   // Here we spawn our udp class
	UdpComm.InitUdpLinkTracker();  // Here we initilalize the UDP connection
	SetTimer(1, True);
}

function Timer()
{
	getPlayer();
	SetTimer(999999, False);
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

function Tick(float DeltaTime)
{
	if (LocalPlayer == None)
		return;

	//ChangeRotationDegrees(UdpComm.camera.yaw, UdpComm.camera.pitch, UdpComm.camera.roll);
	//LocalPlayer.ClientMessage("curr orient: "$LocalPlayer.ViewRotation);
}

function ChangeRotationDegrees(Float Yaw, Float Pitch, Float Roll)
{
	local Rotator newRot;
	
	newRot.Yaw = Yaw * RuuAngle1;
	newRot.Pitch = Pitch * RuuAngle1;
	newRot.Roll = Roll * RuuAngle1;
	LocalPlayer.ClientSetRotation(newRot);
}