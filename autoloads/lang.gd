extends Node

var language = "es"
var strs = {
	"wr_no_dice":{"es":"No tienes ese dado disponible"},
	"wr_no_movement":{"es":"Tu movimiento es insuficiente"},
	
	"card_desc_enemy":{"es":"Este enemigo te hará daño al finalizar el turno si no lo evitas o eliminas"},
	"card_desc_trap":{"es":"Esta trampa te hará daño al finalizar el turno si no la evitas o desarmas"}
}

func get_string(code):
	return strs[code][language]
