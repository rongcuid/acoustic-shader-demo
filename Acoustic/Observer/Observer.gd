extends Spatial

export(NodePath) var source

var _source_node

func _ready():
	_source_node = get_node(source)
	$LeftEar.listens_to = $LeftEar.get_path_to(_source_node)
	$RightEar.listens_to = $RightEar.get_path_to(_source_node)
