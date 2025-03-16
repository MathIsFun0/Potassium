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


-- ===Texture replacement===
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
        if G.GAME.blind and G.GAME.blind.boss and context.cardarea == G.jokers then
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

-- ===New Content===
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
        return 'bl_banana_banana'
    end
    G.GAME.win_ante = G.GAME.win_ante - 1
    local ret = gnb()
    G.GAME.win_ante = G.GAME.win_ante + 1
    return ret
end
SMODS.Blind{
    key = "banana",
    --[[loc_txt = {
        name = "The Banana",
        text = {
            "#1# in 6 chance to",
            "self destruct",
        }
    },]]
    pos = {x = 0, y = 1},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {G.GAME.probabilities.normal or 1}
        }
    end,
    press_play = function(self)
        if pseudorandom(pseudoseed("this is literally just russian roulette")) < G.GAME.probabilities.normal/6 then  
            -- This definitely isn't perfect
            -- But it's temporary anyway
            G.FUNCS.overlay_menu{
                definition = create_UIBox_game_over(),
                config = {no_esc = true}
            }
        end
    end,
    boss_colour = G.C.BANAN1,
    boss = {min = 10, max = 10},
    in_pool = false,
    dollars = 15,
}

-- ==Glop==

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
local c_keys = {'chips', 'h_chips', 'chip_mod',
    'mult', 'h_mult', 'mult_mod',
    'x_chips', 'xchips', 'Xchip_mod',
    'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod',
    'e_mult', 'e_chips', 'ee_mult', 'ee_chips', 'eee_mult', 'eee_chips', 'hyper_mult', 'hyper_chips',
    'emult', 'echips', 'eemult', 'eechips', 'eeemult', 'eeechips', 'hypermult', 'hyperchips',
    'Emult_mod', 'Echip_mod', 'EEmult_mod', 'EEchip_mod', 'EEEmult_mod', 'EEEchip_mod', 'hypermult_mod', 'hyperchip_mod'}
function SMODS.calculate_effect(effect, ...)
    ce(effect, ...)
    for _, key in ipairs(c_keys) do --scoring effects
        if effect[key] and glop then
            glop = glop + 0.01
        end
    end
end