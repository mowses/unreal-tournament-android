Class HelloWorldUdp extends UdpLink;

var int iPort;   // server port number
var int ts;
var Float yaw;
var Float pitch;
var Float roll;

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
	// we have just received a string !
	ts = Int(Mid(Text, 0, 20));
	yaw = Float(Mid(Text, 21, 20));
	pitch = Float(Mid(Text, 42, 20));

	//log("udp: Read string: "$Text$" ts : "$ts$" yaw:"$yaw$"-pitch:"$pitch);
}


defaultproperties
{
	iPort=8000     // local port number
}