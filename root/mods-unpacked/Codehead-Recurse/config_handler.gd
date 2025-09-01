extends Node

onready var ModMain = get_node_or_null("/root/ModLoader/Codehead-Recurse")
onready var ModsConfigInterface = get_node_or_null("/root/ModLoader/dami-ModOptions/ModsConfigInterface")

func _ready():
	if ModsConfigInterface != null:
		ModsConfigInterface.connect("setting_changed", self, "on_config_changed")
	
	var config = load_config()
	ProgressData.mod_settings.merge(config.data)
	ProgressData.mod_settings.recurse_mod_id = ModMain.MOD_ID

	if ModsConfigInterface != null:
		# set values in ModsConfigInterface
		# this also calls update_config_value which would not be necessary, as the
		# values are already set from above, but also does no harm ._.
		for key in config.data.keys():
			ModsConfigInterface.on_setting_changed(key, config.data[key], ModMain.MOD_ID)

func on_config_changed(setting_name: String, value, mod_id: String):
	if mod_id == ModMain.MOD_ID:
		update_config_value(setting_name, value)

func load_config(key: String = "") -> ModConfig:
	if key != "":
		return load_config().data[key]

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
	var config = load_config()

	if !config.data.has(key):
		return

	# save to config file
	config.data[key] = value
	ModLoaderConfig.update_config(config)

	# update value in memory
	ProgressData.mod_settings[key] = value

# TODO:
# - add translation
