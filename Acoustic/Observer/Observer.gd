extends Spatial

export(NodePath) var source

var _source_node

onready var _volume_l: = 0.5
onready var _volume_r: = 0.5

signal volume_ready(l, r)

func _ready():
	_source_node = get_node(source)
	$LeftEar.listens_to = $LeftEar.get_path_to(_source_node)
	$RightEar.listens_to = $RightEar.get_path_to(_source_node)

func _process(_delta):
	var v_l = update_ear($LeftEar)
	var v_r = update_ear($RightEar)
	if v_l != 0.0:
		_volume_l = v_l
	if v_r != 0.0:
		_volume_r = v_r
	if v_l != 0.0 && v_r != 0.0:
		emit_signal("volume_ready", v_l, v_r)

func update_ear(ear):
	ear.update_viewport()
	var v: float = ear.integrate_volume()
	return v

