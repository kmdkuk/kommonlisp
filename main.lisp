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
      ; function call
      (t (apply
             ; search function object
             (cdr (assoc (car expr) env))
           ; eval arguments
           (mapcar (lambda (e) (my-eval e env)) (cdr expr))))))
   ((numberp expr) expr)
   ((stringp expr) expr)
   ((symbolp expr)
     (cdr (assoc expr env)))
   (t "not implemented")))
