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

SMODS.current_mod.optional_features = {
    post_trigger = true
}

if not to_big then
    function to_big(x) return x end
end
if not is_number then
    function is_number(x) return type(x) == 'number' end
end

-- ===Texture replacement and new Atlases===
SMODS.Atlas{
    key = "centers",
    path = "Enhancers.png",
    px = 71,
    py = 95,
    raw_key = true
}
SMODS.Atlas{
    key = "Joker",
    path = "Jokers.png",
    px = 71,
    py = 95,
    raw_key = true
}
SMODS.Atlas{
    key = "banana",
    path = "Bananokers.png",
    px = 71,
    py = 95,
}
SMODS.Atlas{
    key = "hologram",
    path = "Hologram.png",
    px = 95,
    py = 95,
}
SMODS.Atlas{
    key = "sticker",
    path = "sticker.png",
    px = 71,
    py = 95,
}
SMODS.Atlas{
    key = "balatro",
    path = "title.png",
    px = 333,
    py = 216,
    raw_key = true
}
SMODS.Atlas{
    key = "blinds",
	atlas_table = "ANIMATION_ATLAS",
	path = "blinds.png",
	px = 34,
	py = 34,
	frames = 21,
}

-- ==New Sounds==
SMODS.Sound({
    key = "glopedition",
    path = "GlopEdition.wav"
})
SMODS.Sound({
    key = "glop",
    path = "Glop.wav"
})

-- ===Add updates to existing Jokers===
SMODS.Joker:take_ownership('j_oops', {
    name = "Oops! All Bananas",
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = 10^309
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
        if G.GAME.blind and G.GAME.blind.boss and context.cardarea == G.jokers and not context.destroy_card and not context.destroying_card then
            return {
                dollars = card.ability.extra
            }
        end
    end
})

SMODS.Enhancement:take_ownership('m_stone', {
    --[[loc_txt = {
        name = "Gros Michel",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:green}#2# in #3#{} to",
            "destroy card"
        }
    },]]
    config = {
        extra = {
            mult = 15,
            chance = 6,
        }
    },
    replace_base_card = true,
    no_edeck = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.mult or self.config.extra.mult,
            G.GAME and G.GAME.probabilities.normal or 1,
            card.ability.extra.chance or self.config.extra.chance,
        }}
    end,
    calculate = function(self, card, context)
		if context.cardarea == G.play and context.main_scoring then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.cardarea == G.play and context.destroying_card and context.destroy_card == card then
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
                                    G.play:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                }))
                return {
                    message = localize('k_extinct_ex'),
                    remove = true
                }
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_safe_ex')})
            end
        end
    end
})

SMODS.Joker:take_ownership('j_marble', {
    --[[loc_txt = {
        name = "Banana Farm",
        text = {
            "Adds one {C:attention}Gros Michel{}",
            "to deck when",
            "{C:attention}Blind{} is selected",
        }
    },]]
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    end,
})

SMODS.Joker:take_ownership('j_stone', {
    --[[loc_txt = {
        name = "Banana-Flavored Banana",
        text = {
            "Gives {C:chips}+#1#{} Chips for",
            "each {C:attention}Gros Michel",
            "in your {C:attention}full deck",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
        }
    },]]
    --[[loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    end,--]]
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

SMODS.Joker:take_ownership('j_hologram', {
    display_size = { w = 95, h = 95 },
    atlas = "hologram",
    pos = { x = 0, y = 10 },
    soul_pos = { x = 0, y = 0 },
})
-- animate hologram sprite
-- code adapted from Cryptid's jimball
banana_hologram_dt = 0
local _game_update = Game.update
function Game:update(dt)
    _game_update(self, dt)
    banana_hologram_dt = banana_hologram_dt + dt -- cryptid has a check here but im not sure what it's for
	if G.P_CENTERS and G.P_CENTERS.j_hologram and banana_hologram_dt > 0.05 then
		banana_hologram_dt = banana_hologram_dt - 0.05
		local hologramobj = G.P_CENTERS.j_hologram
		if hologramobj.soul_pos.x == 11 and hologramobj.soul_pos.y == 9 then
			hologramobj.soul_pos.x = 0
			hologramobj.soul_pos.y = 0
		elseif hologramobj.soul_pos.x < 11 then
			hologramobj.soul_pos.x = hologramobj.soul_pos.x + 1
		elseif hologramobj.soul_pos.y < 9 then
			hologramobj.soul_pos.x = 0
			hologramobj.soul_pos.y = hologramobj.soul_pos.y + 1
		end
        -- oh my god i hate this so much but ARGH
        -- note that this can't use find_card because it also needs to work in the collection
        -- unless there's some other way you can do it
        for _, card in pairs(G.I.CARD) do
            if card and card.config.center == hologramobj then
                card.children.floating_sprite:set_sprite_pos(hologramobj.soul_pos)
            end
        end
	end
    if not G.GAME.probabilities.normal and SMODS.find_card("j_oops") then
        G.GAME.probabilities.normal = 10^1000
    end
end

-- ===Banana Content===
SMODS.Back{
    key = "banana",
    prefix_config = {
        atlas = false
    },
    atlas = 'Joker',
    pos = {x = 7, y = 6},
    apply = function(self, back)
        G.GAME.starting_params.banana = true
    end
}

if not (SMODS.Mods["Cryptid"] or {}).can_load then
    function Card:calculate_banana()
        if not self.ability.extinct then
            if self.ability.banana and (pseudorandom("banana") < G.GAME.probabilities.normal / 10) then
                self.ability.extinct = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        self.T.r = -0.2
                        self:juice_up(0.3, 0.4)
                        self.states.drag.is = true
                        self.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                if self.area then
                                    self.area:remove_card(self)
                                end
                                self:remove()
                                self = nil
                                return true
                            end,
                        }))
                        return true
                    end,
                }))
                if self.ability.name == "Gros Michel" then
                    G.GAME.pool_flags.gros_michel_extinct = true
                end
                if self.ability.name == "Cavendish" then
                    G.GAME.pool_flags.cavendish_extinct = true
                end
                return {
                    message = localize("k_extinct_ex")
                }
            elseif self.ability.banana then
                return {
                    message = localize("k_safe_ex")
                }
            end
        end
    end
    function Card:set_banana(_banana)
        self.ability.banana = _banana
    end
    local se = Card.set_eternal
    function Card:set_eternal(_eternal)
        if not self.ability.banana then
            se(self, _eternal)
        end
    end
    SMODS.Sticker({
        badge_colour = HEX("e8c500"),
        prefix_config = { key = false },
        key = "banana",
        atlas = "sticker",
        pos = { x = 0, y = 0 },
        needs_enable_flag = true,
        --Either SMODS doesn't do this or I am silly
        should_apply = function(self, card, center, area, bypass_roll)
            return (area == G.pack_cards or area == G.shop_jokers) and card.ability.set == "Joker" and pseudorandom(pseudoseed("stickernana"..G.GAME.round_resets.ante)) < 0.3 and G.GAME.modifiers.enable_banana
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { G.GAME.probabilities.normal or 1, 10 } }
        end,
        calculate = function(self, card, context)
            if
                context.end_of_round
                and not context.repetition
                and not context.playing_card_end_of_round
                and not context.individual
            then
                if card.ability.set == "Joker" then
                    return card:calculate_banana()
                end
            end
        end,
    })
    SMODS.Stake({
        key = "banana",
        pos = { x = 3, y = 1 },
        sticker_atlas = "sticker",
        sticker_pos = {x = 0, y = 0},
        applied_stakes = { "stake_gold" },
        prefix_config = false,
        modifiers = function()
            G.GAME.modifiers.enable_banana = true
        end,
        colour = HEX("e8c500"),
    })
end

BANANA_EVOLUTIONS = {}
SMODS.Consumable{
    key = "fruit",
    pos = {x = 0, y = 0},
    set = "Spectral",
    can_use = function(self, card)
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].ability.banana and not G.jokers.cards[i].ability.eternal then
                return true
            end
        end        
    end,
    use = function(self, card, area)
        local eligible_jokers = {}
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].ability.banana and not G.jokers.cards[i].ability.eternal then
                eligible_jokers[#eligible_jokers+1] = G.jokers.cards[i]
            end
        end
        local joker = pseudorandom_element(eligible_jokers, pseudoseed("fruit"..G.GAME.round_resets.ante))
        if joker then
            if BANANA_EVOLUTIONS[joker.config.center.key] then
                joker:set_ability(G.P_CENTERS[BANANA_EVOLUTIONS[joker.config.center.key]])
                play_sound("banana_glopedition", 1, 1)
            else
                joker:set_banana(true)
            end
            joker:juice_up(0.3, 0.4)
            ease_dollars(20)
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = "Other", key = "banana", vars = {G.GAME.probabilities.normal or 1,10}}
    end,
}


SMODS.Joker{
	key = "plantation",
	pos = { x = 0, y = 0 },
	config = { extra = { xmult = 2 } },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = {set = "Other", key = "banana", vars = {G.GAME.probabilities.normal or 1,10}}
		return { vars = { center.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.other_joker and context.other_joker.ability.banana then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					if i > 1 then
						G.jokers.cards[i - 1]:set_banana(true)
                        G.jokers.cards[i - 1]:juice_up(0.3, 0.4)
					end
					if i < #G.jokers.cards then
						G.jokers.cards[i + 1]:set_banana(true)
                        G.jokers.cards[i + 1]:juice_up(0.3, 0.4)
					end
				end
			end
        end
	end,
}

-- Make Cavendish banned as well
SMODS.Joker:take_ownership('j_cavendish', {
    no_pool_flag = 'cavendish_extinct',
    calculate = function(self, card, context)
		if context.joker_main then
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult,
            }
		end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            if pseudorandom('cavendish') < G.GAME.probabilities.normal/card.ability.extra.odds then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                G.GAME.pool_flags.cavendish_extinct = true
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

SMODS.Joker{
	key = "bluejava",
    yes_pool_flag = 'cavendish_extinct',
	pos = { x = 0, y = 0 },
	rarity = 1,
	cost = 4,
    config = { extra = { emult = 2, odds = 2^1023.99 } },
	blueprint_compat = true,
	loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.emult, G.GAME.probabilities.normal, center.ability.extra.odds } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {
                emult = card.ability.extra.emult
            }
		end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            if pseudorandom('bluejava') < G.GAME.probabilities.normal/card.ability.extra.odds then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
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
    end,
}

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

-- ===Trolling===
function trolled()
    if not G.trollRate then return false end
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
    if card and card:is(Card) and not ((to_big(G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < to_big(0)) and G.GAME.current_round.reroll_cost ~= 0) and trolled() then
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

-- Change win ante
local gigo = Game.init_game_object
function Game:init_game_object()
    local ret = gigo(self)
    ret.win_ante = ret.win_ante + 2
    ret.round_scores.best_glop = {label = "Best Glop", amt = 0}
    if not G.PROFILES[G.SETTINGS.profile].glop then
        G.PROFILES[G.SETTINGS.profile].glop = 1
    end
    for k, v in pairs(ret.hands) do
        v.glop = to_big(G.PROFILES[G.SETTINGS.profile].glop)
        v.s_glop = to_big(G.PROFILES[G.SETTINGS.profile].glop)
        v.l_glop = v.l_mult * 0.01
    end
    return ret
end

local cashs = check_and_set_high_score
function check_and_set_high_score(score, amt)
    if score ~= "best_glop" then return cashs(score, amt) end
    if not amt or not is_number(amt) then return end
    if G.GAME.round_scores[score] and to_big(amt) > to_big(G.GAME.round_scores[score].amt or 0) then
        G.GAME.round_scores[score].amt = amt
    end
end

local cuichr = create_UIBox_current_hand_row
function create_UIBox_current_hand_row(handname, simple)
    local ret = cuichr(handname, simple)
    if ret and not simple then
        ret.nodes[2] = {n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.C.BLACK,r = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.CHIPS, minw = 1.1}, nodes={
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
              {n=G.UIT.T, config={text = number_format(G.GAME.hands[handname].chips, 1000000), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
            }},
            {n=G.UIT.T, config={text = "X", scale = 0.45, colour = G.C.MULT}},
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.MULT, minw = 1.1}, nodes={
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
              {n=G.UIT.T, config={text = number_format(G.GAME.hands[handname].mult, 1000000), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
            }},
            {n=G.UIT.T, config={text = "X", scale = 0.45, colour = G.C.MULT}},
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.GLOP, minw = 1.1}, nodes={
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
              {n=G.UIT.T, config={text = number_format(G.GAME.hands[handname].glop, 1000000), scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
              {n=G.UIT.B, config={w = 0.04,h = 0.01}},
            }},
          }}
    end
    return ret
end

-- ===Final boss shenanigans===
local rb = reset_blinds
function reset_blinds()
    rb()
    if G.GAME.round_resets.ante == 10 then
        local Jimbo = nil
        G.GAME.round_resets.blind_states.Small = 'Hide'
        G.GAME.round_resets.blind_states.Big = 'Hide'
        G.GAME.round_resets.blind_states.Boss = 'Upcoming'
        G.GAME.blind_on_deck = 'Boss'
        G.GAME.round_resets.blind_choices.Boss = get_new_boss()
        G.GAME.round_resets.boss_rerolled = false
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.8,
            func = (function()
                if G.STATE == G.STATES.BLIND_SELECT and G.blind_select then 
                    Jimbo = Card_Character({x = 0, y = 10})
                    Jimbo:add_speech_bubble('dq_1', nil, {quip = true})
                    Jimbo:say_stuff(5)
                    Jimbo:set_alignment{
                        major = G.blind_select,
                        type = 'tli',
                        offset = {x=0.8,y=1}
                    }
                    G.E_MANAGER:add_event(Event({
                        blocking = false,blockable = false,
                        func = (function()
                            if G.STATE ~= G.STATES.BLIND_SELECT then 
                                if Jimbo then Jimbo:remove() end
                                return true
                            end end)}))
                    return true
                end
            end)
        }), 'other')
    end
end
local gnb = get_new_boss
function get_new_boss()
    if G.GAME.round_resets.ante == G.GAME.win_ante then
        return 'bl_banana_banana'..pseudorandom(pseudoseed("bananboss"),1,2)
    end
    G.GAME.win_ante = G.GAME.win_ante - 1
    local ret = gnb()
    G.GAME.win_ante = G.GAME.win_ante + 1
    return ret
end

local pcfh = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
	G.GAME.before_play_buffer = true
	G.GAME.blind:banana()
	pcfh(e)
	G.GAME.before_play_buffer = nil
end
function Blind:banana()
	if not self.disabled then
		local obj = self.config.blind
		if obj.banana and type(obj.banana) == "function" then
			return obj:banana()
		end
	end
end
SMODS.Blind{
    key = "banana1",
    pos = {x = 0, y = 0},
    atlas = "blinds",
    banana = function(self)
        if G.jokers.cards[1] then
			local idx = pseudorandom(pseudoseed("bananeinf"), 1, #G.jokers.cards)
			if G.jokers.cards[idx] then
				if G.jokers.cards[idx].config.center.immune_to_vermillion then --what? cryptid compat? no wayyyy
					card_eval_status_text(
						G.jokers.cards[idx],
						"extra",
						nil,
						nil,
						nil,
						{ message = localize("k_nope_ex"), colour = G.C.JOKER_GREY }
					)
				else
					_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_gros_michel")
					G.jokers.cards[idx]:remove_from_deck()
					_card:add_to_deck()
					_card:start_materialize()
					G.jokers.cards[idx] = _card
					_card:set_card_area(G.jokers)
					G.jokers:set_ranks()
					G.jokers:align_cards()
				end
			end
		end
    end,
    boss_colour = G.C.BANAN1,
    boss = {min = 9999, max = 10, showdown = true},
    in_pool = function() return false end,
    dollars = 15,
}

SMODS.Blind{
    key = "banana2",
    pos = {x = 0, y = 1},
    atlas = "blinds",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {G.GAME and G.GAME.probabilities.normal or 1}
        }
    end,
    boss_colour = G.C.BANAN1,
    boss = {min = 9999, max = 10, showdown = true},
    in_pool = function() return false end,
    dollars = 15,
    calculate = function(self, card, context)
        if
			context.post_trigger
			and context.other_card --animation-wise this looks weird sometimes
		then
            if
                not context.other_card.ability.eternal
                and (
                    pseudorandom(pseudoseed("go_extinct"))
                    < G.GAME.probabilities.normal / 6
                )
            then
                context.other_card.extinct = true
                -- this event call might need to be pushed later to make more sense
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        context.other_card.T.r = -0.2
                        context.other_card:juice_up(0.3, 0.4)
                        context.other_card.states.drag.is = true
                        context.other_card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    context.other_card:remove_from_deck()
                                    G.jokers:remove_card(context.other_card)
                                    context.other_card:remove()
                                    context.other_card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                if context.other_card.ability.name == 'Gros Michel' then 
                    G.GAME.pool_flags.gros_michel_extinct = true
                else
                    if not G.GAME.banned_keys then
                        G.GAME.banned_keys = {}
                    end
                    G.GAME.banned_keys[context.other_card.config.center.key] = true
                end
                return {
                    message = localize('k_extinct_ex'),
                    message_card = context.other_card
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    message_card = context.other_card
                }
            end
        end
    end
}

-- Don't trigger extinct cards
local ccj = Card.calculate_joker
function Card:calculate_joker(...)
    if self.extinct then return end
    return ccj(self, ...)
end

-- ==Glop Content==
-- Add Glop to UI
local cuih = create_UIBox_HUD
function create_UIBox_HUD()
    local ret = cuih()
    local hand_UI = ret.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes
    -- Cleanly remove existing DynaText (prevent memory leaks)
    hand_UI[1].nodes[1].config.object:remove()
    hand_UI[1].nodes[2].config.object:remove()
    hand_UI[3].nodes[1].config.object:remove()
    hand_UI[3].nodes[3].config.object:remove()
    hand_UI = {
        {n=G.UIT.C, config={align = "cm", minw = 1.3, minh =0.7, r = 0.1,colour = G.C.UI_CHIPS, id = 'hand_chip_area', emboss = 0.05}, nodes={
            {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_chips', object = Moveable(0,0,0,0), w = 0, h = 0}},
            {n=G.UIT.O, config={id = 'hand_chips', func = 'hand_chip_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "chip_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = 0.3*2.3})}},
        }},
        {n=G.UIT.C, config={align = "cm"}, nodes={
          {n=G.UIT.T, config={text = "X", lang = G.LANGUAGES['en-us'], scale = 0.6, colour = G.C.UI_MULT, shadow = true}},
        }},
        {n=G.UIT.C, config={align = "cm", minw = 1.3, minh=0.7, r = 0.1,colour = G.C.UI_MULT, id = 'hand_mult_area', emboss = 0.05}, nodes={
          {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_mult', object = Moveable(0,0,0,0), w = 0, h = 0}},
          {n=G.UIT.O, config={id = 'hand_mult', func = 'hand_mult_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "mult_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = 0.3*2.3})}},
        }},
        {n=G.UIT.C, config={align = "cm"}, nodes={
          {n=G.UIT.T, config={text = "X", lang = G.LANGUAGES['en-us'], scale = 0.6, colour = G.C.UI_MULT, shadow = true}},
        }},
        {n=G.UIT.C, config={align = "cm", minw = 1.3, minh=0.7, r = 0.1,colour = G.C.UI_GLOP, id = 'hand_glop_area', emboss = 0.05}, nodes={
          {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_glop', object = Moveable(0,0,0,0), w = 0, h = 0}},
          {n=G.UIT.O, config={id = 'hand_glop', func = 'hand_glop_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "glop_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = 0.3*2.3})}},
        }},
    }
    ret.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes = hand_UI
    return ret
end

G.C.GLOP = HEX('11ff11')
G.C.UI_GLOP = G.C.GLOP
G.FUNCS.hand_glop_UI_set = function(e)
    local new_glop_text = number_format(G.GAME.current_round.current_hand.glop)
    if new_glop_text ~= G.GAME.current_round.current_hand.glop_text then 
      G.GAME.current_round.current_hand.glop_text = new_glop_text
      e.config.object.scale = scale_number(G.GAME.current_round.current_hand.glop, 0.69, 1000)
      e.config.object:update_text()
      if not G.TAROT_INTERRUPT_PULSE then G.FUNCS.text_super_juice(e, math.max(0,math.floor(math.log10(type(G.GAME.current_round.current_hand.glop) == 'number' and G.GAME.current_round.current_hand.glop or 1)))) end
    end
  end

-- Passive glop functionality - scales with cards triggered
local ce = SMODS.calculate_effect
local c_keys_p = {'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod', 'glop'}
local c_keys_x = {'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod', 'xglop'}
local c_keys_e = {'e_mult', 'e_chips', 'emult', 'echips','Emult_mod', 'Echip_mod', 'eglop'}
local c_keys_ee = {'ee_mult', 'ee_chips', 'eemult', 'eechips','EEmult_mod', 'EEchip_mod',
                    'eee_mult', 'eee_chips', 'eeemult', 'eeechips','EEEmult_mod', 'EEEchip_mod',
                    'hyper_mult', 'hyper_chips', 'hypermult', 'hyperchips','hypermult_mod', 'hyperchip_mod'}
local c_keys = {'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod',
    'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
    'e_mult', 'e_chips', 'ee_mult', 'ee_chips', 'eee_mult', 'eee_chips', 'hyper_mult', 'hyper_chips',
    'emult', 'echips', 'eemult', 'eechips', 'eeemult', 'eeechips', 'hypermult', 'hyperchips',
    'Emult_mod', 'Echip_mod', 'EEmult_mod', 'EEchip_mod', 'EEEmult_mod', 'EEEchip_mod', 'hypermult_mod', 'hyperchip_mod',
    'glop', 'xglop', 'eglop'}
function SMODS.calculate_effect(effect, ...)
    local ret = ce(effect, ...)
    for _, key in ipairs(c_keys) do --scoring effects
        if effect[key] and glop then
            glop = glop + 0.01
        end
    end
    return ret
end

for _, v in ipairs({'glop', 'xglop', 'eglop'}) do
    table.insert(SMODS.calculation_keys, v)
end

if not (SMODS.Mods["Talisman"] or {}).can_load then
    table.insert(SMODS.calculation_keys, 'emult')
end

local cie = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    local ret = cie(effect, scored_card, key, amount, from_edition)
    if ret then return ret end

    if key == 'glop' and amount ~= 0 then 
        if effect.card then juice_card(effect.card) end
        glop = glop + amount
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, glop = glop})
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "+"..number_format(amount).." Glop", colour =  G.C.GLOP, sound = "banana_glop"})
        end
        return true
    end

    if key == 'xglop' and amount ~= 1 then 
        if effect.card then juice_card(effect.card) end
        glop = glop * amount
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, glop = glop})
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "X"..number_format(amount).." Glop", colour =  G.C.GLOP, sound = "banana_glop"})
        end
        return true
    end
    
    if key == 'eglop' and amount ~= 1 then 
        if effect.card then juice_card(effect.card) end
        glop = glop ^ amount
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, glop = glop})
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..number_format(amount).." Glop", colour =  G.C.GLOP, sound = "banana_glopedition"})
        end
        return true
    end

    if not (SMODS.Mods["Talisman"] or {}).can_load then
        if key == 'emult' and amount ~= 1 then 
            if effect.card then juice_card(effect.card) end
            mult = mod_mult(mult ^ amount)
            update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, glop = glop})
            if not effect.remove_default_message then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..number_format(amount).." Mult", colour =  G.C.MULT, sound = "multhit2"})
            end
            return true
        end
    end
end

local lc = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc()
	end
	G.ARGS.LOC_COLOURS.glop = G.C.GLOP
    G.ARGS.LOC_COLOURS.sfark = HEX("ff00ff")
	return lc(_c, _default)
end

-- Glop Planet Levels
local generic_planet_loc = {
    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
    "{C:attention}#2#",
    "{C:mult}+#3#{} Mult and",
    "{C:chips}+#4#{} chips",
}
local generic_planet_loc_cryptid = {
    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
    "{C:attention}#2#",
    "{C:mult}+#3#{} Mult and",
    "{C:chips}+#4#{} chip#<s>4#",
}
local glop_planet_loc = {
    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
    "{C:attention}#2#",
    "{C:mult}+#3#{} Mult and",
    "{C:chips}+#4#{} Chips and",
    "{C:glop}+#5#{} Glop",
}
local planet_taken_ownership = {}
local function parse_loc_txt(center)
	center.text_parsed = {}
	if center.text then
		for _, line in ipairs(center.text) do
			center.text_parsed[#center.text_parsed + 1] = loc_parse_string(line)
		end
		center.name_parsed = {}
		for _, line in ipairs(type(center.name) == "table" and center.name or { center.name }) do
			center.name_parsed[#center.name_parsed + 1] = loc_parse_string(line)
		end
		if center.unlock then
			center.unlock_parsed = {}
			for _, line in ipairs(center.unlock) do
				center.unlock_parsed[#center.unlock_parsed + 1] = loc_parse_string(line)
			end
		end
	end
end
local il = init_localization
function init_localization()
    il()
    for k, v in pairs(G.localization.descriptions.Planet) do
        if #v.text == 4 then
            local gloppable = true
            for i = 1, 4 do
                if v.text[i] ~= generic_planet_loc[i] and v.text[i] ~= generic_planet_loc_cryptid[i] then
                    gloppable = false
                    break
                end
            end
            if gloppable then
                v.text = glop_planet_loc
                parse_loc_txt(v)
                if not planet_taken_ownership[k] then
                    planet_taken_ownership[k] = true
                    if G.P_CENTERS[k].loc_vars then
                        local lv = G.P_CENTERS[k].loc_vars
                        G.P_CENTERS[k].loc_vars = function(self, info_queue, card)
                            local ret = lv(self, info_queue, card)
                            ret.vars[5] = G.GAME.hands[self.config.hand_type].l_glop
                            return ret
                        end
                    end
                end
            end
        end
    end
end

local oldfunc = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
    full_UI_table = oldfunc(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end,card)
    if card and card.ability and card.ability.perma_glop then
        local desc_nodes = full_UI_table.main
        if card.ability.perma_glop ~= 0 then
            localize{type = 'other', key = 'card_extra_glop', nodes = desc_nodes, vars = {card.ability.perma_glop}}
        end
    end
    return full_UI_table
end

-- Glop Content
SMODS.Joker{
	key = "glopbucket",
	pos = { x = 1, y = 5 },
    atlas = "banana",
	config = { extra = { extra = 0.01, glop = 0 } },
	rarity = 2,
	cost = 7,
	perishable_compat = false,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.extra, center.ability.extra.glop } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.glop > 0 then
			return {
				glop = card.ability.extra.glop,
			}
		end
		if context.cardarea == G.play and context.individual and not context.blueprint then
			card.ability.extra.glop = card.ability.extra.glop + card.ability.extra.extra
			return {
				extra = { focus = card, message = localize("k_upgrade_ex") },
				card = card,
				colour = G.C.GLOP,
			}
		end
	end,
}

SMODS.Joker{
	key = "glopcorn",
    atlas = "banana",
	pos = { x = 1, y = 3 },
	config = { extra = { extra = 0.1, glop = 0.7 } },
	rarity = 1,
	cost = 4,
	perishable_compat = false,
	blueprint_compat = true,
    in_pool = function() return false end,
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.extra, center.ability.extra.glop } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.glop > 0 then
			return {
				glop = card.ability.exftra.glop,
			}
		end
		if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if card.ability.extra.glop - card.ability.extra.extra <= 10^-6 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.glop = card.ability.extra.glop - card.ability.extra.extra
                return {
                    message = "-"..number_format(card.ability.extra.extra).." Glop",
                    colour = G.C.GLOP
                }
            end
		end
	end,
}
SMODS.Joker{
	key = "glopmichel",
	pos = { x = 0, y = 2 },
    atlas = "banana",
	config = { extra = { extra = 6, glop = 0.1 } },
	rarity = 1,
	cost = 4,
	perishable_compat = false,
	blueprint_compat = true,
    in_pool = function() return false end,
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.extra, G.GAME.probabilities.normal, center.ability.extra.glop, center.ability.extra.glop * center.ability.extra.extra } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.glop > 0 then
            if pseudorandom(pseudoseed("glop_michel")) < G.GAME.probabilities.normal/card.ability.extra.extra then
                return {
                    glop = card.ability.extra.glop * card.ability.extra.extra,
                }
            else
                return {
                    glop = card.ability.extra.glop,
                }
            end
		end
	end,
}

SMODS.Joker{
	key = "glopcola",
	pos = { x = 1, y = 4 },
    atlas = "banana",
	rarity = 2,
	cost = 6,
	perishable_compat = false,
	blueprint_compat = true,
    in_pool = function() return false end,
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue+1] = G.P_TAGS.tag_banana_glop
        return {vars = {localize({type = "name_text", set = "Tag", key = "tag_banana_glop"})}}
	end,
	calculate = function(self, card, context)
		if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_banana_glop'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
		end
	end,
}

SMODS.Tag{
    key = "glop",
    in_pool = function() return false end,
    apply = function(self, tag, context)
        if context.type == "tag_add" and context.tag.key ~= "tag_banana_glop" then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.BLUE,function()
                if context.tag.ability and context.tag.ability.orbital_hand then
                    G.orbital_hand = context.tag.ability.orbital_hand
                end
                add_tag(Tag(context.tag.key))
                G.orbital_hand = nil
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
        end
        if context.type == "scoring" then
            glop = glop + 0.5
            update_hand_text({delay = 0}, {glop = glop})
            tag.HUD_tag.jimbo = true
            card_eval_status_text(tag.HUD_tag, 'jokers', nil, percent, nil, {message = "+0.5 Glop", colour =  G.C.GLOP})
            tag.HUD_tag.jimbo = nil
        end
    end
}
SMODS.Joker{
	key = "glopendish",
	pos = { x = 1, y = 2 },
    atlas = "banana",
	rarity = 1,
	cost = 4,
    config = {extra = {glop = 1.5, odds1 = 1000, odds2 = 2}},
	perishable_compat = false,
	blueprint_compat = true,
    in_pool = function() return false end,
	loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.glop, G.GAME.probabilities.normal, center.ability.extra.odds1, center.ability.extra.odds2}}
	end,
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.glop > 0 then
			return {
				glop = card.ability.extra.glop,
			}
		end
        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
			if pseudorandom(pseudoseed('glopendish_extinct')) < G.GAME.probabilities.normal/card.ability.extra.odds1 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                    G.jokers:remove_card(card)
                                    card:remove()
                                    card = nil
                                return true; end})) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_extinct_ex'),
                    colour = G.C.GLOP
                }
            else
                return {
                    message = localize('k_safe_ex'),
                    colour = G.C.GLOP
                }
            end
		end
        if context.setting_blind and not card.getting_sliced and not context.blueprint and pseudorandom(pseudoseed("glopendish_destroy")) < G.GAME.probabilities.normal/card.ability.extra.odds2 then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.glop = card.ability.extra.glop + sliced_card.sell_cost*0.1
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = number_format(card.ability.extra.glop+0.1*sliced_card.sell_cost).." Glop", colour = G.C.GLOP, no_juice = true})
            end
        end
	end,
}
SMODS.Joker{
	key = "glopmother",
	pos = { x = 0, y = 1 },
    soul_pos = {x = 1, y = 1},
    atlas = "banana",
	rarity = 4,
	cost = 20,
	perishable_compat = false,
	blueprint_compat = true,
    in_pool = function() return false end,
    config = {extra = {fake_out = true}},
    loc_vars = function(self, info_queue, center)
        if center.ability.extra.fake_out then
            return {key = "j_banana_glopmother_fake_out"}
        end
    end,
	calculate = function(self, card, context)
		if context.joker_main then
            card.ability.extra.fake_out = false
            return {
                eglop = 2,
            }
		end
	end,
}
SMODS.Joker{
	key = "glopku",
	pos = { x = 0, y = 0 },
    soul_pos = {x = 1, y = 0 },
	rarity = 4,
	cost = 20,
	perishable_compat = false,
	blueprint_compat = true,
    in_pool = function() return false end,
    config = {extra = {glop = 0.1}},
    atlas = "banana",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.glop}}
    end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_glop = context.other_card.ability.perma_glop or 0
            context.other_card.ability.perma_glop = context.other_card.ability.perma_glop + card.ability.extra.glop
            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.GLOP,
            }
        end
	end,
}

SMODS.Shader{
    key = "glop",
    path = "glop.fs"
}

SMODS.Edition{
    key = "glop",
    shader = "glop",
    pos = {x = 7, y = 6},
    sound = { sound = "banana_glopedition", per = 1, vol = 1},
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card == card and context.other_ret then
            local _glop = 0
            local _xglop = 1
            local _eglop = 1
            for m, _ in pairs(context.other_ret) do
                for _, k in ipairs(c_keys_p) do
                    if context.other_ret[m][k] then
                        _glop = _glop + context.other_ret[m][k]/10^(math.floor(math.log(tonumber(context.other_ret[m][k]), 10))+1)
                    end
                end
                for _, k in ipairs(c_keys_x) do
                    if context.other_ret[m][k] then
                        _glop = _glop + context.other_ret[m][k]
                    end
                end
                for _, k in ipairs(c_keys_e) do
                    if context.other_ret[m][k] then
                        _xglop = _xglop * context.other_ret[m][k]
                    end
                end
                for _, k in ipairs(c_keys_ee) do
                    if context.other_ret[m][k] then
                        _eglop = _eglop * context.other_ret[m][k]
                    end
                end
            end
            return {
                glop = _glop,
                xglop = _xglop,
                eglop = _eglop,
            }
        end
    end
}

GLOP_EVOLUTIONS = {
    j_popcorn = "j_banana_glopcorn",
    j_gros_michel = "j_banana_glopmichel",
    j_diet_cola = "j_banana_glopcola",
    j_cavendish = "j_banana_glopendish",
}
SMODS.Consumable{
    key = "substance",
    atlas = "banana",
    pos = {x = 0, y = 4},
    set = "Spectral",
    can_use = function(self, card)
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].edition then
                return true
            end
        end        
    end,
    use = function(self, card, area)
        local eligible_jokers = {}
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].edition then
                eligible_jokers[#eligible_jokers+1] = G.jokers.cards[i]
            end
        end
        local joker = pseudorandom_element(eligible_jokers, pseudoseed("substance"..G.GAME.round_resets.ante))
        if joker then
            if GLOP_EVOLUTIONS[joker.config.center.key] then
                joker:set_ability(G.P_CENTERS[GLOP_EVOLUTIONS[joker.config.center.key]])
                play_sound("banana_glopedition", 1, 1)
            elseif joker.config.center.rarity == 4 and joker.config.center.key ~= "j_banana_glopmother" and joker.config.center.key ~= "j_banana_glopku" then
                joker:set_ability(G.P_CENTERS["j_banana_glopmother"])
                play_sound("banana_glopedition", 1, 1)
            else
                joker:set_edition("e_banana_glop")
            end
            joker:juice_up(0.3, 0.4)
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_banana_glop
    end,
}

SMODS.Consumable{
    key = "glopur",
    atlas = "banana",
    pos = {x = 0, y = 3},
    set = "Planet",
    can_use = function(self, card)
        return true      
    end,
    use = function(self, card, area)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', glop = '...', level=''})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {glop = '+0.1', StatusText = true})
        delay(1.3)
        for k, v in pairs(G.GAME.hands) do
            v.glop = v.glop + 0.1
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, glop = 0, handname = '', level = ''})
    end,
}

SMODS.Consumable{
    key = "glopularity",
    atlas = "banana",
    pos = {x = 0, y = 5},
    set = "Spectral",
    soul_set = "Planet",
    hidden = true,
    can_use = function(self, card)
        return true      
    end,
    use = function(self, card, area)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', glop = '...', level=''})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {chips = '-', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {mult = '-', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {glop = '+', StatusText = true})
        delay(1.3)
        local glop = 0
        for k, v in pairs(G.GAME.hands) do
            local level = v.level
            glop = glop + 0.2 * (level-math.ceil(level/2))
            v.level = math.ceil(level/2)
        end
        for k, v in pairs(G.GAME.hands) do
            v.glop = v.glop + glop
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, glop = 0, handname = '', level = ''})
    end,
}

SMODS.Consumable{
    key = "glopway",
    set = "Spectral",
    hidden = true,
    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit or card.area == G.jokers      
    end,
    use = function(self, card, area)
        
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname='...',chips = '...', mult = '...', glop = '...', level=''})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {glop = '+0.01', StatusText = true})
        delay(1.3)
        for k, v in pairs(G.GAME.hands) do
            v.glop = v.glop + 0.01
        end
        G.PROFILES[G.SETTINGS.profile].glop = G.PROFILES[G.SETTINGS.profile].glop + 0.01
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, glop = 0, handname = '', level = ''})
        SMODS.add_card({key="j_banana_glopku"})
    end,
}

-- this came to me in a dream
SMODS.PokerHand {
    key = "bouquet",
    chips=39.9,mult=4,
    l_chips=30,l_mult=3,
    example = {
        { 'S_Q', true, },
        { 'H_J', true, },
        { 'C_T', true, },
        { 'D_2', true, },
        { 'S_7', false, },
    },
    evaluate = function(parts, hand)
        local queens = {}
        local jacks = {}
        local tens = {}
        local twos = {}

        for _, card in pairs(hand) do
            if card:get_id() == 10 then
                tens[#tens + 1] = card
            end
            if card:get_id() == 11 then
                jacks[#jacks + 1] = card
            end
            if card:get_id() == 12 then
                queens[#queens + 1] = card
            end
            if card:get_id() == 2 then
                twos[#twos + 1] = card
            end
        end

        if #queens >= 1 and #jacks >= 1 and #tens >= 1 and #twos >= 1 then
            return { SMODS.merge_lists(queens, jacks, tens, twos) }
        end

        return {}
    end
}

-- ==Misc UI Changes==
local nf = number_format
function number_format(...)
    local ret = nf(...)
    if (ret == "naneinf" or ret == "Infinity") then return "bananeinf" end
    return ret
end

-- ===Credits===
function banana_credits()
    local text_scale = 0.8
    return {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 6}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.T, config={text = "Programmed by MathIsFun_", scale = text_scale*0.6, colour = G.C.WHITE, shadow = true}},
          }},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.T, config={text = "Contributors", scale = text_scale*0.6, colour = G.C.BANAN1, shadow = true}},
          }},
          {n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
            {n=G.UIT.C, config={align = "tl", padding = 0.05, minw = 2.5}, nodes={
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'firz', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'zedruu_the_goat', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'vexastrae', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'playerrWon', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Mysthaps', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Foegro', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'pannella', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Lexi', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Project666', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'astrapboy', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'notmario', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Mystic Misclick', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
            }},
            {n=G.UIT.C, config={align = "tl", padding = 0.05, minw = 2.5}, nodes={
                {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Crimson Heart', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Squiddy', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Dragokillfist', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
                {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Jevonn', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
            {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'cassknows', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                  {n=G.UIT.T, config={text = 'ori', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'unexian', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Aure', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'xphrogx', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'GloomyStew', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'George the Rat', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cl", padding = 0}, nodes={
                {n=G.UIT.T, config={text = '5381', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
              }},
            }},
          }},
        }}
      }}
end