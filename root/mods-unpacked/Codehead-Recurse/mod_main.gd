extends Node

const MOD_ID = "Codehead-Recurse"

func _init():
	ModLoaderLog.info("Init", MOD_ID)

	# dlc modifications are loaded in progress_data
	ModLoaderMod.install_script_extension("res://mods-unpacked/Codehead-Recurse/extensions/singletons/progress_data.gd")
	ModLoaderMod.install_script_extension("res://mods-unpacked/Codehead-Recurse/extensions/ui/menus/shop/base_shop.gd")

func _ready():
	ModLoaderLog.info("Ready", MOD_ID)
