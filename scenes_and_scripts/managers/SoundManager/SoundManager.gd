extends Node

func playSound(sound : AudioStreamSample, volume : int, pitch : int):
	var sfx = AudioStreamPlayer.new()
	sfx.connect("finished", sfx, "queue_free")
	sfx.stream = sound
	sfx.volume_db = volume
	sfx.pitch_scale = pitch
	add_child(sfx)
	sfx.play()
