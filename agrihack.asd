;;;; ..asd

(asdf:defsystem :agrihack2018
  :author "Tommy Lawlor <tominoz99@gmail.com>"
  :serial t
  :depends-on (#:cl-who
	       #:cl-css
	       #:wookie
	       #:cl-ppcre
	       #:alexandria
	       #:bordeaux-threads)
  :components ((:file "package")
               (:file "website")))

