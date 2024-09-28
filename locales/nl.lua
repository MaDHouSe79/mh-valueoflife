local Translations = {
    info = {
        ['total_lives'] = "Je hebt %{lives} levens...",
        ['check_lives'] = "Check je levens",
        ['give_live'] = "Geef een leven aan een speler-ID",
        ['take_live'] = "Neem een leven van een speler-ID",
        ['reset_lives'] = "[RESET] You have now %{amount} lives.",
    },
    notify = {
        ['received_live'] = "Je hebt zojuist 1 leven van een beheerder ontvangen.",
        ['reduced_live'] = "Een beheerder heeft zojuist je leven met 1 verlaagd.",
        ['you_are_dead'] = "Je bent dood...",
    },
    target = {
        ['talk_to'] = "Praat Met MaDHouSe",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})