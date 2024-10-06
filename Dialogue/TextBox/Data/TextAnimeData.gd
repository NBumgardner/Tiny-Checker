class_name TextAnimeData
extends Resource



@export_group("Appear")
@export_subgroup("Position","AppearPosition")
@export var AppearPositionStart:Vector2
@export var AppearPositionSpeed:float = 1
@export var AppearPositionDecay:float = 1

@export_subgroup("Scale","AppearScale")
@export var AppearScaleStart:Vector2 = Vector2(1,1)
@export var AppearScaleSpeed:float = 1
@export var AppearScaleDecay:float = 1

@export_subgroup("Rotate","AppearRotate")
@export var AppearRotateStart:float = 0
@export var AppearRotateSpeed:float = 1
@export var AppearRotateDecay:float = 1

@export_subgroup("FadeIn","FadeIn")
@export var FadeIn:bool
@export var FadeInTime:float = 0.3

@export_group("Cycle")
@export_subgroup("Position","CyclePosition")
@export var CyclePositionRange:Vector2
@export var CyclePositionPhase = PI/2
@export var CyclePositionTime = 2

@export_subgroup("Scale","CycleScale")
@export var CycleScaleRange:Vector2 = Vector2(1,1)
@export var CycleScalePhase = PI/2
@export var CycleScaleTime = 2

@export_subgroup("Rotate","CycleRotate")
@export var CycleRotateRange:float = 0
@export var CycleRotateTime = 2

@export_group("Disappear")
@export_subgroup("Position","DisappearPosition")
@export var DisappearPositionOffset:Vector2
@export var DisappearPositionSpeed:float = 1

@export_subgroup("Scale","DisappearScale")
@export var DisappearScaleOffset:Vector2 = Vector2(1,1)
@export var DisappearScaleSpeed:float = 1

@export_subgroup("FadeOut","FadeOut")
@export var FadeOut:bool
@export var FadeOutTime:float = 0.3
