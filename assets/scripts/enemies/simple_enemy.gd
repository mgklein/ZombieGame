class_name SimpleEnemy
extends GenisysEnemy


@export var follow_speed: float = 3.0
@export var acceleration: float = 3.0 # Idk what are good numbers yet, video glosses over
@export var deceleration: float = 1.0 # Idk what are good numbers yet, video glosses over
@export var melee_range: float = 1.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_chart: StateChart = $StateChart
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $zombie_with_modelsv1/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

var target: Node3D
var ready_to_follow: bool = false
var anim_tree_state: AnimationNodeStateMachinePlayback

func _ready() -> void:
	super._ready()
	
	# Find player
	target = get_tree().get_first_node_in_group("player")
	
	# Connect signals
	health_component.died.connect(_on_died)
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	
	anim_tree_state = anim_tree["parameters/playback"]
	
	while anim_tree_state.get_current_node() != "Idle":
		await get_tree().process_frame
	anim_tree["parameters/Idle/TimeSeek/seek_request"] = randf_range(0.0, 1.0)
	
	#if animation_player:
		#animation_player.play("Zombie_Rise")
		#await animation_player.animation_finished
		#animation_player.play("Zombie_Idle")
		#animation_player.seek(randf_range(0.0, animation_player.current_animation_length))
	
	ready_to_follow = true


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta # Tutorial just used velocity.y -= 20.0 * delta
	
	move_and_slide()
	update_blends()


func on_triggered() -> void:
	state_chart.send_event("toFollow")


func _on_died() -> void:
	ready_to_follow = false
	nav_agent.velocity = Vector3.ZERO
	anim_tree_state.travel("Death")
	await anim_tree.animation_finished
	queue_free()


func _on_velocity_computed(safe_velocity: Vector3) -> void:
	var target_velocity = Vector3(safe_velocity.x, safe_velocity.y, safe_velocity.z)
	var accel = acceleration if safe_velocity.length() > 0.01 else deceleration
	velocity.x = move_toward(velocity.x, target_velocity.x, accel * get_physics_process_delta_time())
	velocity.z = move_toward(velocity.z, target_velocity.z, accel * get_physics_process_delta_time())

func _on_follow_state_physics_processing(delta: float) -> void:
	if anim_tree_state.get_current_node() == "Idle":
		anim_tree_state.travel("Follow")
	
	if not target or not ready_to_follow:
		return
	
	# Set target position for navigation
	nav_agent.target_position = target.global_position
	
	# Check if in attack range
	var distance = global_position.distance_to(target.global_position)
	if distance <= melee_range:
		state_chart.send_event("toAttack")
		return
	
	# Check if navigation finished
	if nav_agent.is_navigation_finished():
		nav_agent.velocity = Vector3.ZERO
		#if animation_player and animation_player.current_animation != "Zombie_Idle":
		#	animation_player.play("Zombie_Idle")
		return
	
	# Get next position in path
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	
	# Set desired velocity (NavigationAgent handles avoidance)
	#var distance = global_position.distance_to(target.global_position)
	#var speed_factor = clamp(distance / 5.0, 0.0, 1.0)
	#var desired_speed = follow_speed * speed_factor
	#nav_agent.velocity = direction * desired_speed
	
	nav_agent.velocity = direction * follow_speed
	
	# Smoothly accelerate toward target
	if not nav_agent.avoidance_enabled:
		var target_velocity_x = direction.x * follow_speed
		var target_velocity_z = direction.z * follow_speed
		velocity.x = move_toward(velocity.x, target_velocity_x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity_z, acceleration * delta)
	
	
	#if animation_player and animation_player.current_animation != "Zombie_Walk":
		#animation_player.play("Zombie_Walk")
	
	# Rotate to face movement direction
	if direction.length() > 0.01:
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, 5.0 * delta)



func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		on_triggered()


func update_blends() -> void:
	var move_amount = velocity.length()
	move_amount = remap(move_amount, 0.0, follow_speed, 0.0, 1.0)
	anim_tree["parameters/Follow/IdleChaseBlend/blend_position"] = move_amount


func attack() -> void:
	# Stop movement
	velocity = Vector3.ZERO
	nav_agent.velocity = Vector3.ZERO
	
	# Face the player
	if target:
		var direction = (target.global_position - global_position).normalized()
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = target_rotation
	
	# Play the attack animation
	if anim_tree_state.get_current_node() != "Attack":
		anim_tree_state.travel("Attack")
	else:
		anim_tree_state.start("Attack")
	
	# Wait for animation to finish
	await anim_tree.animation_finished
	
	# Check distance to decide next state
	if target:
		var distance = global_position.distance_to(target.global_position)
		if distance <= melee_range:
			# Still in range, attack again
			attack()
		else:
			# Out of range, chase again
			state_chart.send_event("toFollow")


func _on_attack_state_entered() -> void: # I'll leave the state logic for now, but the video basically set it all up and then immediately remove it
	attack()


func apply_player_damage() -> void:
	if target:
		var player_health_component = target.get_node_or_null("HealthComponent")
		if player_health_component and player_health_component.has_method("take_damage"):
			player_health_component.take_damage(1.0, self)
