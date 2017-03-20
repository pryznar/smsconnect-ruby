module Smsconnect
	class Error

		ERRORS = {
			'-1' => 'duplicitni user_id - stejne oznacena sms byla odeslana jiz v minulosti',
			'0' => 'OK',
			'1' => 'neznama chyba',
			'2' => 'neplatny login',
			'3' => 'neplatny hash nebo password (podle varianty zabezpeceni prihlaseni)',
			'4' => 'neplatny time, vetsi odchylka casu mezi servery nez maximalni akceptovana v nastaveni sluzby SMS Connect',
			'5' => 'nepovolena IP, viz nastaveni sluzby SMS Connect',
			'6' => 'neplatny nazev akce',
			'7' => 'tato sul byla jiz jednou za dany den pouzita',
			'8' => 'nebylo navazano spojeni s databazi',
			'9' => 'nedostatecny kredit',
			'10' => 'neplatne cislo prijemce SMS',
			'11' => 'prazdny text zpravy',
			'12' => 'SMS je delsi nez povolenych 459 znaku',
		}

		def initialize(error)
			@error = error
		end

		def message
			if ERRORS.key? @error
				return ERRORS[@error]
			end
			"Unknown error"
		end

		def is_error?
			@error != '0'
		end

	end
end