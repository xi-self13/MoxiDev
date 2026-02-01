extends CharacterBody3D
class_name Zombie

@export var health : float = 100.0
@export var damage : float = 5.0
@export var target : Player
@export var movement_speed : float = 5.0

#@onready var see = $ShapeCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var fall_multi := 1.0
signal detected_player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()
	if not is_on_floor():
		if velocity.y >= 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * 0.5 * fall_multi
	var direction := (transform.basis * Vector3(target.position.x, target.position.y, target.position.z)).normalized()
	#if self.position.distance_to(target.position) < 7.0:
	#	self.position = self.position.lerp(target.position, movement_speed / 100)
	if self.position.distance_to(target.position) < 7.0:
		self.position.x = move_toward(self.position.x, target.position.x, delta * movement_speed / 10)
		self.position.y = move_toward(self.position.y, target.position.y, delta * movement_speed / 10)
		self.position.z = move_toward(self.position.z, target.position.z, delta * movement_speed / 10)
	else:
		pass
	if self.position.distance_to(target.position) < 2.0:
		target.current_health -= randi_range(1, 2)
		target.velocity.y = 2
		target.velocity.z = 1
		target.check_is_dead()


func _on_body_entered(body: Node3D) -> void:
	pass
