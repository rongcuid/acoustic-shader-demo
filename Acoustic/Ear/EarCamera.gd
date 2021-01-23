tool
extends Camera

onready var xform0: = transform

func _process(delta):
	transform = get_node("../..").transform * xform0
