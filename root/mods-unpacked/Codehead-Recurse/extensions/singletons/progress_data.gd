extends "res://singletons/progress_data.gd"

var mod_settings: Dictionary = {}

func load_dlc_pcks() -> void:
	.load_dlc_pcks()
	
	ModLoaderMod.install_script_extension("res://mods-unpacked/Codehead-Recurse/extensions/dlcs/dlc_1/dlc_1_data.gd")
