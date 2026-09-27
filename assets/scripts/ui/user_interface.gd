class_name UserInterface extends CanvasLayer

@onready var charge_indicator: ColorRect = $CenterContainer/ChargeIndicator
@onready var health_bar: SegmentedBar = $HealthBar

var player: PlayerController
var charge_level: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	charge_indicator.custom_minimum_size = Vector2(10.0, charge_level * 100)
	# Find player
	var player = get_tree().get_first_node_in_group("player")
	
	# Connect signals
	if player:
		var health_component = player.get_node_or_null("HealthComponent")
		health_bar.slow_change(health_component.current_health, Color.GHOST_WHITE, 1.0)
