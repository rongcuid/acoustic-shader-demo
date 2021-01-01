extends Spatial

export var bus = "Acoustic L"
var bus_index
var panner

func set_volume(l, r) -> void:
	"""
	Sets volume of stream player, in amplitude [0.0, 1.0]
	
	NOTE: Not power, not dB!
	"""
	var volume = l + r
	assert(volume != 0.0)
	l /= volume
	r /= volume
	var pan = r - l
	# dB
	var volume_db: float = 20 * log(volume/2) / log(10)
	# Set volume
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	panner.pan = pan

func _ready():
	$AudioStreamPlayer.bus = bus
	bus_index = AudioServer.get_bus_index(bus)
	panner = AudioServer.get_bus_effect(bus_index, 0)

func _on_Observer_ready():
	$AudioStreamPlayer.play()
