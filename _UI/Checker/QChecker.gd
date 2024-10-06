class_name QChecker
extends Node2D

var Data:PawnData
var Textbox:QTextBox
var OtherTextBoxs:Array[QTextBox]

func _init(data:PawnData):
	Data = data
	


func GenString()->String:
	if Data == null:
		return ""
	var res = ""
	res+="Name : "+Data.DisPlayName+"\n"
	res+="HP : "+str(Data.MaxHP)+"\n"
	res+="Attack : "+str(Data.AttackNum)+"\n"
	res+="Value : "+str(Data.Value)+"\n"
	var move:int = 0
	var jump:int = 0
	var fly :int = 0
	for i in Data.MoveAbility:
		if i.Type == PawnMoveAbility.MoveType.Walk:
			if i.MoveRange>move:
				move = i.MoveRange
		elif i.Type == PawnMoveAbility.MoveType.Jump:
			if i.MoveRange>jump:
				jump = i.MoveRange
		elif i.Type == PawnMoveAbility.MoveType.Fly:
			if i.MoveRange>fly:
				fly = i.MoveRange		
	if move <=0 and Data.CanWalk:
		move = 1
	if jump <=0 and Data.CanJump:
		jump = 1
	
	if move<=0:
		res +="Can't move\n"
	else:
		res+="Can move "+str(move)+" block\n"
	if jump<=0:
		res+="Can't jump\n"
	else:
		res+="Can jump "+str(jump)+" block\n"
	if fly>0:
		res+="Can fly "+str(fly)+" block\n"
	if Data.CanOffend:
		res+="Can hit pieces\n"
	if Data.CanPush:
		res+="Can push pieces\n"
	if Data.Flag != PawnData.PawnFlag.FRIEND:
		res+="Destroy for "+str(Data.MoneyPoint)+" gold coins\n"
	res+="\n------Ability------\n\n"
	if Data.AddMoveTimesPawn>0:
		res+="Give you "+str(Data.AddMoveTimesPawn)+" extra move"
	for i in Data.AfterDeath:
		res +=i.Discrabe+"\n"
	for i in Data.AfterMove:
		res +=i.Discrabe+"\n"
	for i in Data.AfterTurn:
		res +=i.Discrabe+"\n"
	for i in Data.AfterTakeDamage:
		res +=i.Discrabe+"\n"
	return res
		
		
func Destory():
	if Textbox!=null:
		Textbox.Destory()
	for i in OtherTextBoxs:
		if i!=null:
			i.Destory()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var text = GenString()
	var line  =text.count("\n")
	Textbox = QTextBox.new(text,Vector2(500,(line*60+40)*0.4),Data.PartsData[0].LineColor,Color(0,0,0,1),0)
	Textbox.TextSize = 0.4
	Textbox.Mute = true
	Textbox.Speed = 3
	add_child(Textbox)
	var tem = QTextBox.new("",Vector2(100,100),Color(1,1,1,1),Color(0,0,0,1))
	var tt = Pawn.new()
	tt.Data = Data
	tt.GenSprite()
	tt.z_index = 1
	tt.position = Vector2(30,30)
	tem.add_child(tt)
	tem.position = Vector2(300,-(line*60+40)*0.2+60)
	OtherTextBoxs.append(tem)
	add_child(tem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
