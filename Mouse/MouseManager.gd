extends Node



var _mousePosition :Vector2
var _mouseSpeed:Vector2

var MouseSprite:MouseMain
var MouseParts:Array[MousePart]

func _updateMouse(dt:float):
	var t = get_viewport().get_mouse_position()
	if dt<=0:
		dt = 0.01
	_mouseSpeed = (t-_mousePosition)/dt
	_mousePosition = t
	
func MousePosition()->Vector2:
	return _mousePosition	


func MouseSpeed()->Vector2:
	return _mouseSpeed



var rCount = 0
func UpdateR(dt:float):
	rCount+=dt
func SetMode2():
	SetPartR(MouseParts[0],rCount)
	SetPartR(MouseParts[1],rCount+PI*2/3)
	SetPartR(MouseParts[2],rCount+PI*4/3)
	
func SetPartR(p:MousePart,r:float):
	p.SetData(UFV.V2Rotate(Vector2(0,-30),r)+_mousePosition,r+PI+PI/4)

var p1 = V2BounceCounter.new()
var p2 = V2BounceCounter.new()
var p3 = V2BounceCounter.new()

func UpdateP(dt:float):
	p1.End = _mousePosition+Vector2(40,50)
	p1.Update(dt)
	p2.End = p1.Data()+Vector2(40,50)*0.3
	p2.Update(dt)
	p3.End = p2.Data()+Vector2(40,50)*0.3
	p3.Update(dt)

func SetMode1():
	MouseParts[0].SetData(p1.Data(),0)
	MouseParts[1].SetData(p2.Data(),0)
	MouseParts[2].SetData(p3.Data(),0)
	rCount = 0

func Mode1():
	MouseSprite.Mode1()
	SetColor(Color(1,1,1,1))
	
	
func Mode2(r:float = 0,c:Color = Color(1,1,1,1)):
	MouseSprite.Mode2(r)
	SetColor(c)

func SetColor(c:Color):
	MouseSprite.modulate =c
	for i in MouseParts:
		i.modulate = c

func _ready() -> void:
	MouseSprite = MouseMain.new()
	add_child(MouseSprite)
	for i in 3:
		var p = MousePart.new()
		MouseParts.append(p)
		add_child(p)
	MouseSprite.Mode1()
	p1.Decay = 1.7
	p2.Decay = 1.7
	p3.Decay = 1.7
	Input.mouse_mode  = Input.MOUSE_MODE_HIDDEN
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateMouse(delta)
	MouseSprite.position = _mousePosition
	UpdateR(delta)
	UpdateP(delta)
	if MouseSprite.mode == 1:
		SetMode1()
	else:
		SetMode2()
