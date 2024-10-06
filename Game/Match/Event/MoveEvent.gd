class_name MoveEvent
extends MatchEvent


var ToMatch:Match
var MoveType:PawnMoveAbility.MoveType
var MovePawn:Pawn
var FlyTo:Vector2i
var MoveDir:int
var MoveDis:int
var MoveHeight:float

var _animeJumpTime:float = 0.3
var _animeFlyTime:float = 0.5
var _animeBeMoveTime:float = 0.14
var _animeTime:float = 0.22

var _container:MoveContainer


func _init(moveType:PawnMoveAbility.MoveType,p:Pawn,moveDir:int,moveDis:int,flyto:Vector2i,toMatch:Match,moveHeight:float):
	Type = MatchEventType.Move
	ToMatch = toMatch
	MoveType = moveType
	MovePawn = p
	FlyTo = flyto
	MoveDir = moveDir
	MoveDis = moveDis
	MoveHeight = moveHeight


func CheckAble(b:Board)->bool:
	if MovePawn==null or MovePawn._boardCell == null:
		return false
		
	
	var ct :BoardCell
	if MoveType ==  PawnMoveAbility.MoveType.Fly:
		ct = b.GetCell(FlyTo)
	else:
		ct = b.GetCellInDri(MovePawn._boardCell.BoardPosition,MoveDir,MoveDis)
	if ct == null or ! ct.CanAddPawn(MovePawn):
		return false

	var p = ct.AddToPosition(MovePawn)
	var ttime:float = _animeTime
	if MoveType == PawnMoveAbility.MoveType.Fly:
		ttime= _animeFlyTime
	elif MoveType == PawnMoveAbility.MoveType.Jump:
		ttime = _animeJumpTime
	elif MoveType == PawnMoveAbility.MoveType.BeMoved:
		ttime = _animeBeMoveTime
	_container = MoveContainer.new(UFN.N2GlobalPosition(MovePawn),p,MovePawn,ttime,ct,ct,MoveHeight,false,null)
	SoundManager.PlaySound("Pick")
	return true


func PlayAnime(timeRate:float)->float:
	var t = _container.TotalTime*timeRate
	_container.TotalTime = t
	MovePawn._boardCell.add_child(_container)
	UFN.RemoveParent(MovePawn)
	_container.add_child(MovePawn)
	return t
