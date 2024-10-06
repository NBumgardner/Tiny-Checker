extends Node


@export var PlayerPawns:Array[PawnData]

@export var PawnsInDic:Array[PawnData]
var PawnDic:Dictionary


func GetPlayerPawn(i:int)->PawnData:
	return PlayerPawns[i].Copy()
func GetPawn(name:String)->PawnData:
	if PawnDic.has(name):
		return PawnDic[name]
	else:
		return null




@export var DefaultJumpHoverColor:Color 
@export var DefaultMoveHoverColor:Color
@export var DefaultPushHoverColor:Color
@export var DefaultOffendHoverColor:Color

@export var WubbleCurve:Curve


var DamageTexture1:Array[Texture] = []
var DamageTexture2:Array[Texture] = []
var DamageTexture3:Array[Texture] = []
var curDT:int = 0



var DamageParticalLine:Array[Texture] = []
var DamageParticalBack:Array[Texture] = []
var curP:int = 0
var IceParticalLine:Array[Texture] = []
var IceParticalBack:Array[Texture] = []
var curI:int = 0
var DirVector:Array[Vector2] = []

func InitData():
	DamageTexture1.append(TextureManager.GetTexture("Damage1"))
	DamageTexture1.append(TextureManager.GetTexture("Damage2"))
	DamageTexture1.append(TextureManager.GetTexture("Damage3"))
	DamageTexture2.append(TextureManager.GetTexture("Damage4"))
	DamageTexture2.append(TextureManager.GetTexture("Damage5"))
	DamageTexture2.append(TextureManager.GetTexture("Damage6"))
	DamageTexture3.append(TextureManager.GetTexture("Damage7"))
	DamageTexture3.append(TextureManager.GetTexture("Damage8"))
	DamageTexture3.append(TextureManager.GetTexture("Damage9"))
	DamageParticalLine.append(TextureManager.GetTexture("DamagePL1"))
	DamageParticalLine.append(TextureManager.GetTexture("DamagePL2"))
	DamageParticalLine.append(TextureManager.GetTexture("DamagePL3"))
	DamageParticalLine.append(TextureManager.GetTexture("DamagePL4"))
	DamageParticalBack.append(TextureManager.GetTexture("DamagePB1"))
	DamageParticalBack.append(TextureManager.GetTexture("DamagePB2"))
	DamageParticalBack.append(TextureManager.GetTexture("DamagePB3"))
	DamageParticalBack.append(TextureManager.GetTexture("DamagePB4"))
	IceParticalLine.append(TextureManager.GetTexture("IcePL1"))
	IceParticalLine.append(TextureManager.GetTexture("IcePL2"))
	IceParticalBack.append(TextureManager.GetTexture("IcePB1"))
	IceParticalBack.append(TextureManager.GetTexture("IcePB2"))
	var tv = UFV.V2Rotate(Vector2(0,50),-PI/6)
	for i in 6:
		DirVector.append(Vector2(tv.x,tv.y*-0.8))
		tv = UFV.V2Rotate(tv,-PI/3)

func GetDamageTexture(i:int)->Texture:
	curDT+=1
	if curDT>=3:
		curDT = 0
	match curDT:
		0:
			return DamageTexture1[i]
		1:
			return DamageTexture2[i]
		2:
			return DamageTexture3[i]
		_:
			return DamageTexture1[i] 
			
func GetDamagePartical(cl:Color,cb:Color,p:Vector2)->PawnPartical:
	var tem = PawnPartical.new(DamageParticalLine[curP],DamageParticalBack[curP],cl,cb)
	curP+=1
	if curP>=4:
		curP = 0
	var dir = randf_range(0,2*PI)
	var speed = randf()
	tem.initposition = UFV.V2Rotate(Vector2(0,15)*speed,dir)+p
	tem.initSpeed = UFV.V2Rotate(speed*Vector2(0,150),dir)
	tem.rotateSpeed = randf_range(0,1)
	tem.duration = 0.8+randf_range(-0.3,0.1)
	return tem
	
func GetIcePartical(p:Vector2)->PawnPartical:
	var tem = PawnPartical.new(IceParticalLine[curI],IceParticalBack[curI],Color(1,1,1,1),Color(1,1,1,1))
	curI+=1
	if curI>=2:
		curI = 0
	var dir = randf_range(0,2*PI)
	var speed = randf()
	tem.initposition = UFV.V2Rotate(Vector2(0,30)*speed,dir)+p
	tem.initSpeed = UFV.V2Rotate(speed*Vector2(0,200),dir)
	tem.rotateSpeed = randf_range(0,1)
	tem.duration = 0.8+randf_range(-0.3,0.1)
	return tem

func GenHeartPartical(p:Vector2)->PawnPartical2:
	var tem = PawnPartical2.new(TextureManager.GetTexture("HeartP"),null,Color(1,1,1,1),Color(1,1,1,1))
	var dir = randf_range(0,2*PI)
	var speed = randf()
	tem.initposition = UFV.V2Rotate(Vector2(0,30)*speed,dir)+p
	tem.initSpeed = UFV.V2Rotate(speed*Vector2(0,80),dir)
	tem.duration = 0.9+randf_range(-0.3,0.3)
	return tem
	
func GenFirePartical(p:Vector2)->PawnPartical2:
	var tem = PawnPartical2.new(TextureManager.GetTexture("FireP"),null,Color(1,1,1,1),Color(1,1,1,1))
	var dir = randf_range(0,2*PI)
	var speed = randf()
	tem.initposition = UFV.V2Rotate(Vector2(0,30)*speed,dir)+p
	tem.initSpeed = UFV.V2Rotate(speed*Vector2(0,60),dir)
	tem.duration = 0.9+randf_range(-0.3,0.3)
	return tem


func _ready() -> void:
	PawnDic = Dictionary()
	for i in PawnsInDic:
		print(i.DisPlayName)
		PawnDic[i.DisPlayName] = i
	InitData()

func _init() -> void:
	pass
