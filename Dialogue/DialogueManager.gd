@tool
extends Node

#region Font

@export_group("font")

@export var DefaultFont:String = "LilitaOne60"
@export var FontsData:Array[FontData]
@export var Fonts:Dictionary

@export var Import:bool = true

var textPrefab = load("res://Dialogue/TextBox/TextPrefab.tscn")

var allCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!:\"';()<>@#$%&~+-=[]_"

func GetFontSetter(name:String)->FontSetter:
	if name == "":
		name = "LilitaOne60"
	if Fonts.has(name):
		return Fonts[name] as FontSetter
	else:
		return Fonts["LilitaOne60"]
	
func ImportFont() -> void:
	Fonts = Dictionary()
	for i in FontsData:
		var res:FontSetter = FontSetter.new()
		res.texture = load("res://Font/FontData/"+i.FontName+str(i.FontSize)+"Texture.png")
		var tem:FileAccess = FileAccess.open("res://Font/FontData/"+i.FontName+str(i.FontSize)+"Data.txt",FileAccess.READ)
		for c in allCharacter:
			var content = tem.get_line()
			res.dataDisc[c] = UFT.TxtToCharData(content)
		Fonts[i.FontName+str(i.FontSize)] = res
#endregion
	
#region AnimeData
@export_group("AnimeData")
@export var DefaultAnimeData:TextAnimeData
@export var AnimeDataDic:Dictionary = Dictionary()

func GetAnimeData(n:String)->TextAnimeData:
	if n == "":
		return DefaultAnimeData
	elif AnimeDataDic.has(n):
		return AnimeDataDic[n]
	return DefaultAnimeData
#endregion
		
#region SoundSet
@export_group("SoundSet")
@export var DefaultSoundSet:TextSoundSet
@export var SoundSetDic:Dictionary = Dictionary()

func GetSoundSet(n:String)->TextSoundSet:
	if n == "":
		return DefaultSoundSet
	elif SoundSetDic.has(n):
		return SoundSetDic[n]
	return DefaultSoundSet
#endregion

	
func GetTextInstate(c:String = "",fontName:String = "LilitaOne60")->TextCountroler:
	var tem:TextCountroler = textPrefab.instantiate() as TextCountroler
	if c!="":
		(Fonts[fontName] as FontSetter).SetSprite(tem,c)
	return tem


		

func _process(delta: float) -> void:
	if not Import:
		ImportFont()
		Import = true
