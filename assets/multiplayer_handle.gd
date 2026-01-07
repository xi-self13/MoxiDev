extends Node
class_name MultiPlayer

# i have no clue on what i am doing here... :( - XiLy

@onready var mp : WebSocketMultiplayerPeer
@onready var tls : TLSOptions
func _ready() -> void:
	pass

func create_server_player():
	mp.create_server(8000, "0.0.0.0")

func create_client():
	mp.create_client("ws://0.0.0.0:8000")

func close_connection():
	mp.close()