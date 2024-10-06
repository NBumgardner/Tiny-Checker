extends Node


@export var BoardDatas:Array[BoardData]

@export var BoardBlockDatas:Array[BoardBlockData]
@export var PlayerBoardBlockDatas:Array[BoardBlockData]
@export var EnemyBoardBlockDatas:Array[BoardBlockData]

var selectL = 35
var _lq3:float = selectL*sqrt(3)

func GetBoardData(i:int):
	return BoardDatas[i]
	
func GetBoardBlockData(i:int)->BoardBlockData:
	if i>=BoardBlockDatas.size():
		i = 0
	return BoardBlockDatas[i]
	
func GetPlayerBoardBlockData(i:int)->BoardBlockData:
	return PlayerBoardBlockDatas[i]
	
func GetEnemyBoardBlockData(i:int)->BoardBlockData:
	return EnemyBoardBlockDatas[i]

func GetEmptyBlockData()->BoardBlockData:
	var tem:BoardBlockData= BoardBlockData.new()
	tem.GenData = false
	tem.height = 0
	return tem

func GetLQ3()->float:
	return _lq3

func GetL()->float:
	return selectL
	
func GetYP()->float:
	return 0.8
