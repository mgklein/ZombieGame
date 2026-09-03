class_name Projectile extends Area3D


var velocity: Vector3
var damage: float

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(3.0).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	rotate_object_local(Vector3.RIGHT, -10.0 * delta)
	


func setup(vel: Vector3, dmg: float) -> void:
	velocity = vel
	damage = dmg


func _on_body_entered(body: Node3D) -> void:
	if not body.name == "PlayerController":
		print("Projectile hit: ", body.name, " at ", global_position)
		_spawn_impact_marker(global_position)
		queue_free()


func _spawn_impact_marker(spawn_position: Vector3) -> void:
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	get_tree().current_scene.add_child(marker)
	marker.global_position = spawn_position
	
	# Auto-remove after 2 seconds
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)
