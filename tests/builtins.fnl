(require-macros :fennel-test.test)
(local itable (require :init))

(deftest insert-test
  (testing "insert at the end by default"
    (assert-eq
     [1 2 3 4]
     (itable.insert [1 2 3] 4))
    (assert-eq
     [1 2 3 nil]
     (itable.insert [1 2 3] nil)))

  (testing "insert shifts elements"
    (assert-eq
     [4 1 2 3]
     (itable.insert [1 2 3] 1 4))
    (assert-eq
     [1 2 4 3]
     (itable.insert [1 2 3] 3 4)))

  (testing "insert only works with numeric keys"
    (assert-not (pcall itable.insert [1 2 3] :a 10))
    (assert-not (pcall itable.insert [1 2 3] :nil 10)))

  (testing "insert expects at least two arguments"
    (assert-not (pcall itable.insert [1 2 3]) "insert must accept at least 2 args")
    (assert-is (pcall itable.insert [1 2 3] 1 10 20) "insert should accept 3 or more args"))

  (testing "insert returns immutable table"
    (assert-not (pcall #(tset (itable.insert [1 2 3] 4) 1 0))
                "insert must return immutable table"))

  (testing "insert doesn't modify original table"
    (let [t [1 2]]
      (itable.insert t 3)
      (assert-eq [1 2] t))))

(deftest remove-test
  (testing "remove at the end by default"
    (assert-eq
     [[1 2 3] 4]
     [(itable.remove [1 2 3 4])]))

  (testing "remove shifts elements"
    (assert-eq
     [2 3 4]
     (itable.remove [1 2 3 4] 1))
    (assert-eq
     [1 2 4 5]
     (itable.remove [1 2 3 4 5] 3 4)))

  (testing "remove only works with numeric keys"
    (assert-not (pcall itable.remove [1 2 3] :a 10))
    (assert-not (pcall itable.remove [1 2 3] :nil 10)))

  (testing "remove expects at least one argument"
    (assert-not (pcall itable.remove) "remove must accept at least 1 arg")
    (assert-is (pcall itable.remove [1 2 3] 1 10 20) "remove should accept 2 or more args"))

  (testing "remove returns immutable table"
    (assert-not (pcall #(tset (itable.remove [1 2 3] 4) 1 0))
                "remove must return immutable table"))

  (testing "remove doesn't modify original table"
    (let [t [1 2]]
      (itable.remove t 1)
      (assert-eq [1 2] t))))

(deftest concat-test
  (testing "concat works on tables in the table"
    (assert-is (pcall itable.concat [[1]])
               "concat must work on table values"))

  (testing "concat accepts serialization function"
    (assert-eq "A,B,C"
               (itable.concat [:a :b :c] "," 1 3 #(string.upper $))))

  (testing "concat accepts serialization function and options"
    (assert-eq "a,b,c"
               (itable.concat [:A :B :C] "," 1 3
                              #(if (. $2 :upper?) (string.upper $) (string.lower $))
                              {:upper? false}))))

(when itable.move
  (deftest move-test
    (testing "move returns immutable table"
      (assert-not (pcall #(tset (itable.move [1 2 3] 1 3 4) 1 0))
                  "move must return immutable table"))

    (testing "move doesn't modify original table"
      (let [t [1 2 3]]
        (itable.move t 1 3 4)
        (assert-eq [1 2 3] t))

      (let [t [1 2 3]]
        (itable.move t 1 3 4 t)
        (assert-eq [1 2 3] t)))))

(deftest sort-test
  (testing "sort returns immutable table"
    (assert-not (pcall #(tset (itable.sort [3 2 1]) 1 0))
                "sort must return immutable table"))
  (testing "sort table"
    (assert-eq [1 2] (itable.sort [2 1])))

  (testing "sort doesn't modify original table"
    (let [t [2 1]]
      (itable.sort t)
      (assert-eq [2 1] t))))

(deftest pack-test
  (testing "pack returns correct size indication"
    (assert-eq (itable.pack nil nil nil nil nil nil nil) {:n 7})
    (assert-eq (itable.pack nil nil :a nil nil :b nil) {:n 7 3 :a 6 :b})
    (assert-eq (itable.pack) {:n 0}))
  (testing "pack returns immutable table"
    (assert-not (pcall #(tset (itable.pack [3 2 1]) 1 0))
                "pack must return immutable table")))
