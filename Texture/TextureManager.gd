@tool
extends Node

@export var Textures:Dictionary
@export var _tex:Dictionary
@export var _textureDri:String = "res://Texture/Data"
@export var Import:bool = true


func loadTexture():
	Textures = Dictionary()
	var dir = DirAccess.open(_textureDri)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			loadTextureInFile(file_name,_textureDri,file_name)
		else:
			if !UFF.IsImport(file_name):
				Textures[file_name.split(".")[0]] = UFF.PathJoin(dir,file_name)
		file_name = dir.get_next()

func loadTextureInFile(fileName:String,path:String,lastname:String):
	var p = UFF.PathJoin(path,fileName)
	var dir = DirAccess.open(p)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			loadTextureInFile(file_name,p,lastname+file_name)
		else:
			if !UFF.IsImport(file_name):
				Textures[lastname+file_name.split(".")[0]] = UFF.PathJoin(p,file_name)
		file_name = dir.get_next()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in Textures:
			_tex[i] = load(Textures[i])

func GetTexture(n:String):
	if _tex.has(n):
		return _tex[n]
	else:
		return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Import:
		loadTexture()
		Import = true
