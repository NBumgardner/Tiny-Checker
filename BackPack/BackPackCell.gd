class_name BackPackCell
extends Node2D


@export var P:BackPackPawn

var block:BoardBlock
var blockOffset:Vector2 = Vector2(0,-5)

func GenPlayerBlock(i:int,blockYPress:float,blockLength:float):
	var BlockData = BoardManager.GetPlayerBoardBlockData(i)
	var tem = BoardBlock.new()
	tem.Data = BlockData
	add_child(tem)
	tem.position = blockOffset
	tem.yPress = blockYPress
	tem.egdeLength = blockLength
	tem.GenSprite()
	position.y-=BlockData.height
	block = tem
	
func GenEmpty(blockYPress:float,blockLength:float):
	var BlockData = BoardManager.GetEmptyBlockData()
	var tem = BoardBlock.new()
	tem.Data = BlockData
	add_child(tem)
	tem.position = blockOffset
	tem.yPress = blockYPress
	tem.egdeLength = blockLength
	tem.GenSprite()
	block = tem

func CanAddPawn(p:BackPackPawn):
	if P == null:
		return true
	else :
		if p == P:
			return true
		return P.CanAddPawn(p)

func AddPawn(p:BackPackPawn):
	if P==null:
		SoundManager.PlaySound("Drop")
		p.RemoveFrom()
		UFN.RemoveParent(p)
		add_child(p)
		p.position = Vector2(0,0)
		p.parentPawn = null
		p.cell = self
		P = p
	else:
		if p == P:
			UFN.RemoveParent(p)
			add_child(p)
			p.position = Vector2(0,0)
			p.parentPawn = null
			p.cell = self
			P = p
			SoundManager.PlaySound("Drop")
			return
		P.AddPawn(p)
		
func Hover():
	if block!=null:
		block.SelectA()
		
func Dehover():
	if block!=null:
		block.DeselectA()
	

func RemovePawn()->BackPackPawn:
	var tem = P
	P = null
	return P
