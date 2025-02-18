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

SMODS.Joker:take_ownership('j_matador', {
    name = "Banatador",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra}
        }
    end,
    calculate = function(self, card, context)
        -- add context.joker_main if this is too OP
        if G.GAME.blind and G.GAME.blind.boss and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra
            }
        end
    end
})

SMODS.Enhancement:take_ownership('m_stone', {
    loc_txt = {
        name = "Gros Michel",
        text = {
            "{C:mult}+15{} Mult",
            "{C:green}1 in 6{} chance this",
            "card is destroyed",
            "at end of round",
        }
    },
    config = {
        extra = {
            mult = 15,
            chance = 6,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            card.ability.extra.mult or self.config.extra.mult,
            G.GAME and G.GAME.probabilities.normal or 1,
            card.ability.extra.chance or self.config.extra.chance,
        }
    end,
    calculate = function(self, card, context)
		if context.cardarea == G.play and context.main_scoring then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.cardarea == G.hand and context.playing_card_end_of_round then
            if pseudorandom('stone_gros_michel') < G.GAME.probabilities.normal/card.ability.extra.chance then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.hand:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                }))
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
})

SMODS.Stake:take_ownership('stake_blue', {
    modifiers = function()
        G.GAME.starting_params.discards = 0
        G.GAME.modifiers.no_discards = true
    end,
    loc_txt = {
        name="Blue Stake",
        text={
            "{C:red}Removes{} Discards",
        },
    }
})

--Misc stuff
local cuib = create_UIBox_buttons
function create_UIBox_buttons()
    local t = cuib()
    if G.GAME.modifiers.no_discards then
        table.remove(t.nodes, G.SETTINGS.play_button_pos == 1 and 1 or 3)
    end
    return t
end