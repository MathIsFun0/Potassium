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

-- ===Add updates to existing Jokers===
SMODS.Joker:take_ownership('j_oops', {
    name = "Oops! All Bananas",
    --[[loc_txt = {
		name = "Oops! All Bananas",
		text = {
			"Guarantees all {C:attention}listed",
			"{C:green,E:1,S:1.1}probabilities",
			"{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}inf in 3{C:inactive})",
		}
	},]]
    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = 1e308
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
        if context.cardarea == G.play and context.destroying_card then
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

-- ===Banana Content===
SMODS.Back{
    key = "banana",
    --[[loc_txt = {
        name = "Banana Deck",
        text = {
            "All cards are",
            "{C:red,T:m_stone}Gros Michel{}",
        }
    },]]
    prefix_config = {
        atlas = false
    },
    atlas = 'Joker',
    pos = {x = 7, y = 6},
    apply = function(self, back)
        G.GAME.starting_params.banana = true
    end
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

-- Change win ante
local gigo = Game.init_game_object
function Game:init_game_object()
    local ret = gigo(self)
    ret.win_ante = ret.win_ante + 2
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
    boss = {min = 10, max = 10},
    in_pool = false,
    dollars = 15,
}

SMODS.Blind{
    key = "banana2",
    pos = {x = 0, y = 0},
    atlas = "blinds",
    loc_vars = function(self, info_queue, card)
        return {
            vars = {G.GAME and G.GAME.probabilities.normal or 1}
        }
    end,
    boss_colour = G.C.BANAN2,
    boss = {min = 10, max = 10},
    in_pool = false,
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

local cie = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    local ret = cie(effect, scored_card, key, amount, from_edition)
    if ret then return ret end

    if key == 'glop' and amount ~= 0 then 
        if effect.card then juice_card(effect.card) end
        glop = glop + amount
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, glop = glop})
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "+"..amount.." Glop", colour =  G.C.GLOP, edition = from_edition})
        end
        return true
    end

    if key == 'xglop' and amount ~= 1 then 
        if effect.card then juice_card(effect.card) end
        glop = glop * amount
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, glop = glop})
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "X"..amount.." Glop", colour =  G.C.GLOP, edition = from_edition})
        end
        return true
    end
    
    if key == 'eglop' and amount ~= 1 then 
        if effect.card then juice_card(effect.card) end
        glop = glop ^ amount
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, glop = glop})
        if not effect.remove_default_message then
            card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount.." Glop", colour =  G.C.GLOP, edition = from_edition})
        end
        return true
    end
end

local lc = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc()
	end
	G.ARGS.LOC_COLOURS.glop = G.C.GLOP
	return lc(_c, _default)
end

-- Glop Content
SMODS.Joker{
	key = "glopbucket",
	pos = { x = 0, y = 0 },
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

SMODS.Shader{
    key = "glop",
    path = "glop.fs"
}

SMODS.Edition{
    key = "glop",
    shader = "glop",
    pos = {x = 7, y = 6},
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
                        _xglop = _xglop + context.other_ret[m][k]
                    end
                end
                for _, k in ipairs(c_keys_ee) do
                    if context.other_ret[m][k] then
                        _eglop = _eglop + context.other_ret[m][k]
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
            }},
          }},
        }}
      }}
end