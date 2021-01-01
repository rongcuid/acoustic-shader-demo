extends Control

export(NodePath) var ear

var _ear_node

func _ready():
	_ear_node = get_node(ear)
	
	var up_texture: ViewportTexture = _ear_node.get_node("UpView").get_texture()
	$Top/Up.texture = up_texture
	
	var left_texture: ViewportTexture = _ear_node.get_node("LeftView").get_texture()
	$Middle/Left.texture = left_texture
	var front_texture: ViewportTexture = _ear_node.get_node("FrontView").get_texture()
	$Middle/Front.texture = front_texture
	var right_texture: ViewportTexture = _ear_node.get_node("RightView").get_texture()
	$Middle/Right.texture = right_texture
	var back_texture: ViewportTexture = _ear_node.get_node("BackView").get_texture()
	
	$Middle/Back.texture = back_texture
	var down_texture: ViewportTexture = _ear_node.get_node("DownView").get_texture()
	
	$Bottom/Down.texture = down_texture
