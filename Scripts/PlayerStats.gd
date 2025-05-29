extends Node

var life = 100
var oxygen = 100

var money = 100

var state := "Normal"

@export_enum("Normal","AlertKnow","AlertUnkown","Fight")
var detection := "Normal"

var strength := false #moveHeavyObjects
var lockPick := false #openLockedDoors
var doubleJump := false #doubleJump
var insideInfo := false #extraInfoOnScreen
var FMJ := false #bulletsGoThroWalls
var cloak := false #25%Stealth
var comfyBoots := false #NoFallDamage
var cruelty := false #SomethingCrueltySquadRelated

var keys: Array[String]
