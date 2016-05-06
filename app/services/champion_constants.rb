require 'date'

module ChampionConstants
    CHAMP_RELEASE_DATES = {
        "Aatrox" =>         Date.parse("2013-06-13"),
        "Ahri" =>           Date.parse("2011-12-14"),
        "Akali" =>          Date.parse("2010-05-11"),
        "Alistar" =>        Date.parse("2009-02-21"),
        "Amumu" =>          Date.parse("2009-06-26"),
        "Anivia" =>         Date.parse("2009-07-10"),
        "Annie" =>          Date.parse("2009-02-21"),
        "Ashe" =>           Date.parse("2009-02-21"),
        "Aurelion Sol" =>   Date.parse("2016-03-24"),
        "Azir" =>           Date.parse("2014-09-16"),
        "Bard" =>           Date.parse("2015-03-12"),
        "Blitzcrank" =>     Date.parse("2009-09-02"),
        "Brand" =>          Date.parse("2011-04-12"),
        "Braum" =>          Date.parse("2014-05-12"),
        "Caitlyn" =>        Date.parse("2011-01-04"),
        "Cassiopeia" =>     Date.parse("2010-12-14"),
        "Cho'Gath" =>       Date.parse("2009-06-26"),
        "Corki" =>          Date.parse("2009-09-19"),
        "Darius" =>         Date.parse("2012-05-23"),
        "Diana" =>          Date.parse("2012-08-07"),
        "Dr. Mundo" =>      Date.parse("2009-09-02"),
        "Draven" =>         Date.parse("2012-06-06"),
        "Ekko" =>           Date.parse("2015-05-28"),
        "Elise" =>          Date.parse("2012-10-26"),
        "Evelynn" =>        Date.parse("2009-05-01"),
        "Ezreal" =>         Date.parse("2010-03-16"),
        "Fiddlesticks" =>   Date.parse("2009-02-21"),
        "Fiora" =>          Date.parse("2012-02-29"),
        "Fizz" =>           Date.parse("2011-11-15"),
        "Galio" =>          Date.parse("2010-08-10"),
        "Gangplank" =>      Date.parse("2009-08-19"),
        "Garen" =>          Date.parse("2010-04-27"),
        "Gnar" =>           Date.parse("2014-08-14"),
        "Gragas" =>         Date.parse("2010-02-02"),
        "Graves" =>         Date.parse("2011-10-19"),
        "Hecarim" =>        Date.parse("2012-04-18"),
        "Heimerdinger" =>   Date.parse("2009-10-10"),
        "Illaoi" =>         Date.parse("2015-11-24"),
        "Irelia" =>         Date.parse("2010-11-16"),
        "Janna" =>          Date.parse("2009-09-02"),
        "Jarvan IV" =>      Date.parse("2011-03-01"),
        "Jax" =>            Date.parse("2009-02-21"),
        "Jayce" =>          Date.parse("2012-07-07"),
        "Jhin" =>           Date.parse("2016-02-01"),
        "Jinx" =>           Date.parse("2013-10-10"),
        "Kalista" =>        Date.parse("2014-11-20"),
        "Karma" =>          Date.parse("2011-02-01"),
        "Karthus" =>        Date.parse("2009-06-12"),
        "Kassadin" =>       Date.parse("2009-08-07"),
        "Katarina" =>       Date.parse("2009-09-19"),
        "Kayle" =>          Date.parse("2009-02-21"),
        "Kennen" =>         Date.parse("2010-04-08"),
        "Kha'Zix" =>        Date.parse("2012-09-27"),
        "Kindred" =>        Date.parse("2015-10-14"),
        "Kog'Maw" =>        Date.parse("2010-06-24"),
        "LeBlanc" =>        Date.parse("2010-11-02"),
        "Lee Sin" =>        Date.parse("2011-04-01"),
        "Leona" =>          Date.parse("2011-07-13"),
        "Lissandra" =>      Date.parse("2013-04-30"),
        "Lucian" =>         Date.parse("2013-08-22"),
        "Lulu" =>           Date.parse("2012-03-20"),
        "Lux" =>            Date.parse("2010-10-19"),
        "Malphite" =>       Date.parse("2009-09-02"),
        "Malzahar" =>       Date.parse("2010-06-01"),
        "Maokai" =>         Date.parse("2011-02-16"),
        "Master Yi" =>      Date.parse("2009-02-21"),
        "Miss Fortune" =>   Date.parse("2010-09-08"),
        "Mordekaiser" =>    Date.parse("2010-02-24"),
        "Morgana" =>        Date.parse("2009-02-21"),
        "Nami" =>           Date.parse("2012-12-07"),
        "Nasus" =>          Date.parse("2009-10-01"),
        "Nautilus" =>       Date.parse("2012-02-14"),
        "Nidalee" =>        Date.parse("2009-12-17"),
        "Nocturne" =>       Date.parse("2011-03-15"),
        "Nunu" =>           Date.parse("2009-02-21"),
        "Olaf" =>           Date.parse("2010-06-09"),
        "Orianna" =>        Date.parse("2011-06-01"),
        "Pantheon" =>       Date.parse("2010-02-02"),
        "Poppy" =>          Date.parse("2010-01-13"),
        "Quinn" =>          Date.parse("2013-03-01"),
        "Rammus" =>         Date.parse("2009-07-10"),
        "Rek'Sai" =>        Date.parse("2014-12-11"),
        "Renekton" =>       Date.parse("2011-01-18"),
        "Rengar" =>         Date.parse("2012-08-21"),
        "Riven" =>          Date.parse("2011-09-14"),
        "Rumble" =>         Date.parse("2011-04-26"),
        "Ryze" =>           Date.parse("2009-02-21"),
        "Sejuani" =>        Date.parse("2012-01-17"),
        "Shaco" =>          Date.parse("2009-10-10"),
        "Shen" =>           Date.parse("2010-03-24"),
        "Shyvana" =>        Date.parse("2011-11-01"),
        "Singed" =>         Date.parse("2009-04-18"),
        "Sion" =>           Date.parse("2009-02-21"),
        "Sivir" =>          Date.parse("2009-02-21"),
        "Skarner" =>        Date.parse("2011-08-09"),
        "Sona" =>           Date.parse("2010-09-21"),
        "Soraka" =>         Date.parse("2009-02-21"),
        "Swain" =>          Date.parse("2010-10-05"),
        "Syndra" =>         Date.parse("2012-09-13"),
        "Tahm Kench" =>     Date.parse("2015-07-09"),
        "Talon" =>          Date.parse("2011-08-24"),
        "Taric" =>          Date.parse("2009-08-19"),
        "Teemo" =>          Date.parse("2009-02-21"),
        "Thresh" =>         Date.parse("2013-01-23"),
        "Tristana" =>       Date.parse("2009-02-21"),
        "Trundle" =>        Date.parse("2010-12-01"),
        "Tryndamere" =>     Date.parse("2009-05-01"),
        "Twisted Fate" =>   Date.parse("2009-02-21"),
        "Twitch" =>         Date.parse("2009-05-01"),
        "Udyr" =>           Date.parse("2009-12-02"),
        "Urgot" =>          Date.parse("2010-08-24"),
        "Varus" =>          Date.parse("2012-05-08"),
        "Vayne" =>          Date.parse("2011-05-10"),
        "Veigar" =>         Date.parse("2009-07-24"),
        "Vel'Koz" =>        Date.parse("2014-02-27"),
        "Vi" =>             Date.parse("2012-12-19"),
        "Viktor" =>         Date.parse("2011-12-29"),
        "Vladimir" =>       Date.parse("2010-07-27"),
        "Volibear" =>       Date.parse("2011-11-29"),
        "Warwick" =>        Date.parse("2009-02-21"),
        "Wukong" =>         Date.parse("2011-07-26"),
        "Xerath" =>         Date.parse("2011-10-05"),
        "Xin Zhao" =>       Date.parse("2010-07-13"),
        "Yasuo" =>          Date.parse("2013-12-13"),
        "Yorick" =>         Date.parse("2011-06-22"),
        "Zac" =>            Date.parse("2013-03-29"),
        "Zed" =>            Date.parse("2012-11-13"),
        "Ziggs" =>          Date.parse("2012-02-01"),
        "Zilean" =>         Date.parse("2009-04-18"),
        "Zyra" =>           Date.parse("2012-07-24")
    }

    ROLE_MAP = {
      0 => "can_top",
      1 => "can_jungle",
      2 => "can_mid",
      3 => "can_bot_carry",
      4 => "can_bot_support"
    }

    CHAMP_ROLES = {
        "Aatrox" =>         [0, 1],
        "Ahri" =>           [2],
        "Akali" =>          [0, 2],
        "Alistar" =>        [4],
        "Amumu" =>          [1],
        "Anivia" =>         [2],
        "Annie" =>          [2, 4],
        "Ashe" =>           [3],
        "Aurelion Sol" =>   [0, 1, 2],
        "Azir" =>           [2],
        "Bard" =>           [4],
        "Blitzcrank" =>     [4],
        "Brand" =>          [2, 4],
        "Braum" =>          [4],
        "Caitlyn" =>        [3],
        "Cassiopeia" =>     [2],
        "Cho'Gath" =>       [0, 1, 2],
        "Corki" =>          [2, 3],
        "Darius" =>         [0],
        "Diana" =>          [1, 2],
        "Dr. Mundo" =>      [0, 1],
        "Draven" =>         [3],
        "Ekko" =>           [0, 1, 2],
        "Elise" =>          [1],
        "Evelynn" =>        [1],
        "Ezreal" =>         [3],
        # "Fiddlesticks" =>   [1, 4],
        "Fiddlesticks" =>   [1],
        "Fiora" =>          [0],
        "Fizz" =>           [0, 1, 2],
        "Galio" =>          [0, 2],
        "Gangplank" =>      [0, 2],
        "Garen" =>          [0],
        "Gnar" =>           [0],
        "Gragas" =>         [0, 1],
        "Graves" =>         [0, 1],
        "Hecarim" =>        [0, 1],
        "Heimerdinger" =>   [0, 2],
        "Illaoi" =>         [0],
        "Irelia" =>         [0],
        "Janna" =>          [4],
        "Jarvan IV" =>      [0, 1],
        "Jax" =>            [0, 1],
        "Jayce" =>          [0, 2],
        "Jhin" =>           [3],
        "Jinx" =>           [3],
        "Kalista" =>        [3],
        "Karma" =>          [2, 4],
        "Karthus" =>        [2],
        "Kassadin" =>       [2],
        "Katarina" =>       [2],
        "Kayle" =>          [0, 1, 2],
        "Kennen" =>         [0, 2, 4],
        "Kha'Zix" =>        [1],
        "Kindred" =>        [1],
        "Kog'Maw" =>        [3],
        "LeBlanc" =>        [2],
        "Lee Sin" =>        [1],
        "Leona" =>          [4],
        "Lissandra" =>      [0, 2],
        "Lucian" =>         [3],
        "Lulu" =>           [0, 2, 4],
        "Lux" =>            [2, 4],
        "Malphite" =>       [0],
        "Malzahar" =>       [2],
        "Maokai" =>         [0],
        "Master Yi" =>      [1],
        "Miss Fortune" =>   [3],
        "Mordekaiser" =>    [0, 2, 3],
        "Morgana" =>        [2, 4],
        "Nami" =>           [4],
        "Nasus" =>          [0],
        "Nautilus" =>       [0, 4],
        "Nidalee" =>        [1],
        "Nocturne" =>       [1],
        # "Nunu" =>           [0, 1, 4],
        "Nunu" =>           [0, 1],
        "Olaf" =>           [0, 1],
        "Orianna" =>        [2],
        "Pantheon" =>       [0, 1, 2],
        "Poppy" =>          [0],
        "Quinn" =>          [0, 1, 2, 3],
        "Rammus" =>         [0, 1],
        "Rek'Sai" =>        [1],
        "Renekton" =>       [0],
        "Rengar" =>         [0, 1],
        "Riven" =>          [0],
        "Rumble" =>         [0, 1],
        "Ryze" =>           [0, 2],
        "Sejuani" =>        [1],
        "Shaco" =>          [1],
        "Shen" =>           [0],
        "Shyvana" =>        [1],
        "Singed" =>         [0],
        "Sion" =>           [0, 1],
        "Sivir" =>          [3],
        "Skarner" =>        [1],
        "Sona" =>           [4],
        "Soraka" =>         [4],
        "Swain" =>          [0, 2],
        "Syndra" =>         [2],
        "Tahm Kench" =>     [0, 4],
        "Talon" =>          [2],
        "Taric" =>          [4],
        "Teemo" =>          [0],
        "Thresh" =>         [4],
        "Tristana" =>       [3],
        "Trundle" =>        [0, 4],
        "Tryndamere" =>     [0, 1],
        "Twisted Fate" =>   [2],
        "Twitch" =>         [3],
        "Udyr" =>           [1],
        "Urgot" =>          [0, 2, 3],
        "Varus" =>          [2, 3],
        "Vayne" =>          [3],
        "Veigar" =>         [2],
        "Vel'Koz" =>        [2, 4],
        "Vi" =>             [1],
        "Viktor" =>         [2],
        "Vladimir" =>       [0, 2],
        "Volibear" =>       [0, 1],
        "Warwick" =>        [0, 1],
        "Wukong" =>         [0, 1],
        "Xerath" =>         [2],
        "Xin Zhao" =>       [0, 1],
        "Yasuo" =>          [0, 2],
        "Yorick" =>         [0],
        "Zac" =>            [0, 1],
        "Zed" =>            [2],
        "Ziggs" =>          [2],
        "Zilean" =>         [2, 4],
        "Zyra" =>           [2, 4]
    }

    # http://titlecapitalization.com/
    CHAMP_NICKNAMES = {
        "Alistar" => "the Unmilkable",
        "Annie" => "the Girl Who Lost Her Bear",
        "Aurelion Sol" => "Definitely Not Ao Shin",
        "Azir" => "THE EMPEROR OF THE SANDS",
        "Bard" => "WaLOooloOOo",
        "Blitzcrank" => "the Hooker",
        "Braum" => "the Mustachioed",
        "Darius" => "the Dunkmaster",
        "Draven" => "the DRAAAAAAAVEN",
        "Graves" => "the Cigarless",
        # "Graves" => "the Man with No Cigar",
        "Lulu" => "the LCS Hype \\s",
        "Malphite" => "He's a rock",
        # "Morgana" => "(There's something here... OMG I still can't move)",
        "Nasus" => "the Stacking Susan",
        "Pantheon" => "the Baker Ascended",
        "Rammus" => "the ok",
        "Rek'Sai" => "the Misgendered",
        # "Rek'Sai" => "the \"Um, actually it's a 'her'\" champion",
        "Rengar" => "the ADC's Heart Attack",
        "Shaco" => "Buy pink wards, pls",
        "Singed" => "the One to Not Chase",
        # "Soraka" => "the Bananner",
        # "Soraka" => "the Bananarizer",
        "Soraka" => "the Banana Tosser",
        "Taric" => "the Truly Outrageous",
        "Teemo" => "the Literal Devil",
        "Udyr" => "the ManBearPig",
        "Urgot" => "the Furgot",
        "Yasuo" => "the HASAGI!",
        "Yorick" => "Wait who?",
        "Zed" => "the British Z"
    }

    def self.list_all_champs
        # Champion.order(name: :asc)
        # names = Champion.order(name: :asc).map("#{&:name}: #{&:display_title}")
        names = Champion.order(name: :asc).map(&:name)
        titles = Champion.order(name: :asc).map(&:display_title)
        # titles = Champion.order(name: :asc).map(&:nickname)
        for nt in names.zip(titles) do
            puts "#{nt[0]}: #{nt[1]}"
        end
    end

    def self.roles_for(champ_name)
        CHAMP_ROLES[champ_name].map { |role_key| ROLE_MAP[role_key] }
    end

    def self.spell_info(spell, asset_version, passive:)
        if passive
            image_url = RiotClient::ASSET_PREFIX + "#{asset_version}/img/passive/#{spell["image"]["full"]}"
        else
            image_url = RiotClient::ASSET_PREFIX + "#{asset_version}/img/spell/#{spell["image"]["full"]}"
        end

        {
            name: spell["name"],
            image_url: image_url,
            description: spell["description"] == "BadDesc" ? nil : spell["description"],
            cost: fill_in_spell_info(spell["resource"], spell),
            cooldown: spell["cooldownBurn"]
        }
    end

    def self.fill_in_spell_info(str, spell)
        if str
            str.gsub(/\{\{ ([^\}]+) \}\}/) do
                placeholder = Regexp.last_match[1]
                replace_spell_placeholder(placeholder, spell)
            end
        end
    end

    def self.replace_spell_placeholder(placeholder, spell)
        case placeholder
        when "cost"
            spell["costBurn"]
        when /^e/
            spell["effectBurn"][placeholder[1].to_i]
        when /^(f|a)/
            var = spell["vars"].find { |v| v["key"] == placeholder }
            replace_spell_var(var, spell)
        end
    end

    # TODO WIP
    def self.replace_spell_var(var, spell)
        coeff = var["coeff"].join("/")

        case var
        when "spelldamage"
            coeff + " Spell Damage"
        when "bonusattackdamage"
            coeff + " Bonus Attack Damage"
        when "@special.dariusr3" # Maximum Damage
            coeff
        when "attackdamage"
            coeff + " Attack Damage"
        when "@special.viw" # Vi denting blows
            "(1 per #{coeff} Bonus AD)"
        when "@text"
            coeff
        when "@cooldownchampion"

        when "@dynamic.abilitypower"

        when "bonusarmor"

        when "bonusspellblock"

        when "@dynamic.attackdamage"

        when "bonushealth"

        when "@special.jaxrarmor"

        when "@special.jaxrmr"

        when "armor"

        when "@stacks"

        when "@special.BraumWArmor"

        when "@special.BraumWMR"

        when "health"

        when "@special.nautilusq"

        end
    end
end
