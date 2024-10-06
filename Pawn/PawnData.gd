class_name PawnData
extends Resource

enum PawnType{default,TOTEM}
enum  PawnFlag{FRIEND,NUTRIAL,ENEMY}

@export var PartsData:Array[GenPawnPartData]
@export var PawnSlot:PawnData
@export var Value:int = 1
@export var Type:PawnType= PawnType.default
@export var Flag:PawnFlag = PawnFlag.FRIEND
@export var DisPlayName:String
@export var HitSound:String = "Hit"
@export var DeathSound:String = "Death"
@export var MoneyPoint:int =10
@export var AddMoveTimesPawn:int = 0

@export_group("ability")
@export var AttackNum:int = 1
@export var MaxHP:int = 3
@export var InitSheild:int = 0
@export var CanJump:bool = true
@export var CanWalk:bool = true
@export var CanOffend:bool = false
@export var CanPush:bool = false
@export var MoveAbility:Array[PawnMoveAbility]
@export var AfterTakeDamage:Array[PawnAfterTakeDamageAbility]
@export var AfterMove:Array[PawnAfterMoveAbility]
@export var AfterDeath:Array[PawnAfterDeathAbility]
@export var AfterTurn:Array[PawnAfterTurnAbility]
@export var InitFireTurn:int = 0
@export var InitIceTurn:int =0
@export var ImmuneToFire:bool = false
@export var ImmuneToIce:bool = false

func GetSelfHeight()->float:
	var res = 0
	for i in PartsData:
		res+=i.GetHeight() + 7
	return res


func GetHeight()->float:
	if PawnSlot!=null:
		return GetSelfHeight()+PawnSlot.GetHeight()
	else:
		return GetSelfHeight()
		
func GetSelfRect()->Rect2:
	var t = GetSelfHeight()
	return(Rect2(-25,-t-10,50,t+20))
	
func GetRect()->Rect2:
	var t = GetHeight()
	return(Rect2(-25,-t-10,50,t+20))
	


func CanAddData(p:PawnData)->bool:
	if p == null:
		return false
	if PawnSlot!=null:
		return PawnSlot.CanAddData(p)
	else:
		if p.Type == PawnType.TOTEM and Type == PawnType.TOTEM and p.Flag == Flag:
			return true
		return false






func AddData(d:PawnData):
	if PawnSlot!=null:
		PawnSlot.AddData(d)
	else:
		PawnSlot = d


func RemoveData()->PawnData:
	var tem = PawnSlot
	PawnSlot = null
	return tem


func Copy()->PawnData:
	var tem = PawnData.new()
	for i in PartsData:
		tem.PartsData.append(i.Copy())
	if PawnSlot!=null:
		tem.PawnSlot = PawnSlot.Copy()
	tem.Value = Value
	tem.Type = Type
	tem.Flag = Flag
	tem.CanJump = CanJump
	tem.CanWalk = CanWalk
	tem.MoveAbility = MoveAbility
	tem.AfterDeath = AfterDeath
	tem.AfterMove = AfterMove
	tem.AfterTakeDamage = AfterTakeDamage
	tem.AfterTurn = AfterTurn
	tem.CanOffend = CanOffend
	tem.CanPush = CanPush
	tem.AttackNum = AttackNum
	tem.MaxHP = MaxHP
	tem.InitSheild = InitSheild
	tem.HitSound = HitSound
	tem.DeathSound = DeathSound
	tem.DisPlayName = DisPlayName
	tem.InitFireTurn = InitFireTurn
	tem.InitIceTurn = InitIceTurn
	tem.ImmuneToFire = ImmuneToFire
	tem.ImmuneToIce = ImmuneToIce
	tem.MoneyPoint = MoneyPoint
	tem.AddMoveTimesPawn = AddMoveTimesPawn
	return tem
