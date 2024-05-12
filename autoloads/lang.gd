extends Node

var language = "es"
var strs = {
	"no_dices":{"es":"Dados insuficientes"}
}

func get_string(code):
	return strs[code][language]
