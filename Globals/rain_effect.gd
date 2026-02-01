extends GPUParticles3D

@export var rain_intensity: float = 1.0

func _ready():
	emitting = true
	amount = int(100 * rain_intensity)
	lifetime = 5.0
	process_material = ParticleProcessMaterial.new()
	process_material.direction = Vector3(0, -1, 0)
	process_material.spread = 10.0
	process_material.initial_velocity_min = 10.0
	process_material.initial_velocity_max = 20.0
	process_material.gravity = Vector3(0, -9.8, 0)
	process_material.particle_flag_align_y = true

