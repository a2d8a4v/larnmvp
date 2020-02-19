acl unwanted {

}

sub unwa_ips { 
	if (client.ip ~ unwanted) {
		return(synth(403, "No way."));
	}
}
