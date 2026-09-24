extends Node

signal clee_bleu_change(valeur)
signal clee_rouge_change(valeur)

var nb_clee_bleu: int = 0
var nb_clee_rouge: int = 0

func augmenter_clee_bleu() -> void:
	nb_clee_bleu += 1
	print("✅ Clé BLEUE ajoutée →", nb_clee_bleu)
	clee_bleu_change.emit(nb_clee_bleu)

func augmenter_clee_rouge() -> void:
	nb_clee_rouge += 1
	print("🔴 Clé ROUGE ajoutée →", nb_clee_rouge)
	clee_rouge_change.emit(nb_clee_rouge)
