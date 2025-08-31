extends Node

onready var ModMain = get_node_or_null("/root/ModLoader/Codehead-Recurse")
onready var ModsConfigInterface = get_node_or_null("/root/ModLoader/dami-ModOptions/ModsConfigInterface")
onready var RecurseSettingsHandler = get_node("/root/ModLoader/Codehead-Recurse/RecurseSettingsHandler")

func _ready():
	if ModsConfigInterface != null:
		ModsConfigInterface.connect("setting_changed", self, "on_config_changed")
	
	var config = get_config()
	for key in config.data.keys():
		if ModsConfigInterface != null:
			ModsConfigInterface.on_setting_changed(key, config.data[key], ModMain.MOD_ID)
		else:
			RunData.set(key.to_lower(), config.data[key])

func on_config_changed(setting_name: String, value, mod_id: String):
	if mod_id == ModMain.MOD_ID:
		update_config_value(setting_name, value)

func get_config(key: String = "") -> ModConfig:
	if key != "":
		return get_config().data[key]

	var version = ModLoaderStore.mod_data[ModMain.MOD_ID].manifest.version_number
	var config = ModLoaderConfig.get_config(ModMain.MOD_ID, version)

	if config != null:
		return config
	
	var default_config = ModLoaderConfig.get_default_config(ModMain.MOD_ID)
	if default_config == null:
		ModLoaderLog.error("Neither a saved config or the default config were found", ModMain.MOD_ID)
		return null

	config = ModLoaderConfig.create_config(ModMain.MOD_ID, version, default_config.data)
	ModLoaderLog.info("Created recurse config from default values", ModMain.MOD_ID)
	return config

func update_config_value(key: String, value):
	var config = get_config()

	if !config.data.has(key):
		return

	# save to config file
	config.data[key] = value
	ModLoaderConfig.update_config(config)

	# update value in memory
	RunData.set(key.to_lower(), value)

# TODO:
# - switch from RunData.variables to ProgressData.settings.MOD_ID.variables as dict
# - add translation
