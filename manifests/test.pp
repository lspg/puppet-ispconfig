class ispconfig::test inherits ispconfig {
	if str2bool("$is_virtual") && $virtual == 'docker' {
		warning('docker detected')
	}
}