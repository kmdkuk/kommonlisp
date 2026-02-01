(defun my-eval (expr env)
  (cond
   ((consp expr)
     (cond
      ((eq (car expr) `quote)
        (cadr expr))
      ((eq (car expr) `if)
        (if (not (eq (my-eval (cadr expr) env) nil))
            (my-eval (caddr expr) env)
            (my-eval (cadddr expr) env)))
      ((eq (car expr) `lambda)
        (list
         ; tag
         `closure
         ; params
         (cadr expr)
         ; body
         (caddr expr)
         ; saved-env
         env))
      ; function call t=bool
      (t
        (let ((fn (my-eval (car expr) env))
              (args (mapcar (lambda (e) (my-eval e env)) (cdr expr))))
          (my-apply fn args)))))
   ((numberp expr) expr)
   ((stringp expr) expr)
   ((symbolp expr)
     (cdr (assoc expr env)))
   (t "not implemented")))

(defun my-apply (fn args)
  (cond
   ;;closure
   ((and (consp fn) (eq (car fn) `closure))
     (my-eval (caddr fn) (pairlis (cadr fn) args (cadddr fn))))

   (t (apply fn args))))
