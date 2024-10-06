class_name BoardBlock
extends Node2D

@export var Data:BoardBlockData

var yPress:float = 0.7
var egdeLength:float = 60
var lineWidth:float = 3
var offsite:float = 8

var selectA:SelectBlockA
var selectB:SelectBlockB

func Clean():
	for i in get_children():
		(i as Node).queue_free()


func GenSprite():
	Clean()
	
	if Data.GenData:
		GenLineAndShape()
	else:
		GenTexture()
	
	
	var tem = SelectBlockA.new()
	add_child(tem)
	selectA = tem
	selectA.position = Vector2(0,-3)
	tem = SelectBlockB.new()
	add_child(tem)
	selectB = tem
	selectB.position = Vector2(0,-3)

func GenTexture():
	if Data.TextureName!="":
		var tem = Sprite2D.new()
		tem.texture = TextureManager.GetTexture(Data.TextureName)
		add_child(tem)

func GenLineAndShape():
	var res1 = PackedVector2Array()
	var res2 = PackedVector2Array()
	var res3 = PackedVector2Array()
	var res4 = PackedVector2Array()
	
	res1.append(UFV.V2YPress(UFV.V2Rotate(Vector2(0,-egdeLength),-PI/3),yPress))
	res1.append(Vector2(0,-egdeLength*yPress))
	res1.append(UFV.V2YPress(UFV.V2Rotate(Vector2(0,-egdeLength),PI/3),yPress))
	var t1 = UFV.V2Rotate(Vector2(0,-egdeLength),PI*2/3)
	res1.append(UFV.V2YPress(t1+Vector2(0,+Data.height),yPress))
	res1.append(Vector2(0,egdeLength+Data.height)*yPress)
	var t2 = UFV.V2Rotate(Vector2(0,-egdeLength),-PI*2/3)
	res1.append(UFV.V2YPress(t2+Vector2(0,+Data.height),yPress))
	
	res2.append(UFV.V2YPress(t1+UFV.V2Rotate(Vector2(0,-offsite),-PI*2/3),yPress))
	res2.append(Vector2(0,egdeLength*yPress))
	res2.append(UFV.V2YPress(t2+UFV.V2Rotate(Vector2(0,-offsite),PI*2/3),yPress))
	res3.append(Vector2(0,egdeLength*yPress))
	res3.append(Vector2(0,(egdeLength+Data.height-offsite)*yPress))
	
	res4.append(res1[3])
	res4.append(res1[4])
	res4.append(res1[5])
	res4.append(UFV.V2YPress(t2,yPress))
	res4.append(Vector2(0,egdeLength)*yPress)
	res4.append(UFV.V2YPress(t1,yPress))


	add_child((QPolygon.new(res1,Data.MainColor)))
	add_child(QPolygon.new(res4,Data.EdgeColor))
	GenTexture()
	add_child(QLine.new(res1,lineWidth,Data.LineColor,true))
	add_child(QLine.new(res2,lineWidth,Data.LineColor,false))
	add_child(QLine.new(res3,lineWidth,Data.LineColor,false))

func SelectA(c:Color = Color(1,1,1,1),s:float = 1):
	selectA.c = c
	selectA.Appear(s)
	SoundManager.PlaySound("SelectBlock")
	
func DeselectA():
	selectA.DisAppear()
	
func SelectB(c:Color = Color(1,1,1,1),s:float = 1):
	selectB.c = c
	selectB.Appear(s)

	
func DeselectB():
	selectB.DisAppear()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
