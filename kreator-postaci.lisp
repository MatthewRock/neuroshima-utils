(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun keywordify (symbol)
    (intern (symbol-name symbol) :keyword)))

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
  "Funkcja do skutku pyta użytkownika o poprawny wybór z menu."
  (do ((wybor 0) ; Na początku za wybór ustawiam dowolną liczbę spoza zasięgu(wybrałem 0)
       (plist-odpowiedz '(1 tworzenie-manualne 2 tworzenie-za-raczke 3 tworzenie-pytania 4 popraw-istniejaca 5 wyjscie))) ; Lista, na podstawie której wybrany będzie odpowiedni symbol do zwrócenia
      ((and (< wybor 6) (> wybor 0))
       (second (member wybor plist-odpowiedz)))
    ;Wypisz menu
    (format t "~&1. Stwórz postać manualnie, wprowadzając samemu potrzebne dane.")
    (format t "~&2. Stwórz postać z pomocą kreatora. Teoretycznie łatwy i przyjemny :)")
    (format t "~&3. Stwórz postać odpowiadając na pytania. Eksperymentalne, prawdopodobnie nie wylosuje Tobie wymarzonej postaci, ale jest to szybki sposób :)")
    (format t "~&4. Popraw istniejącą już postać, stworzoną kreatorem.")
    (format t "~&5. Skończ pracę z programem.")
    ;Hack: używam ora jako strażnika. jeśli parse-integer zwróci nil, to dzięki ORowi zmienna
    ; zamiast NILa otrzyma wartość -1, czyli poza zakresem. Zapobiega problemom.
    (format t "~&Wybór: ") (setf wybor (or (parse-integer (read-line) :junk-allowed t) -1))))

(defun stworz-manualnie (postac)
  (print "Not implemented."))

(defun stworz-za-raczke (postac)
  (print "Not implemented.")
  )

(defun popraw-postac (postac)
  (print "Not implemented.Popraw."))

(defun spytaj-czy-poprawic-postac ()
  (y-or-n-p "Czy chcesz poprawić postać?"))

(defun stworz-pytaniami (postac)
  (print "Pytanie! Podaj odpowiedź!")
  (setf postac (read-line))
  postac)

(defun pozegnaj ()
  (print "Papa!"))

(defun hello-user (&aux postac)
  (przywitaj)
  (case (spytaj-o-wybor)
    (tworzenie-manualne (stworz-manualnie postac))
    (tworzenie-za-raczke (stworz-za-raczke postac))
    (popraw-istniejaca (popraw-postac postac))
    (tworzenie-pytania (setf postac (stworz-pytaniami postac)))
    (wyjscie (return-from hello-user))
    (otherwise (error "Program zrobił coś, co nie było przewidziane. Sorry!")))
  (if (spytaj-czy-poprawic-postac)
      (popraw-postac postac))
  (pozegnaj)
  postac)
