G.C.BANAN1 = HEX('f5d953')
G.C.BANAN2 = HEX('9be344')

G.C.MULT = darken(G.C.BANAN1, 0.1)
G.C.CHIPS = darken(G.C.BANAN2, 0.2)
G.C.RED = darken(G.C.BANAN1, 0.1)
G.C.BLUE = darken(G.C.BANAN2, 0.2)
G.C.BLIND.Small = darken(G.C.BANAN1, 0.1)
G.C.BLIND.won = darken(G.C.BANAN2, 0.2)

G.trollRate = 100

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

function get_blind_main_colour(blind) --either in the form of the blind key for the P_BLINDS table or type
    local disabled = false
    blind = blind or ''
    if blind == 'Boss' or blind == 'Small' or blind == 'Big' then
      G.GAME.round_resets.blind_states = G.GAME.round_resets.blind_states or {}
      if G.GAME.round_resets.blind_states[blind] == 'Defeated' or G.GAME.round_resets.blind_states[blind] == 'Skipped' then disabled = true end
      blind = G.GAME.round_resets.blind_choices[blind]
    end
    return (disabled or not G.P_BLINDS[blind]) and G.C.BLACK or
    G.P_BLINDS[blind].boss_colour or
    (blind == 'bl_small' and mix_colours(HEX("009dff"), G.C.BLACK, 0.6) or
    blind == 'bl_big' and mix_colours(G.C.ORANGE, G.C.BLACK, 0.6)) or G.C.BLACK
  end

--Trolling
function trolled()
    math.randomseed(os.time())
    return math.random() < 1/G.trollRate
end
local dcfh = G.FUNCS.discard_cards_from_highlighted
local pcfh = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.discard_cards_from_highlighted(e, hook)
    if G.GAME.current_round.hands_left > 0 and not hook and trolled() then
        G.FUNCS.change_play_discard_position({to_key = G.SETTINGS.play_button_pos % 2 + 1})
        return pcfh(e)
    end
    return dcfh(e, hook)
end
function G.FUNCS.play_cards_from_highlighted(e)
    if G.GAME.current_round.discards_left > 0 and trolled() then
        G.FUNCS.change_play_discard_position({to_key = G.SETTINGS.play_button_pos % 2 + 1})
        return dcfh(e)
    end
    return pcfh(e)
end
local bfs = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e)
    local card = e.config.ref_table
    if card and card:is(Card) and not (((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0) and trolled() then
        return G.FUNCS.reroll_shop()
    end
    return bfs(e)
end
local uc = G.FUNCS.use_card
function G.FUNCS.use_card(e, mute, nosave)
    local card = e.config.ref_table
    if (card.ability.set == "Booster" or card.ability.set == "Voucher") and G.shop and trolled() then
        return G.FUNCS.toggle_shop()
    end
    return uc(e, mute, nosave)
end
local slb = G.FUNCS.select_blind
local skb = G.FUNCS.skip_blind
function G.FUNCS.select_blind(e)
    if G.GAME.blind_on_deck ~= "Boss" and trolled() then
        return skb(G.blind_select_opts[string.lower(G.GAME.blind_on_deck)]:get_UIE_by_ID('tag_'..G.GAME.blind_on_deck).children[2])
    end
    return slb(e)
end
function G.FUNCS.skip_blind(e)
    if trolled() then
        return slb(G.blind_select_opts[string.lower(G.GAME.blind_on_deck)]:get_UIE_by_ID('select_blind_button'))
    end
    return skb(e)
end