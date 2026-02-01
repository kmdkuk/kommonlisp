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

  ;; Step 3: 特殊形式 (quote と if)
  ;; t と nil を環境に入れておくとテストしやすいです
  (let ((env '((t . t) (nil . nil) (x . 10))))

    ;; --- Quote のテスト ---
    ;; (quote x) は、xの中身(10)ではなく、シンボル x そのものを返すはず
    (assert-equal '(quote x) 'x env)
    ;; リストも評価されずにそのまま返るはず
    (assert-equal '(quote (1 2 3)) '(1 2 3) env)

    ;; --- If のテスト ---
    ;; 条件が真(t)なら、第2引数(10)が返る
    (assert-equal '(if t 10 20) 10 env)
    ;; 条件が偽(nil)なら、第3引数(20)が返る
    (assert-equal '(if nil 10 20) 20 env)

    ;; Ifの重要な性質: 選ばれなかった方は「評価されない」ことの確認
    ;; もし評価されていたら、未定義変数 y でエラーやnilになるはずだが、
    ;; 正しく実装されていれば x (10) が返るはず
    (assert-equal '(if t x y) 10 env))

  ;; Step 4: 関数適用 (Primitive Functions)
  ;; 環境に「シンボル」と「実際のCommon Lispの関数」のペアを用意します
  ;; #' (シャープクォート) は「関数オブジェクトそのもの」を取り出す記法です
  (let ((global-env (list
                     (cons '+ #'+)
                     (cons '- #'-)
                     (cons 'list #'list)
                     (cons 'cons #'cons)
                     (cons 'car #'car)
                     (cons 'cdr #'cdr))))

    ;; 1. 基本的な計算
    (assert-equal '(+ 1 2) 3 global-env)

    ;; 2. 入れ子の計算 (引数が評価されてから足し算されるか)
    ;; (+ 1 (+ 2 3)) -> (+ 1 5) -> 6
    (assert-equal '(+ 1 (+ 2 3)) 6 global-env)

    ;; 3. リスト操作関数
    (assert-equal '(list 1 2) '(1 2) global-env)
    (assert-equal '(car (cons 1 2)) 1 global-env)

    ;; 4. 変数との組み合わせ
    ;; (let ((env (cons (cons 'x 10) global-env))) ... ) のように拡張してテスト
    (let ((env (append '((x . 10) (y . 20)) global-env)))
      (assert-equal '(+ x y) 30 env)))

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
