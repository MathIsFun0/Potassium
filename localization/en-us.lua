return {
	descriptions = {
		Back = {
			b_banana_banana = {
				name = "Banana Deck",
				text = {
					"All cards are",
					"{C:red,T:m_stone}Gros Michel{}",
				}
			},
		},
		Blind = {
			bl_banana_banana1 = {
				name = "The Banana",
				text = {
					"One random Joker replaced",
					"with Gros Michel every hand",
				}
			},
			bl_banana_banana2 = {
				name = "The Peel",
				text = {
					"#1# in 6 chance for Jokers to",
					"go extinct when triggered",
				}
			},
		},
		Joker = {
			j_oops = {
				name = "Oops! All Bananas",
				text = {
					"Guarantees all {C:attention}listed",
					"{C:green,E:1,S:1.1}probabilities",
					"{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}inf in 3{C:inactive})",
				}
			},
			j_marble = {
				name = "Banana Farm",
				text = {
					"Adds one {C:attention}Gros Michel{}",
					"to deck when",
					"{C:attention}Blind{} is selected",
				}
			},
			j_stone = {
				name = "Banana-Flavored Banana",
				text = {
					"Gives {C:chips}+#1#{} Chips for",
					"each {C:attention}Gros Michel",
					"in your {C:attention}full deck",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
				}
			},
            j_four_fingers={
                name="Four Bananas",
                text={
                    "All {C:attention}Flushes{} and",
                    "{C:attention}Straights{} can be",
                    "made with {C:attention}4{} cards",
                },
            },
            j_8_ball={
                name="Banana Ball",
                text={
                    "{C:green}#1# in #2#{} chance for each",
                    "played {C:attention}8{} to create a",
                    "{C:tarot}Tarot{} card when scored",
                    "{C:inactive}(Must have room)",
                },
            },
            j_dna={
                name="BanaNA",
                text={
                    "If {C:attention}first hand{} of round",
                    "has only {C:attention}1{} card, add a",
                    "permanent copy to deck",
                    "and draw it to {C:attention}hand",
                },
            },
			j_banana_glopbucket = {
				name = "A Glop in the Bucket",
				text = {
					"This Joker gains",
					"{C:glop}+#1#{} Glop when each",
					"played {C:attention}card{} is scored",
					"{C:inactive}(Currently {C:glop}+#2#{C:inactive} Glop)",
				}
			}
		},
		Edition = {
			e_banana_glop = {
				name = "Glop",
				text = {
					"Scoring effects",
					"also give {C:glop}Glop"
				}
			}
		},
		Enhanced = {
			m_stone = {
				name = "Gros Michel",
				text = {
					"{C:mult}+#1#{} Mult",
					"{C:green}#2# in #3#{} to",
					"destroy card"
				}
			}
		},
		Stake = {
			stake_blue = {
				name="Blue Stake",
				text={
					"{C:red}Removes{} Discards",
				},
			}
		},
		Spectral = {
			c_banana_substance = {
				name = "Substance",
				text = {
					"Applies {C:glop}Glop{} to",
					"a random Joker",
					"Some Jokers {C:attention,E:1}evolve"
				}
			}
		}
	},
	misc={
		challenge_names = {
			c_medusa_1 = "Bananadusa",
			c_monolith_1 = "Bananolith",
		},
		dictionary = {
			k_plus_stone = "+1 Banana",
			k_balanced = "Bananalanced",
			ph_you_win = "BANANA!",
			ph_score_best_glop = "Best Glop",
			cry_hand_bulwark = "Bananawark",
		},
		labels = {
			banana_glop = "Glop",
		},
		poker_hands = {
			["cry_Bulwark"] = "Bananawark",
		},
	}
}