class_name FontSetter
extends Resource

@export var dataDisc:Dictionary
@export var texture:Texture2D


func GetCharData(c:String)->CharData:
	if dataDisc.has(c):
		return dataDisc[c]
	else:
		return null


func SetSprite(s:Sprite2D,c:String)->CharData:
	var tem = GetCharData(c)
	if tem == null:
		s.texture = null
		return tem
	else:
		s.texture = texture
		s.region_rect = tem.rect
		return tem
