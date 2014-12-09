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
