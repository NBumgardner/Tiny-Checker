class_name DealDamageEvent
extends MatchEvent


var Form:Pawn
var To:Pawn
var Damage:int

var _interTime = 0.05


func _init(form:Pawn,to:Pawn,damage:int) -> void:
	Form = form
	To = to
	Damage = damage
	Type = MatchEvent.MatchEventType.DealDamage

# Called when the node enters the scene tree for the first time.
func CheckAble(b:Board)->bool:
	return  To !=null and Damage>0
	
func PlayAnime(timeRate:float)->float:
	#To.TakeDamage(Damage)
	return timeRate*_interTime
