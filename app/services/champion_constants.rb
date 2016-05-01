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
end
