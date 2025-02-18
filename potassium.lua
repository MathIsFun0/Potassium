G.C.BANAN1 = HEX('f5d953')
G.C.BANAN2 = HEX('9be344')

SMODS.config.no_mod_badges = true

SMODS.Atlas{
    key = "centers",
    path = "Enhancers.png",
    px = 71,
    py = 95,
    raw_key = true
}

-- Add updates to existing Jokers
SMODS.Joker:take_ownership('j_oops', {
    name = "Oops! All Bananas",
    loc_txt = {
        name = "Oops! All Bananas",
        text = {
            "Guarantees all {C:attention}listed",
            "{C:green,E:1,S:1.1}probabilities",
            "{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}inf in 3{C:inactive})",
        }
    },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = 1e400
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not next(SMODS.find_card('j_oops')) then
            G.GAME.probabilities.normal = 1
        end
    end
})