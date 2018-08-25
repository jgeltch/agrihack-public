(in-package :agrihack2018)

(load-plugins)

(defmacro make-css (&rest rest)
  `(cl-css:css ',rest))

(define-symbol-macro *root-script*
    (concatenate 'string ;*get-button*
		 (alexandria:read-file-into-string "js/testing.js")
		 ))
(define-symbol-macro *loading.js*
    (alexandria:read-file-into-string "js/loading-bar.js"))

(define-symbol-macro *loading.css*
    (alexandria:read-file-into-string "js/loading-bar.css"))

(defmacro deftemplatedpage (pagename pagetemplate templateargs pageformat &rest args)
  "A simple templating system
page name is a string and will be the uri component looked up
page template can be a symbol or a string and is the basic skeleton to build the page
template args are the default string/variables that are used in the thing
pageformat is how the args are put in and are formated only if args is not nil"
  (if (symbolp pageformat)
      (let ((string (gensym))
	    (pagebody (gensym)))
	(if (null args)
	    `(defroute (:get ,pagename) (req res)
	       (let* ((,pagebody
		       (regex-replace-all "~%"
					  (symbol-value ',pageformat)
					  "<br/>~%"))
		      (,string (format nil ,pagetemplate
				       ,@templateargs ,pagebody)))
		 (setf (response-headers res)
		       '(:access-control-allow-origin "*"))
		 (send-response res :status 200
				:body (format nil ,string))))

	    `(defroute (:get ,pagename) (req res)
	       (let* ((,pagebody
		       (regex-replace-all "~%"
					  (symbol-value ',pageformat)
					  "<br/>~%"))
		      (,string (format nil ,pagetemplate
				       ,@templateargs ,pagebody)))
		 (setf (response-headers res)
		       '(:access-control-allow-origin "*"))
		 (send-response res :status 200
				:body (format nil ,string ,@args))))))

      (let ((string (gensym))
	    (pageformat (regex-replace-all "~%" pageformat "<br/>~%")))
	(if (null args)
	    `(defroute (:get ,pagename) (req res)
	       (let ((,string (format nil ,pagetemplate ,@templateargs
				      ,pageformat)))
		 (setf (response-headers res)
		       '(:access-control-allow-origin "*"))
		 (send-response res
				:status 200
				:body (format nil ,string))))

	    `(defroute (:get ,pagename) (req res)
	       (let ((,string (format nil ,pagetemplate ,@templateargs
				      ,pageformat)))
		 (send-response res
				:status 200
				:body (format nil ,string ,@args))))))))
(defparameter *html-template*
  (with-html-output-to-string (str nil :indent t)
    (:html
     (:head (:style "~a"))
     (:body "~a~a"))))

(defmacro defpage (pagename pageformat &rest args)
  "Defines a page with *html-template* as the template"
  `(deftemplatedpage ,pagename *html-template* (*menu-css*
						*menu-html*)
		     ,pageformat ,@args))

(defparameter *menu-css*
  (make-css
   ("#menuul " :list-style-type :none
	      :margin 0
	      :padding 0
	      :background-color "#4b2f77"
	      :overflow :hidden)
   ("#menuul li" :float :left)
   ("#menuul li a img" :text-align :center
	       )
   ("#menuul li a" :display :block
	   :color "b2cd66"
	   :text-align :center
	   :padding "14px 16px"
	   :text-decoration :none )
   ("#menuul li a:hover"
    :background-color "#34185d")
   (".clearfix.after"
    :content ""
    :display :table)))

(defparameter *menu-html*
  (with-html-output-to-string (str nil :indent t)
    (:ul :id "menuul"
	 (:li (:a :href "index.html" "Status"))
	 (:li (:a :href "conf.html" "Configure"))
	 ;(:li (:a :href "forth" "Forth") )
	 ;(:li (:a :href "lisp" "Lisp"))
	 ;(:li (:a :href "stuff" "Stuff"))
	 )))

(defparameter *script-html-template*
  (with-html-output-to-string (str nil :indent t)
    (:html
     (:head
      (:style "~a")
      (:meta :charset "utf-8") 
      (:script :src "js/loading-bar.js")
      (:link :rel "stylesheet" :href "js/loading-bar.css")
      (:script :type "text/javascript" "~a"))
     (:body "~a~a"))))

(defmacro defscriptedpage (pagename pagescript pageformat &rest args)
  `(deftemplatedpage ,pagename *script-html-template* (*menu-css*
						       ,pagescript
						       *menu-html*
						       )
		     ,pageformat ,@args))

(defparameter *get-button* "$(document).ready(function() {$(\"button\").click(function(){
    $.get(\"/\", function(data, status){
        alert(\"Data: \" + data + \"\nStatus: \" + status);
    });
});
});")

(defparameter *root-page*
  (with-html-output-to-string (str nil :indent t)
					;(:button :script "clearInterval(intervaal);" "Hello world")
    (:table (:tr (:ti
		  (:h1 "Humidity")
		  (:div :id "myprogress"
			(:style

			 "
 #tempbar .ldBar-label { 
color:red
font-size: 30px;
 -webkit-text-stroke: black;
   text-shadow:
        3px 3px 0 #666,
      -1px -1px 0 #666,  
       1px -1px 0 #666,
       -1px 1px 0 #666,
        1px 1px 0 #666;
 }
 #tempbar .ldBar-label:after { content: \"%\"}
 ")
			(:div :id "tempbar" :class "ldBar label-center"
			      :style "width: 50%; height: 50%;  color:black; font-size:30px"
			      :data-preset "bubble"
			      :data-value "50%"
			      :data-pattern-size "20"))))
	    (:ti
	     (:h1 "Temperature")
	     (:div
	      
	      (:div :id "myprogress"
		    (:style
		     "
#humidbar .ldBar-label:after { content: \"C\"}
#humidbar .ldBar-label { color:black;
text-align:center;
color:black;
font-size: 30px};
 .ldBar-label:after { content: \"C\"};
")
		    (:div :id "humidbar" :class "ldBar label-center"
			  :style "width: 50%; height:
				       20%; text-color:black;"
			  :data-preset "energy"))
	      )))
    (:script "
loop();
 setInterval(loop, 2000) ;")
					;(:script "~a")
    ))

(defparameter *root-css* "
")

(define-symbol-macro *conf-js*
    (alexandria:read-file-into-string "./js/conf.js"))

(defparameter *conf-page*
  (with-html-output-to-string (str nil)
    (:div (:style :id "form" "form {text-align: left}") 
	  (:br)
	  (:input :id "hitemp" "Max Temp (C)")
	  (:br)
	  (:input :id "besttemp" "Target Temp (C)")
	  (:br)
	  (:input :id "lowtemp" "Min Temp (C)")
	  (:br)
	  (:input :id "lowhumid" "Min Humidity")
	  (:br)
	  (:input :id "hihumid" "Max Humidity")
	  (:br)
	  (:button :onclick "send()" "Submit"))
    (:style "table, tr, td:{border: 1px solid black;}")
    (:table :style "border: 1px solid black;"
	    (:tr (:td "Temp") (:td "22C"))
	    (:tr (:td "Max temp") (:td "40C"))
	    (:tr (:td "Target Temp") (:td "30C"))
	    (:tr (:td "Min Temp") (:td "20C"))
	    (:tr (:td "Humidity") (:td "72%"))
	    (:tr (:td "Max Humidity") (:td "90%"))
	    (:td (:td "Min Humidity") (:td "80%")))))

(defscriptedpage "/conf.html" *conf-js* *conf-page*)

(defroute (:post "/esp") (req resp)
  (send-response resp :body "<html><body>hi</body> </html>"))

(wookie-plugin-export:def-directory-route "/js" "./js/")

(defscriptedpage "/" *root-script* *root-page* )
(defscriptedpage "/index.html" *root-script* *root-page* )

(let ((thread nil))
  (defun start-web-server ()
    ;; start the event loop that Wookie runs inside of
    (labels ((start ()  (as:with-event-loop ()
			  ;; create a listener object, and pass it to
			  ;; start-server, which starts Wookie
			  (let* ((listener (make-instance 'listener
							  :bind nil  ; equivalent to "0.0.0.0" aka "don't care"
							  :port 5000))
				 ;; start it!! this passes back a
				 ;; cl-async server class
				 (server (start-server listener)))
			    ;; stop server on ctrl+c
			    (as:signal-handler 2
					       (lambda (sig)
						 (declare (ignore sig))
						 ;; remove our signal
						 ;; handler (or the
						 ;; event loop will
						 ;; just sit
						 ;; indefinitely)
						 (as:free-signal-handler 2)
						 ;; graceful
						 ;; stop...rejects all
						 ;; new connections,
						 ;; but lets current
						 ;; requests
						 ;; finish.
						 (as:close-tcp-server server)))))))
      (if (threadp thread)
	  'is-a-thread
	  (setq thread (make-thread #'start)))))
  (defun stop-web-server ()
    (if (thread-alive-p thread)
	(progn  (destroy-thread thread)
		(setf thread nil)))))
(defun dump-root-page ()
  )
