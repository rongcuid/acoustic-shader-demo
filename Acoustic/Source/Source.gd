extends Spatial

export var bus = "Acoustic L"
var bus_index

func set_volume(volume) -> void:
	"""
	Sets volume of stream player, in amplitude [0.0, 1.0]
	
	NOTE: Not power, not dB!
	"""
	# dB
	var volume_db: float = 20 * log(volume) / log(10)
	# Set volume
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _ready():
	$AudioStreamPlayer.bus = bus
	bus_index = AudioServer.get_bus_index(bus)

