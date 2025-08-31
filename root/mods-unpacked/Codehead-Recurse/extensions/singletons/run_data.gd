extends "res://singletons/run_data.gd"

var recurse_mode: String = "simple"

onready var RecurseSettingsHandler = get_node("/root/ModLoader/Codehead-Recurse/RecurseSettingsHandler")

func _ready():
	if RecurseSettingsHandler != null:
		recurse_mode = RecurseSettingsHandler.get_settings()["RECURSE_MODE"]
