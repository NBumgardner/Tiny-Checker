class_name MoveContainer
extends Node2D

var Start:Vector2
var End:Vector2
var Height:float
var TotalTime:float
var To:Node2D
var P:Pawn
var ToCell:BoardCell
var FadeIn:bool
var MatchAdd:Match
var Summon:bool = false

var _count:float = 0
# Called when the node enters the scene tree for the first time.
func _init(start:Vector2,end:Vector2,p:Pawn,totalTime:float,toCell:BoardCell,to:Node2D = null,height:float = 0,fadeIn:bool = false,matchAdd:Match = null) -> void:
	Start = start
	End = end
	Height = height
	TotalTime = totalTime
	To = to
	P = p
	ToCell = toCell
	UFN.RemoveParent(P)
	add_child(P)
	P.position = Vector2(0,0)
	FadeIn = fadeIn
	MatchAdd = matchAdd

func SetPosition(p:Vector2):
	var tem = get_parent()
	if tem is Node2D:
		position = p-UFN.N2GlobalPosition(get_parent())
	else:
		position = p


func UpdateData(dt:float):
	_count+=dt
	if _count>TotalTime:
		_count = TotalTime
		if MatchAdd!=null:
			MatchAdd.AddPawnFromMoveContainer(self)
	var Part2:bool = _count>TotalTime/2
	if  Part2 and To!=null:
		UFN.RemoveParent(self)
		To.add_child(self)
		To = null
	if !Part2:
		var t = (1-_count/TotalTime*2)
		var tt = 1-t*t
		SetPosition(Start.lerp(End,_count/TotalTime) - Vector2(0,tt*Height))
	else:
		var t = (_count-TotalTime/2)/TotalTime*2
		var tt = 1-t*t
		SetPosition(Start.lerp(End,_count/TotalTime) - Vector2(0,tt*Height))
	if FadeIn:
		if !Part2:
			modulate = Color(1,1,1,_count/TotalTime*2)
		else:
			modulate = Color(1,1,1,1)


func _ready() -> void:
	UpdateData(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UpdateData(delta)
