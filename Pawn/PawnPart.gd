class_name PawnPart
extends Node2D

@export var Data:GenPawnPartData
# Called when the node enters the scene tree for the first time.

var yPress:float = 0.5
var offsite:float = PI/24
var resolutation:int = 20
var lineWidth:float = 3

var damage1:Texture
var damage2:Texture
var damage3:Texture
var damageSprite:Sprite2D

func Damage(i:int):
	if damageSprite!=null:
		if i<=0:
			damageSprite.texture = null
		elif i<=1:
			damageSprite.texture = damage1
		elif i<=2:
			damageSprite.texture = damage2
		else:
			damageSprite.texture = damage3





func GetHeight()->float:
	return Data.GetHeight()

func Clean():
	for i in get_children():
		(i as Node).queue_free()


func GenSprite(d:PawnPartData = null):
	Clean()
	damage1 = PawnManager.GetDamageTexture(0)
	damage2 = PawnManager.GetDamageTexture(1)
	damage3 = PawnManager.GetDamageTexture(2)
	damageSprite = Sprite2D.new()
	damageSprite.self_modulate = (Data as GenPawnPartData).LineColor
	
	if d!=null:
		Data = d
	if Data == null:
		return 
	if Data is GenPawnPartData:
		GenPawnPart(Data)
	
		
	
func GenPawnPart(data:GenPawnPartData):
	
	if data.GenData:
		GenLineAndShape(data)
	else:
		var tem = Sprite2D.new()
		tem.clip_children = 2
		tem.add_child(damageSprite)
		damageSprite.position = Vector2(0,-GetHeight()/2)
		var d = data as GenPawnPartData
		tem.texture = TextureManager.GetTexture(d.TextureBack)
		tem.self_modulate = d.pawnColor
		add_child(tem)
		GenSpriteLine(data)

func GenSpriteLine(data:GenPawnPartData):
	var d = data as GenPawnPartData
	var t = 0
	for i in d.TextureLine:
		var tem = Sprite2D.new()
		tem.texture = TextureManager.GetTexture(i)
		if t<data.Colors.size():
			tem.self_modulate = data.Colors[t]
		else:
			tem.self_modulate = d.LineColor
		t+=1
		add_child(tem)

func GenLineAndShape(data:GenPawnPartData):
	var res1 = PackedVector2Array()
	var res2 = PackedVector2Array()
	var res3 = PackedVector2Array()
	var res4 = PackedVector2Array()
	var d = data as GenPawnPartData
	var da = atan2(yPress,tan(d.CurveRadin+atan2(d.height,(d.BottonRadin-d.TopRadin))))
	if da>PI/2:
		da = da-PI
	da = 0.5*PI+da
	var db = atan2(yPress,tan(atan2(d.height,(d.BottonRadin-d.TopRadin))-d.CurveRadin))
	if db>PI/2:
		db = PI-db
	db = 0.5*PI+db
	var st1 = Vector2(d.BottonRadin*sin(-da),d.BottonRadin*cos(-da)*yPress)
	var st3 = Vector2(d.TopRadin*sin(-db),d.TopRadin*cos(-db)*yPress-d.height)
	var len = (st1-st3).length()
	var dd = tan(d.CurveRadin)*len/2
	var st2 = (st1+st3)/2+UFV.V2Rotate270(st3-st1)*dd/len
	
	
	var st4 = Vector2(-st1.x,st1.y)
	var st5 = Vector2(-st2.x,st2.y)
	var st6 = Vector2(-st3.x,st3.y)
	
	
	PointInRound(-da,da,yPress,Vector2(0,0),d.BottonRadin,resolutation,res1)
	PointInCurve(st4,st5,st6,resolutation,res1)
	PointInRound(db,-db,yPress,Vector2(0,-d.height),d.TopRadin,resolutation,res1)
	PointInCurve(st3,st2,st1,resolutation,res1)
	
	var a  = PI/180*45
	var aa = 9/d.TopRadin
	
	PointInRound2(-db+offsite,a-aa*2,yPress,Vector2(0,-d.height),d.TopRadin-lineWidth*2,resolutation,res2)
	PointInRound2(a-aa,a-aa/2,yPress,Vector2(0,-d.height),d.TopRadin-lineWidth*2,1,res3)
	PointInRound2(a+aa/2,db-offsite,yPress,Vector2(0,-d.height),d.TopRadin-lineWidth*2,resolutation/2,res4)
	
	
	var ttt = QPolygon.new(res1,d.pawnColor)
	ttt.clip_children = 2
	ttt.add_child(damageSprite)
	damageSprite.position = Vector2(0,-GetHeight()/2)
	add_child(ttt)
	GenSpriteLine(data)
	add_child(QLine.new(res1,lineWidth,d.LineColor,true))
	add_child(QLine.new(res2,lineWidth,d.LineColor,false))
	add_child(QLine.new(res3,lineWidth,d.LineColor,false))
	add_child(QLine.new(res4,lineWidth,d.LineColor,false))

func PointInRound(from:float,to:float,press:float,ori:Vector2,radin:float,n:int,res:PackedVector2Array):
	while to<from:
		to+=2*PI
	var da = (to-from)/n
	var a = from+da
	for i in n-1:
		res.append(Vector2(ori.x+radin*sin(a),ori.y+radin*cos(a)*press))
		a+=da
func PointInRound2(from:float,to:float,press:float,ori:Vector2,radin:float,n:int,res:PackedVector2Array):
	while to<from:
		to+=2*PI
	var da = (to-from)/n
	var a = from
	for i in n+1:
		res.append(Vector2(ori.x+radin*sin(a),ori.y+radin*cos(a)*press))
		a+=da
		
func PointInCurve(v1:Vector2,v2:Vector2,v3:Vector2,n:int,res:PackedVector2Array):
	var a = 0
	var da = 1.0/n
	for i in n+1:
		res.append(UFV.V2Interprate(v1,v2,v3,a))
		a+=da
