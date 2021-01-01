extends Spatial

export(NodePath) var listens_to: NodePath setget set_listen

export(float) var amplification = 1.0

# Tentative directional resposnse
export(float) var left_response = 1.0
export(float) var right_response = 0.25
export(float) var front_response = 0.5
export(float) var back_response = 0.3
export(float) var up_response = 0.4
export(float) var down_response = 0.35

var _source

onready var _front_tex = $FrontView.get_texture()
onready var _back_tex = $BackView.get_texture()
onready var _left_tex = $LeftView.get_texture()
onready var _right_tex = $RightView.get_texture()
onready var _up_tex = $UpView.get_texture()
onready var _down_tex = $DownView.get_texture()

func set_listen(listen):
	_source = get_node(listen)
	listens_to = listen

func update_viewport() -> void:
	# TODO This is a hack to force update
	$FrontView.render_target_update_mode = Viewport.UPDATE_ONCE
	$BackView.render_target_update_mode = Viewport.UPDATE_ONCE
	$LeftView.render_target_update_mode = Viewport.UPDATE_ONCE
	$RightView.render_target_update_mode = Viewport.UPDATE_ONCE
	$UpView.render_target_update_mode = Viewport.UPDATE_ONCE
	$DownView.render_target_update_mode = Viewport.UPDATE_ONCE
	
func integrate_volume() -> float:
	var volume: = 0.0
	
#	# The light itself
#	var v: Vector3 = global_transform.origin - _source.global_transform.origin
#	var r: float = v.length()
#	var vol0 = _source.get_node("AcousticLight").light_energy
#	# Intensity falls off by inverse square; amplitude falls off by inverse
#	volume = vol0 / r
	
	# Integrate reflections from each view
	volume += _integrate_view(_front_tex, front_response)
	volume += _integrate_view(_back_tex, back_response)
	volume += _integrate_view(_left_tex, left_response)
	volume += _integrate_view(_right_tex, right_response)
	volume += _integrate_view(_up_tex, up_response)
	volume += _integrate_view(_down_tex, down_response)
	
	volume = clamp(volume, 0, 1)
	
	return volume

func _integrate_view(t: ViewportTexture, r: float) -> float:
	var img: Image = t.get_data()
	# TODO Make more generic
	assert(not img.is_compressed())

	# Convert to luminance
	img.convert(Image.FORMAT_L8)
	var d: PoolByteArray = img.get_data()
	# Naive integration
	var sum: int = 0
	for b in d:
		sum += b
	var partial = float(sum) * r / 256.0 / 128 / 128 # TODO Temporary

	return partial
