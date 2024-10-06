extends Node
var p:Array[Pawn]
var b:Array[BoardBlock]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var x = 200
	var bb = 200
	var bbb = 400
	var bc = 0
	for i in get_children():
		if i is Pawn:
			p.append(i)
			i.position = Vector2(x,900)
			x+=100
		if i is BoardBlock:
			b.append(i)
			i.position = Vector2(bb,bbb)
			bb+=i.egdeLength*sqrt(3)
			bc+=1
			if bc==5:
				bb = 200+i.egdeLength*sqrt(3)/2
				bbb +=i.egdeLength*1.5*i.yPress
			elif bc == 8:
				bb = 200
				bbb +=i.egdeLength*1.5*i.yPress
				
	for i in p:
		i.GenSprite()
	for i in b:
		i.GenSprite()

	var player = 200
	for i in PawnManager.PlayerPawns:
		var tem = Pawn.new()
		tem.Data = i
		add_child(tem)
		tem.position = Vector2(player,200)
		tem.GenSprite()
		player+=100
	player = 200
	for i in PawnManager.PawnDic:
		print(i)
		var tem = Pawn.new()
		tem.Data = PawnManager.PawnDic[i]
		add_child(tem)
		tem.position = Vector2(player,400)
		tem.GenSprite()
		player+=100
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MouseL"):
		UFT.TakeScreenShot(self)
