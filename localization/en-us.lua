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
					"{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}bananeinf in 3{C:inactive})",
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
			j_banner = {
				name = "Bananner",
                text={
                    "{C:chips}+#1#{} Chips for",
                    "each remaining",
                    "{C:attention}discard",
                },
			},
			j_flower_pot = {
				name = "Flower Pot",
				text = {
                    "{X:mult,C:white} X3 {} Mult and {C:glop}+1{} Glop",
                    "if poker hand contains a",
					"{C:attention}Queen{}, {C:attention}Jack{}, {C:attention}10{}, and {C:attention}2",
				},
                unlock={
                    "Reach Ante",
                    "level {E:1,C:attention}#1#",
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
			},
			j_banana_glopcorn = {
				name = "Glop Corn",
				text = {
					"{C:glop}+#2#{} Glop",
					"Decreases by {C:glop}#1#{} at",
					"end of round",
					"{C:inactive,s:0.8}Fresh off the clob",
				}
			},
			j_banana_glopmichel = {
				name = "Glop Michel",
				text = {
					"{C:glop}+#3#{} Glop",
					"{C:green}#2# in #1#{} chance for",
					"{C:glop}+#4#{} Glop instead"
				}
			},
			j_banana_glopcola = {
				name = "Glop Cola",
                text={
                    "Sell this card to",
                    "create a free",
                    "{C:glop}#1#",
                },
			},
			j_banana_glopendish = {
				name = "Glopendish",
				text = {
                    "When {C:attention}Blind{} is selected, {C:green}#2# in #4#{} chance ",
                    "to destroy Joker to the right",
                    "and permanently add {C:attention}one-tenth{} of",
                    "its sell value to this {C:glop}Glop",
					"{C:green}#2# in #3#{} chance this card",
                    "is destroyed at end of round",
                    "{C:inactive}(Currently {C:glop}+#1#{C:inactive} Glop)",
				}
			},
			j_banana_glopmother = {
				name = "Glopmother",
				text = {
					"{X:glop,C:white,E:1,s:1.5}^2{s:1.5,E:1,C:dark_edition} Glop"
				}
			},
			j_banana_glopmother_fake_out = {
				name = "Glopmother",
				text = {
					"Playing cards give",
					"{X:sfark,C:white}X7{} Sfark when scored"
				}
			},
			j_banana_glopku = {
				name = "Glopku",
				text = {
                    "Every played {C:attention}card{}",
                    "permanently gains",
                    "{C:glop}+#1#{} Glop when scored",
				}
			},
			j_banana_plantation = {
				name = "Plantation",
				text = {
					"{C:attention}Banana{} Jokers give {X:mult,C:white}X#1#{} Mult",
					"At end of round, apply",
					"{C:attention}Banana{} to adjacent Jokers",
				}
			},
			j_banana_bluejava = {
				name = "Blue Java",
				text = {
                    "{X:dark_edition,C:white} ^#1# {} Mult",
                    "{C:green}#2# in #3#{} chance this",
                    "card is destroyed",
                    "at end of round",
				}
			},
			j_banana_bananasplit = {
				name = "Banana Split",
				text = {
					"{C:chips}+#1#{} Chips",
                    "{C:green}#2# in #3#{} chance this",
                    "card is {C:attention}split",
                    "at end of round",
					"{C:inactive}(Does not require room)"
				}
			},
			j_banana_potassium = {
				name = "Potassium in a Bottle",
				text = {
					"Retrigger all cards {C:attention}#1#{} additional times",
					"Scoring cards become {C:attention}Banana",
                    "{C:green}#2# in #3#{} chance this card",
                    "is destroyed at end of round",
				}
			},
			j_banana_begg = {
				name = "Begg",
				text = {
                    "Gains {C:money}$#1#{} of",
                    "{C:attention}sell value{} at",
                    "end of round",
					"{C:green}#2# in #3#{} chance to",
					"{C:attention}halve{} sell value instead"
				}
			},
			j_banana_bean = {
				name = "Banana Bean",
				text = {
                    "{C:attention}+#1#{} hand size, increases",
                    "by {C:attention}#2#{} every round",
					"{C:green}#3# in #4#{} chance to destroy",
					"this Joker and scored cards",
					"when hand played"
				}
			},
			j_banana_bread = {
				name = "Banana Bread",
				text = {
					"Gain {X:mult,C:white} X#1# {} Mult when a",
					"{C:attention}Banana{} card goes extinct",
					"{C:inactive}(Currently: {X:mult,C:white}X#2#{C:inactive} Mult)",
				}
			},
			j_banana_glegg = {
				name = "Glegg",
				text = {
					"When Blind selected,",
					"create a {C:attention}Glopur{C:inactive,E:1}?",
					"{C:inactive}(Must have room)"
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
                    "{s:0.8}Applies all previous Stakes",
				},
			},
			banana = {
				name = "Banana Stake",
				text = {
					"Cards can be {C:attention}Banana{}",
					"{s:0.8,C:inactive}({C:green}1 in 10{C:inactive} chance of being destroyed each round){}",
                    "{s:0.8}Applies all previous Stakes",
				},
			},
		},
		Spectral = {
			c_banana_substance = {
				name = "Substance",
				text = {
					"Applies {C:glop}Glop{} to",
					"a random Joker",
					"Some Jokers {C:attention,E:1}evolve"
				}
			},
			c_banana_glopularity = {
				name = "Glopularity",
				text = {
					"{C:attention}Halve{} all hand levels,",
					"all poker hands gain {C:glop}+0.2{} Glop",
					"for each removed level",
				}
			},
			c_banana_glopway = {
				name = "Glopway",
				text = {
					"{C:glop}+0.01{} base Glop",
					"across all runs",
					"Create a {C:attention}Glopku",
					"{C:inactive}(Must have room)"
				}
			},
			c_banana_fruit = {
				name = "Fruit",
				text = {
					"Applies {C:attention}Banana{} to",
					"a random Joker, gain {C:money}$20",
					"Some Jokers {C:attention,E:1}evolve"
				}
			}
		},
		Tag = {
			tag_banana_glop = {
				name = "Glop Tag",
				text = {
					"{C:glop}+0.5{} Glop",
                    "Gives a copy of the",
                    "next selected {C:attention}Tag{}",
                    "{s:0.8,C:glop}Glop Tag{s:0.8} excluded",
				}
			}
		},
		Planet = {
			c_banana_glopur = {
				name = "Glopur",
				text = {
					"All poker hands",
					"gain {C:glop}+0.1{} Glop"
				}
			},
			c_banana_bouquetpl = {
				name = "Dvant",
				text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} Chips and",
					"{C:glop}+#5#{} Glop",
				}
			},
		},
		Other = {
			card_extra_glop = {
				text = {
					"{C:glop}+#1#{} Glop",
				}
			},
			banana = {
				name = "Banana",
				text = {
					"{C:green}#1# in #2#{} chance this",
					"card is destroyed",
					"at end of round",
				},
			},
			banana_playing_card = {
				name = "Banana",
				text = {
					"{C:green}#1# in #2#{} chance",
					"to destroy card",
				},
			}
		},
	},
	misc={
		challenge_names = {
			c_medusa_1 = "Bananadusa",
			c_monolith_1 = "Bananolith",
		},
		dictionary = {
			k_plus_stone = "+1 Banana",
			k_balanced = "Bananalanced",
			k_split_ex = "Split!",
			ph_you_win = "BANANA!",
			ph_score_best_glop = "Best Glop",
			cry_hand_bulwark = "Bananawark",
			banana_bouquet = "Virgin Bouquet",
		},
		labels = {
			banana_glop = "Glop",
			banana = "Banana",
		},
		poker_hands = {
			["cry_Bulwark"] = "Bananawark",
			["banana_bouquet"] = "Virgin Bouquet",
		},
		poker_hand_descriptions = {
			["banana_bouquet"] = {
				"A hand that contains a",
				"Queen, Jack, 10, and 2"
			}
		},
		banana_quips = {
			"Banana!",
			"Bananas!",
			"Cavenradical",
			"Totally Banonkers",
			"Plantainomenal",
			"Gross Michael",
			"Splantaindid",
			"Bananageddon",
			"Ripe On",
			"Epicavendish",
			"Bananamazing",
			"Bananatastic",
			"Banana Split",
			"Nutritious",
			"Fruitilicious",
			"Bananananananananananana",
			"Potassium",
			"* Kris Get the Banana",
			"Banana Bread",
			"Musaceae",
			"Musa acuminata",
		},
		glop_quips = {
			"Glop!",
			"Gloptastic",
			"Gloptacular",
			"Unglopipable",
			"Glopillion",
			"Glopular",
			"Extraglopinary",
			"Glopulous",
			"Glopnificent",
			"Glopendous",
			"Glopinity",
			"Glopjob",
			"Glipglop",
			"Glopageddon",
			"Glopacolypse",
			"Glop Almighty",
			"Glopimatical",
			"Totally Glopular Dude",
			"Glopsome",
		},
		splash = {
			"Glop!",
			"Banana!",
			"Fruit!",
			"Balatro!",
			"Jimbo!",
			"April Fools!",
			"As seen on TV!",
			"Exclusive!",
			"Extra, extra!",
			"Created by LocalThunk!",
			"Modded by MathIsFun!",
			"I love bananas!",
			"Banana split!",
			"Bananananananananana!",
			"The banana is a lie!",
			"Give me a B!",
			"Ceci n'est pas une banane!",
			"sudo make me a banana!",
			"100% glop!",
			"Glop is tomorrow!",
			"LocalThunk is Glop!",
			"Gloppin' that!",
			"Glop green!",
			"Get glopped!",
			"Buckets of glop!",
			"All is full of glop!",
			"Material glop!",
			"Good glop, babe!",
			"That's that me gloppresso!",
			"Glop me maybe!",
			"Frankly darling, I don't give a glop.",
			"1 in 6 chance!",
			"1 in 1000 chance!",
			"+15 Mult!",
			"X3 Mult!",
			"Naneinf!",
			"Personalized copy!",
			"{C:blue}House{} of Bananas!",
			"This is splash text!",
			"Every played text counts in scoring!",
			"Hello :3",
			"rawr XD",
			"owo whats this",
			"Convert the left card into the right card!",
			"Librarians love wild cards!",
			"Get it twisted!",
			"Suspiciously many 6s!",
			"Bummer :(",
			"Never punished!",
			"Stinky!",
			"Wee!",
			"Freaky!",
			"AAAAAAAAAAAAA",
			"Meow!",
			"Purr!",
			"Nya!",
			"Singleplayer!",
			"The Plant is coming!",
			"Photochad!",
			"Bluestorm!",
			"Yaoi!",
			"Yuri!",
			"Love wins!",
			"Trans rights!",
			"m!",
			"No 7 synergies!"
		},
	}
}