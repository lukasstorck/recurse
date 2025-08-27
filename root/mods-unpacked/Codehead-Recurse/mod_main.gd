extends Node

const MOD_ID = "Codehead-Recurse"

func _init():
	ModLoaderLog.info("Init", MOD_ID)
	ModLoaderMod.install_script_extension("res://mods-unpacked/Codehead-Recurse/extensions/dlcs/dlc_1/dlc_1_data.gd")
	ModLoaderMod.install_script_extension("res://mods-unpacked/Codehead-Recurse/extensions/ui/menus/shop/base_shop.gd")

func _ready():
	ModLoaderLog.info("Ready", MOD_ID)
