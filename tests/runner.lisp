;; プロジェクトルートの main.lisp をロードする
(load (merge-pathnames "../main.lisp" *load-truename*))

;; ---------------------------------------------------------
;; テストユーティリティ
;; ---------------------------------------------------------
(defvar *failed-count* 0)

;; 引数 env を追加（デフォルトは nil）
(defun assert-equal (input expected &optional (env nil))
  (let ((actual (my-eval input env))) ;; <--- ここで env を渡す！
    (if (equal actual expected)
        (format t "✅ [PASS] ~S -> ~S~%" input actual)
        (progn
         (format t "❌ [FAIL] ~S~%" input)
         (format t "   Expected: ~S~%" expected)
         (format t "   Actual:   ~S~%" actual)
         (incf *failed-count*)))))

;; ---------------------------------------------------------
;; テストケース定義
;; ---------------------------------------------------------
(defun run-all-tests ()
  (format t "=== Running Lisp Tests ===~%")

  ;; Step 1: リテラル
  (assert-equal 10 10)
  (assert-equal "Hello" "Hello")

  ;; Step 2: 変数
  (let ((env '((x . 10) (y . 20) (apple . "red"))))

    (assert-equal 'x 10 env) ;; x は 10 か？
    (assert-equal 'apple "red" env) ;; apple は "red" か？
    (assert-equal 'z nil env)) ;; 知らない変数は nil か？

  ;; ---------------------------------------------------------
  ;; 集計と終了コード
  ;; ---------------------------------------------------------
  (if (= *failed-count* 0)
      (progn
       (format t "🎉 All tests passed!~%") ;; 修正: ここでカッコを閉じ
       (sb-ext:exit :code 0))
      (progn
       (format t "🔥 ~A tests failed!~%" *failed-count*) ;; 修正: ここでカッコを閉じ
       (sb-ext:exit :code 1))))

;; テスト実行
(run-all-tests)
