extends Node


var GlobalCheckerContainer:CheckContainer



func Ckeck(p:PawnData):
	if GlobalCheckerContainer!=null:
		GlobalCheckerContainer.Check(p)
