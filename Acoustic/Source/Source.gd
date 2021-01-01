extends Spatial

export var bus = "Acoustic Source 1"
var bus_index
var panner: AudioEffectPanner

func set_volume(l: float, r: float) -> void:
	"""
	Sets volume of stream player, in amplitude [0.0, 1.0]
	
	NOTE: Not power, not dB!
	
	Arguments:
		l: left channel
		r: right channel
	"""
	# Total volume
	var volume: = l + r
	var volume_db: float = 20 * log(volume) / log(10)
	# Normalize
	l /= volume
	r /= volume
	var pan: = r - l
	# Set volume
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	panner.pan = pan

func _ready():
	$AudioStreamPlayer.bus = bus
	bus_index = AudioServer.get_bus_index(bus)
	panner = AudioServer.get_bus_effect(1, 0)
