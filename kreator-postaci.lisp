(defun keywordify (symbol)
  (intern (symbol-name symbol) :keyword))

(defmacro defpostac (&rest slots)
  "Makro uproszczajace tworzenie postaci."
  `(defclass postac ()
     ,(loop for x in slots collecting `(,x :initarg ,(keywordify x) :accessor ,x :initform 0))))

(defpostac imie pochodzenie cecha-pochodzenia specjalizacja profesja cecha-profesji sztuczki
	   zrecznosc percepcja charakter spryt budowa
	   choroba rany reputacja slawa
	   pancerz bron-odleglosc bron-rece znajomi doswiadczenie
	   sprzet
	   bijatyka bron-reczna rzucanie samochod motocykl ciezarowka
	   kradziez-kieszonkowa otwieranie-zamkow zwinne-dlonie
	   pistolety karabiny bron-maszynowa luk kusza proca inne-umiejetnosci
	   wyczucie-kierunku przygotowanie-pulapki tropienie
	   nasluchiwanie wypatrywanie czujnosc skradanie-sie ukrywanie-sie maskowanie
	   lowiectwo znajomosc-terenu zdobywanie-wody
	   zastraszanie perswazja zdolnosci-przywodcze postrzeganie-emocji blef opieka-nad-zwierzetami
	   odpornosc-na-bol niezlomnosc morale
	   pierwsza-pomoc leczenie-ran leczenie-chorob mechanika elektronika komputery
	   wiedza-ogolna maszyny-ciezkie wozy-bojowe kutry rusznikarstwo wyrzutnie materialy-wybuchowe
	   kondycja plywanie wspinaczka jazda-konna powozenie ujezdzanie)


(defun przywitaj ()
  (format t "~&Witaj. Kreator postaci pozwoli Tobie w prosty sposób stworzyć postać.")
  (format t "~&Wybierz sposób tworzenia postaci:"))

(defun spytaj-o-wybor ()
  (print "Not implemented.")
  )

(defun stworz-manualnie (postac)
  (print "Not implemented.")
  )

(defun stworz-za-raczke (postac)
  (print "Not implemented.")
  )

(defun popraw-postac (postac)
  (print "Not implemented."))

(defun spytaj-czy-poprawic-postac ()
  )

(defun pozegnaj ()
  (print "Papa!"))

(defun hello-user (&aux postac)
  (przywitaj)
  (case (spytaj-o-wybor)
    (tworzenie-manualne (stworz-manualnie postac))
    (tworzenie-za-raczke (stworz-za-raczke postac))
    (popraw-istniejaca (popraw-postac postac))
    (wyjscie (return-from hello-user))
    (otherwise (error "Program zrobił coś, co nie było przewidziane. Sorry!")))
  (if (spytaj-czy-poprawic-postac)
      (popraw-postac postac)
      (pozegnaj)))
