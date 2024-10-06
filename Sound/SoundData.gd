@tool
class_name SoundData
extends Resource


@export var Volume = 0
@export var Pintch:float = 1
@export var SoundDri:Array[String]
@export var PlayOncePerFrame:bool = true
var Sounds: Array[AudioStreamPlayer] = []


var count:float = 0

var Played:bool = false

func InitSounds():
	for i in SoundDri:
		var tem :AudioStreamPlayer= AudioStreamPlayer.new()
		tem.stream = load(i)
		Sounds.append(tem)

func Play(v:float = 0,p:float = 1):
	if !PlayOncePerFrame or !Played:
		Sounds[count].pitch_scale = p*Pintch
		Sounds[count].volume_db = v+Volume
		Sounds[count].play()
		count+=1
		if count>=Sounds.size():
			count = 0
		Played = true

func Playing()->bool:
	var res = false
	for i in Sounds:
		res = res or i.playing
	return res

func Stop():
	for i in Sounds:
		i.stop()

func AddSound(dir:String):
	SoundDri.append(dir)
