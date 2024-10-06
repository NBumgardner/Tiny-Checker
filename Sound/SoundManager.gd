@tool
extends Node

@export var Sounds:Dictionary
@export var Import:bool = true

@export var _soundDri:String = "res://Sound/SoundData"
@export var PlayBGM:bool = true

func Playing(n:String)->bool:
	if Sounds.has(n):
		return Sounds[n].Playing()
	else:
		return false

func PlaySound(n:String,v = 0,p = 1):
	if Sounds.has(n):
		Sounds[n].Play(v,p)

func StopSound(n:String):
	if Sounds.has(n):
		Sounds[n].Stop()

func _updateSound():
	var old = Sounds
	Sounds = Dictionary()
	var dir = DirAccess.open(_soundDri)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		_createAudio(file_name)
		if old.has(file_name):
			(Sounds[file_name] as SoundData).Volume = old[file_name].Volume
			(Sounds[file_name] as SoundData).Pintch = old[file_name].Pintch
		file_name = dir.get_next()
	
	
func _createAudio(n:String):

	var curDir = UFF.PathJoin(_soundDri,n)
	var tem:SoundData
	if Sounds.has(n):
		tem = Sounds[n]
	else:
		tem = SoundData.new()
		Sounds[n] = tem
	var dir = DirAccess.open(curDir)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if UFF.IsType(file_name,".wav") or UFF.IsType(file_name,".mp3"):
			tem.AddSound(UFF.PathJoin(curDir,file_name))
		file_name = dir.get_next()
		
func ResetSounds():
	for i in Sounds:
		(Sounds[i] as SoundData).Played = false

var BGM:Array[String]	
var curBGM:int = 0
func _ready() -> void:
	if not Engine.is_editor_hint():
		for i in Sounds:
			(Sounds[i] as SoundData).InitSounds()
		for i in Sounds:
			for j in (Sounds[i] as SoundData).Sounds:
				add_child(j)
		BGM.append("Song1")
		BGM.append("Song2")
		BGM.append("Song3")
		if PlayBGM:
			PlaySound(BGM[0])
	
	
func CheckGBM():
	if PlayBGM and  !Playing(BGM[curBGM]):
		curBGM+=1
		if curBGM>=3:
			curBGM = 0
		PlaySound(BGM[curBGM])
	
	
func _process(delta: float) -> void:
	if !Import:
		_updateSound()
		Import = true
	if not Engine.is_editor_hint():
		ResetSounds()
		CheckGBM()
