class_name GenPawnPartData
extends PawnPartData

enum PawnPartType {HEAD,NECK,BODY,FOOT,NONE}


@export var Name:String
@export var PartType:PawnPartType =  PawnPartType.NONE

@export var GenData:bool = true
@export var BottonRadin:float = 30
@export var TopRadin:float = 30
@export var CurveRadin:float = 0
@export var height:float = 5
@export var pawnColor = Color(0,0,0,1)
@export var LineColor = Color(1,1,1,1)


@export var TextureBack:String = ""
@export var TextureLine:Array[String] = []
@export var Colors:Array[Color] = []


func GetHeight()->float:
	return height



func Copy()->GenPawnPartData:
	var tem:GenPawnPartData = GenPawnPartData.new()
	tem.Name = Name
	tem.PartType = PartType
	tem.GenData = GenData
	tem.BottonRadin = BottonRadin
	tem.TopRadin = TopRadin
	tem.CurveRadin = CurveRadin
	tem.height = height
	tem.pawnColor =pawnColor
	tem.LineColor = LineColor
	tem.TextureBack = TextureBack
	tem.TextureLine = TextureLine
	return tem
