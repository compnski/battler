package {
    public function basename(path:String):String {
        var index:Number = path.lastIndexOf('/');
        if (index != -1) {
            return path.substr(index + 1);
        }
        return path;
    }


}
