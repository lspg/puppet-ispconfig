class ispconfig::test inherits ispconfig {
	$virtual == 'docker' {
		warning('docker detected')
	}
}