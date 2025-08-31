extends Node

const MOD_ID = "Codehead-Recurse"
var MOD_PATH = ModLoaderMod.get_unpacked_dir().plus_file(MOD_ID)

func _init():
	ModLoaderLog.info("Init", MOD_ID)

	install_script_extensions()

	# load settings interface
	var RecurseSettingsHandler = load(MOD_PATH.plus_file("settings_handler.gd")).new()
	RecurseSettingsHandler.name = "RecurseSettingsHandler"
	add_child(RecurseSettingsHandler)
	RecurseSettingsHandler.set_mod_id(MOD_ID)

func install_script_extensions() -> void:
	var extensions_dir_path = MOD_PATH.plus_file("extensions")

	var extensions = [
		"singletons/progress_data.gd", # dlc modifications are loaded in progress_data
		"singletons/run_data.gd",
		"ui/menus/shop/base_shop.gd",
	]

	for extension in extensions:
		ModLoaderMod.install_script_extension(extensions_dir_path.plus_file(extension))

func _ready():
	ModLoaderLog.info("Ready", MOD_ID)
