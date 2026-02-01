(defun my-eval (expr env)
  (cond
   ((numberp expr) expr)
   ((stringp expr) expr)
   ((symbolp expr)
     (cdr (assoc expr env)))
   (t "not implemented")))
