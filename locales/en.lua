local Translations = {
    info = {
        ['total_lives'] = "You have %{lives} lives...",
        ['check_lives'] = "Check your lives",
        ['give_live'] = "Give a live to a player ID",
        ['take_live'] = "Take a live from a player ID",
        ['reset_lives'] = "[RESET] You have now %{amount} lives.",
    },
    notify = {
        ['received_live'] = "You just received 1 live form an admin.",
        ['reduced_live'] = "An admin just reduced your live by 1.",
        ['you_are_dead'] = "You are dead...",
    },
    target = {
        ['talk_to'] = "Talk to MaDHouSe",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})