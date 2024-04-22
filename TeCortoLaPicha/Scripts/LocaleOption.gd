extends OptionButton

var langs : PackedStringArray

func _ready():
	langs = TranslationServer.get_loaded_locales()
	for locale in langs:
		add_item(TranslationServer.get_locale_name(locale))
		pass
	select(langs.find("es"))
	pass


func _on_item_selected(index):
	TranslationServer.set_locale(langs[index])
	pass
