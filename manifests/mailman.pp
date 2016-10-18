class ispconfig::mailman inherits ispconfig {
	package { 'mailman':
		responsefile => "/tmp/mailman.seeds",
		ensure       => installed,
	}
}