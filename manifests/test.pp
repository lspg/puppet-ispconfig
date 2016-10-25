class ispconfig::test inherits ispconfig {
	if (str2bool("$is_virtual")) and ($virtual == 'docker') {
		warning('docker detected')
	}
}