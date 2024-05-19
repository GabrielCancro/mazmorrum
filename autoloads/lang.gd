extends Node

var language = "es"
var strs = {
	"wr_no_dice":{"es":"No tienes ese dado disponible"},
	"wr_no_movement":{"es":"Tu movimiento es insuficiente"},
	"wr_many_items":{"es":"Tu inventario esta lleno"},
	
	"card_desc_enemy":{"es":"Este enemigo te hará daño al finalizar el turno si no lo evitas o eliminas"},
	"card_desc_trap":{"es":"Esta trampa te hará daño al finalizar el turno si no la evitas o desarmas"},
	
	"item_sword1":{"es":"Esta espada te suma dos dados de guerrero"},
	"item_shield1":{"es":"Este escudo reduce el daño que recibes en 50%"},
	"item_potion1":{"es":"Esta pocion te cura al beberla"},
	
	"ac_attack":{"es":"Atacar"},
	"ac_evade":{"es":"Evadir"},
	"ac_disarm":{"es":"Desarmar"},
}

func get_string(code):
	if code in strs: return strs[code][language]
	else: return "<"+code+">"
