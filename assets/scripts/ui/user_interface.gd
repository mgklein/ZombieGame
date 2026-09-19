class_name UserInterface extends CanvasLayer

@onready var charge_indicator: ColorRect = $CenterContainer/ChargeIndicator

var charge_level: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	charge_indicator.custom_minimum_size = Vector2(10.0, charge_level * 100)
