extends Spatial

export(NodePath) var listens_to: NodePath setget set_listen

# Tentative directional resposnse
export(float) var left_response = 1.0
export(float) var right_response = 0.25
export(float) var front_response = 0.5
export(float) var back_response = 0.3
export(float) var up_response = 0.4
export(float) var down_response = 0.35

var _source

func set_listen(listen):
	_source = get_node(listen)
	listens_to = listen

func integrate_volume() -> float:
	var volume: = 0.0
	
	# Integrate each view
	volume += _integrate_view($FrontView, front_response)
	volume += _integrate_view($BackView, back_response)
	volume += _integrate_view($LeftView, left_response)
	volume += _integrate_view($RightView, right_response)
	volume += _integrate_view($UpView, up_response)
	volume += _integrate_view($DownView, down_response)
	
	return volume

func _integrate_view(vp: Viewport, r: int) -> float:
	var t: Image = vp.get_texture().get_data()
	# TODO Make more generic
	assert(not t.is_compressed())
	assert(t.get_format() == Image.FORMAT_RGB8)
	var d: PoolByteArray = t.get_data()
	# Naive integration
	var sum: int = 0
	for b in d:
		sum += b
	return sum / 768.0
