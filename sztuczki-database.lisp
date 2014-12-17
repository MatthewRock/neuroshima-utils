;; Written by Mateusz "Malice" Malisz
;; 2014-10-10

;;;;
;;;; The MIT License (MIT)
;;;;
;;;; Copyright (c) 2014 Mateusz Malisz
;;;;
;;;; Permission is hereby granted, free of charge, to any person obtaining a copy
;;;; of this software and associated documentation files (the "Software"), to deal
;;;; in the Software without restriction, including without limitation the rights
;;;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;;;; copies of the Software, and to permit persons to whom the Software is
;;;; furnished to do so, subject to the following conditions:
;;;;
;;;; The above copyright notice and this permission notice shall be included in all
;;;; copies or substantial portions of the Software.

;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;;;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;;;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;;;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;;;; SOFTWARE.

				
;(znajdz-sztuczke :dla-postaci (:sila 16 :zrecznosc 12)) <- Znajdzie sztuczki, ktore wymagaja max 16 sily i max 12 zrecznosci. Zakladamy, ze postac ma inne wspolczynniki na 0.
;(znajdz-sztuczke :nazwa "nazwa-bez-case") <- Znajdzie sztuczke po nazwie, niezaleznie od wielkosci liter
;(znajdz-sztuczke :zrodlo ("Podrecznik 1.5" "Ruiny")) <- Szuka sztuczek tylko w tych ksiazkach. 
;(znajdz-sztuczke :dla-postaci (:sila 16 :zrecznosc 12) :tylko-to-spelnia t) <- Znajdzie sztuczki, ktore wymagaja max 16 sily i max 12 zrecznosci. Zakladamy, ze postac ma wszystko inne na 0(lub -1 :))

;TODO - Zrobic segregacje sztuczek, by mozliwe bylo:
; (znajdz-sztuczke :kategoria ("non-combat" "combat" "costam").


;TODO:
; Zmienic sposob drukowania sztuczek
; Zrobic klase dla postaci, jesli zajdzie taka potrzeba.(pewnie zajdzie)

(defparameter *baza-sztuczek* nil
  "Lista zawierająca sztuczki zachowane w pliku sztuczki.dat")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Sztuczka;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defclass sztuczka ()
  ((nazwa
    :initarg :nazwa
    :accessor nazwa
    :initform (error "Musisz podac nazwe sztuczki!")
    :documentation "String z nazwa sztuczki.")
   (wymagania
    :initarg :wymagania
    :accessor wymagania
    :initform nil ; Najprostsza sztuczka nie wymaga nic.
    :documentation "Lista keywordow z wymaganiami. NIL oznacza brak wymagan.")
   (opis
    :initarg :opis
    :accessor opis
    :initform nil ; Domyslnie opis nie jest wymagany.
    :documentation "String z opisem sztuczki(flavour text).")
   (dzialanie
    :initarg :dzialanie
    :accessor dzialanie
    :initform (error "Musisz podac dzialanie sztuczki!") ; Sztuczka bez dzialanie nie jest sztuczka.
    :documentation "String z opisem dzialania sztuczki(wspolczynniki, etc.)")
   (zrodlo
    :initarg :zrodlo
    :accessor zrodlo
    :initform "Podstawka"
    :documentation "Zawiera stringa z nazwa pochodzenia sztuczki. Mozliwe stringi znajduja sie w komentarzu za ta klasa")
   (typ
    :initarg :typ
    :accessor typ
    :initform nil ; Nie wiem jeszcze jakie beda typy, wiec domyslnie nie ma zadnego(uniwersalny)
    :documentation "Typ sztuczki - narzucone odgórnie przez twórce bazy, wartości takie jak np. combat non-combat lub karabiny, itd."
    )))
;Dozwolone zrodla:
; "Podstawka" "Nazwa-dodatku" "Fanowska"
(defmethod print-object ((object sztuczka) stream)
  (print-unreadable-object (object stream :type t)
    (with-slots (nazwa wymagania opis dzialanie zrodlo typ) object
	(format stream "~&~3tNazwa:~15t~S~%~3tWymagania:~15t~S~%~3tOpis:~15t~S~%~3tDziałanie:~15t~S~%~3tŹródło:~15t~S~%~3tTyp:~15t~S~%" nazwa wymagania opis dzialanie zrodlo typ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Postac;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when (:compile-toplevel :load-toplevel :execute)
    (defun keywordify (symbol)
      (intern (symbol-name symbol) :keyword)))

(defmacro defpostac (&rest slots)
  "Makro uproszczajace tworzenie postaci."
  `(defclass postac ()
     ,(loop for x in slots collecting `(,x :initarg ,(keywordify x) :accessor ,x :initform 0))))

(defpostac pochodzenie klasa zrecznosc percepcja spryt budowa charakter bijatyka bron-reczna rzucanie samochod motocykl ciezarowka kradziez-kieszonkowa otwieranie-zamkow zwinne-dlonie pistolety kara
biny bron-maszynowa luk kusza proca)

;; Postać nie jest jeszcze zaimplementowana; możliwe, że w ogóle nie będzie
;; wykorzystana. Na razie zostawiam.

(defun test-czysc-baze ()
  (setf *baza-sztuczek* nil))

(defmacro dodaj-sztuczke-do-bazy (&rest keyword-lista-do-sztuczki)
  "Dodaje sztuczke do bazy *baza-sztuczek*."
  `(push (make-instance 'sztuczka ,@keyword-lista-do-sztuczki) *baza-sztuczek*))

(defun test-initializuj-baze ()
  (dodaj-sztuczke-do-bazy :nazwa "Zasłona" :wymagania '(bijatyka 2 budowa 12) :dzialanie "dzialanie tej sztuczki")
  (dodaj-sztuczke-do-bazy :nazwa "Wilk Morski" :dzialanie "Robisz węzły.")
  (dodaj-sztuczke-do-bazy :nazwa "Sztuczka Placeholder" :wymagania '((samochody 3 ciezarowki 3))
			  :dzialanie "Taranujesz"))

(defun znajdz-po-nazwie (nazwa-sztuczki)
  "Zwraca liste sztuczek ktore maja taka sama nazwe(case-unsensitive) jak nazwa-sztuczki."
  (loop for x in *baza-sztuczek* when (equalp (nazwa x) nazwa-sztuczki) collect x))

(defun znajdz-po-zrodle (zrodlo-sztuczki)
  "Zwraca liste sztuczek, ktore maja takie same zrodlo(case-unsensitive) jak zrodlo-sztuczki."
  (loop for x in *baza-sztuczek* when (equalp (zrodlo x) zrodlo-sztuczki) collect x))

(defun sprawdz-dla-alternatyw (wym pos)
  "Zwraca T, jesli postac spelnia dowolne z wymagan, w innym wypadku NIL."
  (do* ((wymagania wym (cddr wymagania))
	(postac pos)
	(obecne-spr (car wymagania) (car wymagania)))
       ((null wymagania) nil)
    (cond
      ((null (getf postac obecne-spr)))
      ((<= (cadr wymagania) (getf postac obecne-spr)) (return t)))))

(defun postac-spelnia-wymagania-p (wyma pos)
  "Zwraca T jesli postac spelnia wszystkie wymagania, w innym wypadku NIL."
  (do* ((wymagania wyma (if (listp obecne-spr) (cdr wymagania) (cddr wymagania)))
	(postac pos)
	(obecne-spr (car wymagania) (car wymagania)))
       ((null wymagania) t)
    (cond
      ((listp obecne-spr) (unless (sprawdz-dla-alternatyw obecne-spr postac) (return nil)))
      ((null (getf postac obecne-spr)) (return nil))
      ((> (cadr wymagania) (getf postac obecne-spr)) (return nil)))))

(defun znajdz-dla-specyfikacji-postaci (specyfikacja-postaci)
  "Znajduje wszystkie sztuczki, ktore spelnilaby postac majaca specyfikacje-postaci, a reszte na 0."
  (loop for x in *baza-sztuczek* when (or (equal (wymagania x) nil)
					  (postac-spelnia-wymagania-p (wymagania x) specyfikacja-postaci))
     collect x))

(defun znajdz-sztuczke (&key dla-postaci nazwa zrodlo)
  "Zwraca sztuczki spelniajace wszystkie warunki podane jako argumenty."
  (let ((lista0 (if dla-postaci (znajdz-dla-specyfikacji-postaci dla-postaci) *baza-sztuczek*))
	(lista1 (if nazwa (znajdz-po-nazwie nazwa) *baza-sztuczek*))				
	(lista2 (if zrodlo (znajdz-po-zrodle zrodlo) *baza-sztuczek*)))
    (reduce #'intersection (list lista0 lista1 lista2))))

(defmacro print-all-slots (slots object stream)
  "Wypisuje wszystkie podane SLOTy danego OBJECTu do STREAMu."
  `(with-slots ,slots ,object
     ,@(loop for y in slots collecting `(print ,y ,stream))))

(defun wypisz-wzorzec (stream)
  "Wypisuje wzorzec do pliku(ponieważ plik będzie czytany readem, pominie komentarze lispa."
  (format stream "; Wzorzec:~%")
  (format stream "; \"Nazwa\"~%")
  (format stream "; (wym1nazwa wym1wartosc wym2nazwa wym2wartosc ...) [1]~%")
  (format stream "; \"Opis sztuczki(tekst fabularny)\"~%")
  (format stream "; \"Działanie sztuczki(efekt mechaniki)\"~%")
  (format stream "; \"Źródło sztuczki\"~%")
  (format stream "; \"Typ sztuczki\"~%")
  (format stream "; [1]: Dla alternatyw(wymaganie1 lub wymaganie2) używa się zagnieżdżonych list:((wym1 wym2))")
  (terpri stream)
  (terpri stream))

(defun zapisz-baze (sciezka)
  "Tworzy baze danych w pliku o podanej sciezce."
  (with-open-file (out sciezka
		       :direction :output
		       :if-exists :supersede)
    (wypisz-wzorzec out)
    (loop for x in *baza-sztuczek* do
	 (progn
	   (print-all-slots (nazwa wymagania opis dzialanie zrodlo typ) x out)
	   (terpri out)
	   (print (nazwa x)))))
  t)

(defun wczytaj-baze (sciezka)
  "Wczytuje bazę sztuczek ze ścieżki sciezka i umieszcza ją w *baza-sztuczek*, DODAJĄC sztuczki do bazy.
   Dodatkowo wypisuje nazwy wczytanych sztuczek do standard output."
  (with-open-file (in sciezka)
    (do ((nazwa (read in nil nil) (read in nil nil))
	 (wymagania (read in nil nil) (read in nil nil))
	 (opis (read in nil nil) (read in nil nil))
	 (dzialanie (read in nil nil) (read in nil nil))
	 (zrodlo (read in nil nil) (read in nil nil))
	 (typ (read in nil nil) (read in nil nil)))
	((null nazwa))
      (format t "~&~S" nazwa)
      (push (make-instance 'sztuczka
			   :nazwa nazwa
			   :wymagania wymagania
			   :opis opis
			   :dzialanie dzialanie
			   :zrodlo zrodlo
			   :typ typ)
	    *baza-sztuczek*)))
  t)
