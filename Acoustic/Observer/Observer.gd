extends Spatial

export(NodePath) var source

var _source_node
# Called when the node enters the scene tree for the first time.
func _ready():
	_source_node = get_node(source)
	$Ear.listens_to = $Ear.get_path_to(_source_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
