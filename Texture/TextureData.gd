@tool
class_name TextureData
extends Resource


@export var TextureDir:String

func _init(d:String) -> void:
	TextureDir = d

var texture


func LoadTexture():
	texture = load(TextureDir)
