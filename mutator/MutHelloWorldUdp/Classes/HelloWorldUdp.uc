Class HelloWorldUdp extends UdpLink;

var int iPort;   // server port number

struct lastData
{
	var int lastTs;
	var float yaw;
	var float pitch;
	var float roll;
};

var lastData camera;
var lastData weapon;

function InitUdpLinkTracker()
{
	local string address; // contains the address (for debug purposes)
	local IpAddr Addr;    // struct with the address and the port of the client (us)

	log("udp: InitUdpLinkTracker (entered)");

	ReceiveMode = RMODE_Event; // We are using events to catch incomming datas
	LinkMode = MODE_Text;      // We expect to receive datas in text format

	// set the socket
	GetLocalIp(Addr);
	addr.port = iport;
	address = ipaddrtostring(Addr);
	log ("udp: Address: "$address);

	// bind
	if (BindPort(addr.port, true) > 0)
	{
		log("udp: bind OK : socket initialized and binded!");

		address = ipaddrtostring(Addr);
		log ("udp: Addr "$address);
	}
	else log("udp: ### bind ERROR!");
}

event ReceivedText (IpAddr Addr, string Text)
{
	local string _type;
	local int _ts;
	local float _yaw;
	local float _pitch;
	local float _roll;

	// we have just received a string !
	_type = Mid(Text, 0, 6);
	_ts = Int(Mid(Text, 7, 24));
	_yaw = Float(Mid(Text, 32, 24));
	_pitch = Float(Mid(Text, 57, 24));
	_roll = Float(Mid(Text, 82, 24));

	if (_type == "camera") {
		if (_ts <= camera.lastTs)
			return;

		camera.lastTs = _ts;
		camera.yaw = _yaw;
		camera.pitch = _pitch;
		camera.roll = _roll;
	} else if (_type == "weapon") {
		if (_ts <= weapon.lastTs)
			return;

		weapon.lastTs = _ts;
		weapon.yaw = _yaw;
		weapon.pitch = _pitch;
		weapon.roll = _roll;
	}

	//log("udp: Read string: "$Text$" ts : "$ts$" yaw:"$yaw$"-pitch:"$pitch);
}


defaultproperties
{
	iPort=8000     // local port number
}