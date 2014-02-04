package {
public function randint(min, max:int):int {
	return min + (Math.random() * (max - min)) 
}
}