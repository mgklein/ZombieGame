class_name Weapon extends Resource

@export var weapon_name : String = "Axe"
@export var damage: float = 25.0
@export var max_ammo: int = 12
@export var range: float = 25.0
@export var projectile_speed: float = 50.0
@export var is_hitscan: bool = false
@export var projectile_gravity: bool = true
@export var projectile_weight: float = 1.0
@export var weapon_model: PackedScene
@export var projectile_scene: PackedScene
@export var weapon_position: Vector3 = Vector3(0.2, -0.2, -0.3)
