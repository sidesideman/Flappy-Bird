extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flap_audio: AudioStreamPlayer = $flapAudio
@onready var hit_audio: AudioStreamPlayer = $hitAudio
@onready var die_audio: AudioStreamPlayer = $dieAudio
@onready var die_audio_timer: Timer = $dieAudio/dieAudioTimer

#const SPEED = 300.0
const JUMP_VELOCITY = -300.0
const FALL_SPEED = 300

var is_dead := false
var fall := false


func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)

func _physics_process(delta: float) -> void:
	if global_position.y == 600:
		queue_free()
	if not is_dead:
	# Add the gravity.
		velocity += get_gravity() * delta
	
	# Handle jump.
	
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			animated_sprite.play("flap")
			flap_audio.play()
			rotation_degrees = -90
		rotation_degrees = min(rotation_degrees + 3, 90)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_dead and not fall:
		return
	
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.play("idle")

func _on_player_died() -> void:
	is_dead = true
	hit_audio.play()
	die_audio_timer.start()
	animated_sprite.pause()
	collision_shape.set_deferred("disabled", true)
	velocity.y = FALL_SPEED

func _on_die_sound_timer_timeout() -> void:
	fall = true
	var bus_index = AudioServer.get_bus_index("Die")
	var pitch_effect = AudioServer.get_bus_effect(bus_index, 0)
	var pitch_scale := (die_audio.stream.get_length() - 0.35) / ((512 - global_position.y) / FALL_SPEED)
	die_audio.pitch_scale = pitch_scale
	pitch_effect.pitch_scale = 1 / pitch_scale
	die_audio.play(0.35)
	
