package {
public function dirname(path:String):String {
	var index:Number = path.lastIndexOf('/');
	if (index != -1) {
		return path.substr(0, index + 1);
	}
	return path;
}
}
// ActionScript file
