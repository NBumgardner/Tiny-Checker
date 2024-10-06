class_name PawnMoveAbility
extends Resource

enum MoveType{Walk,Jump,Fly,BeMoved}

@export var Type:MoveType
@export var MoveRange:int = 1
@export var HoverColor:Color = Color(1,1,1,1)
