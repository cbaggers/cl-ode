(ql:quickload :cl-ode)

(defvar *world*)
(defvar *space*)
(defvar *body*)
(defvar *plane*)
(defvar *sphere*) 


;; Initialize
(ode:init)	   

;; Create a world to play in...and set defaults...

(setf *world* (ode::world-create))
(ode::world-set-defaults *world*)
(ode:world-set-gravity *world* 0 -10 0)

;; Create a space to sort objects intelligently. 
(setf *space* (ode::hash-space-create nil))

;; create a physics body (has mass and such)
(setf *body* (ode::body-create *world*))

;; Create an immovable plane (half the entire space
(setf *plane* (ode::create-plane *space* 0 1 0 0))
(setf (ode::surface-bounce *plane*) 1)
(setf (ode::surface-bounce-vel *plane*) .1)

;; Create a sphere...
(setf *sphere* (ode::sphere-create *space* 1.0))
(setf (ode::surface-bounce *sphere*) 1)
(setf (ode::surface-bounce-vel *sphere*) .1)

;; Set the body's mass to a sphere shape...
(setf m (make-instance 'ode::mass))
(ode:mass-set-sphere m 1 5)
(ode:body-set-mass *body* m)

;; Add the sphere collision shape to the body.
(ode:geom-set-body *sphere* *body*)
 
;; Set the body's position
(ode:body-set-position *body* 0 5 0)

;; Add a move handler to watch it go...
(setf (ode::move-handler *body*)
			 (lambda (x) (format t "~A move-handler: ~A~%" *body* (ode:body-get-position x))))
				  
(setf (ode::collision-handler *sphere*)
      (lambda (this other contact)
	(format t "Collision detected with ~A & ~A~tcontact: ~A~%" this other contact)))

;; Test function, call 100x times...

(defun test (n)
  (ode::body-enable *body*)
  (ode::body-set-position *body* 0 5 0)
  (ode:body-set-linear-vel *body* 0 0 0) 
  (ode:body-set-rotation *body* (make-array 12 :element-type 'single-float :initial-contents '(1.0 0.0 0.0 0.0
											       0.0 1.0 0.0 0.0
											       0.0 0.0 0.0 1.0)))
  (dotimes (i n)
    (format t "~A: *sphere* & *body*  Enabled: ~A~%" i (ode::body-is-enabled *body*))
    
    (ode:physics-step *world* *space*)))

(test 10000)
