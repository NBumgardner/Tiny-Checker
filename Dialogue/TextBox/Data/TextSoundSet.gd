@tool
class_name TextSoundSet
extends Resource

@export var Default = "Speak"
@export var SoundDic:Dictionary = Dictionary()


func _init() -> void:
	SoundDic[" "] = ""
	SoundDic["."] = "SpeakDot"
	SoundDic[","] = "SpeakDot"
	SoundDic["!"] = "SpeakEx"
	SoundDic["?"] = "SpeakQ"


func SoundName(c:String)->String:
	if SoundDic.has(c):
		return SoundDic[c]
	else:
		return Default
