class_name TongeState extends State


var rope: Line2D:
	get:
		return target.rope
	
var tip: Area2D:
	get:
		return target.tip

var head: FrogHead:
	get:
		return target.player
