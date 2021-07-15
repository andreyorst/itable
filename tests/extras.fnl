(require-macros :fennel-test.test)
(local itable (require :init))

(deftest itable-test
  (testing "itable turns table into immutable table"
    (assert-not (pcall #(tset (itable [1 2 3]) 1 0))
                "itable must return immutable table"))
  (testing "itable doesn't affect nested tables"
    (assert-eq [[0] 2 3] (doto (itable [[1] 2 3]) (tset 1 1 0))))
  (testing "changing original table doesn't affect immutable one"
    (let [t [1 2 3]
          i (itable t)]
      (tset t 1 0)
      (assert-eq [0 2 3] t)
      (assert-eq [1 2 3] i)))
  (testing "changing nested table in original table affects immutable one"
    (let [t [[1] 2 3]
          i (itable t)]
      (tset t 1 1 0)
      (assert-eq [[0] 2 3] t)
      (assert-eq [[0] 2 3] i))))

(deftest eq-test
  (testing "comparing base-types"
    (assert-is (itable.eq))
    (assert-is (itable.eq 1))
    (assert-is (itable.eq 1 1))
    (assert-not (itable.eq 1 2))
    (assert-is (itable.eq 1.0 1.0))
    (assert-is (itable.eq "1" "1")))
  (testing "table comparison"
    (assert-is (itable.eq []))
    (assert-is (itable.eq [] []))
    (assert-is (itable.eq [] {}))
    (assert-is (itable.eq [1 2] [1 2]))
    (assert-not (itable.eq [1] [1 2]))
    (assert-not (itable.eq [1 2] [1]))
    (assert-not (itable.eq {:a 1 :b 2} (doto {:a 1 :b 2} (table.insert 10))))
    (assert-not (itable.eq [1 2 3] (doto [1 2 3] (tset :a 10))))
    (assert-is (itable.eq [1 2 3] {1 1 2 2 3 3}))
    (assert-is (itable.eq {4 1} [nil nil nil 1])))
  (testing "deep comparison"
    (assert-is (itable.eq [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]
                          [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]))
    (assert-not (itable.eq [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]
                           [[1 [2 [3]] {[6] {:a [1 [1 [1 [1]]]]}}]]))
    (assert-is (itable.eq [1 [2]] [1 [2]]))
    (assert-is (itable.eq [[1] [2]] [[1] [2]]))
    (assert-not (itable.eq [[1] [2]] [[1] []]))
    (assert-not (itable.eq [1 [2]] [1 [2 [3]]]))
    (assert-not (itable.eq {:a {:b 2}} {:a {:b 3}})))
  (testing "comparing multiple values"
    (assert-is (itable.eq 1 1 1))
    (assert-is (itable.eq [1] [1] [1]))
    (assert-is (itable.eq [[1 2]] [[1 2]] [[1 2]]))
    (assert-is (itable.eq [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]
                          [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]
                          [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]))
    (assert-not (itable.eq 1 1 2))
    (assert-not (itable.eq 1 1 2 1 1))
    (assert-not (itable.eq [1] [1] [1 2]))
    (assert-not (itable.eq [[1] [2]] [[1] [2]] [[2] [1]]))
    (assert-not (itable.eq [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]
                           [[1 [2 [3]] {[5] {:a [1 [1 [1 [1]]]]}}]]
                           [[1 [2 [3]] {[6] {:a [1 [1 [1 [1]]]]}}]]))))

(deftest assoc-test
  (testing "assoc works with numeric and non-numeric keys"
    (assert-eq [1 2 3]
               (itable.assoc [1 3 3] 2 2))
    (assert-eq {:a 1 :b 2}
               (itable.assoc {:a 1 :b 1} :b 2)))
  (testing "assoc creates new entries"
    (assert-eq {:a 1 :b 2}
               (itable.assoc {:a 1} :b 2))
    (assert-eq [1 2 3]
               (itable.assoc [1 2] 3 3)))
  (testing "assoc returns immutable table"
    (assert-not (pcall #(tset (itable.assoc [1 2] 3 3) 1 0))
                "assoc must return immutable table"))
  (testing "assoc doesn't modify table"
    (let [t {:a 1 :b 2}]
      (itable.assoc t :c 3)
      (assert-eq {:a 1 :b 2} t))))

(deftest assoc-in-test
  (testing "assoc-in works with numeric and non-numeric keys"
    (assert-eq [1 2 3]
               (itable.assoc-in [1 3 3] [2] 2))
    (assert-eq {:a 1 :b 2}
               (itable.assoc-in {:a 1 :b 1} [:b] 2)))
  (testing "assoc-in creates new entries"
    (assert-eq {:a 1 :b 2}
               (itable.assoc-in {:a 1} [:b] 2))
    (assert-eq [1 2 3]
               (itable.assoc-in [1 2] [3] 3))
    (assert-eq {:a {:b {:c 10}}}
               (itable.assoc-in {} [:a :b :c] 10))
    (assert-eq {:a [nil {:b [nil nil {:c 10}]}]}
               (itable.assoc-in {} [:a 2 :b 3 :c] 10))
    (assert-eq {:a [nil {:b [nil nil {:c 10}]}]}
               (itable.assoc-in nil [:a 2 :b 3 :c] 10)))
  (testing "assoc-in returns immutable tables"
    (let [t (itable.assoc-in {} [:a 2 :b 3 :c] 10)
          a t.a
          b (. a 2)
          c b.b
          d (. c 3)]
      (assert-not (pcall #(tset t 1 0))
                  "assoc-in must return immutable table")
      (assert-eq {:a [nil {:b [nil nil {:c 10}]}]} t)
      (assert-not (pcall #(tset a 1 0))
                  "assoc-in must return immutable table")
      (assert-eq [nil {:b [nil nil {:c 10}]}] a)
      (assert-not (pcall #(tset b 1 0))
                  "assoc-in must return immutable table")
      (assert-eq {:b [nil nil {:c 10}]} b)
      (assert-not (pcall #(tset c 1 0))
                  "assoc-in must return immutable table")
      (assert-eq [nil nil {:c 10}] c)
      (assert-not (pcall #(tset d 1 0))
                  "assoc-in must return immutable table")
      (assert-eq {:c 10} d)))
  (testing "assoc-in doesn't modify table"
    (let [t {:a 1 :b 2}]
      (itable.assoc-in t [:c] 3)
      (assert-eq {:a 1 :b 2} t))))

(deftest update-test
  (testing "update works with numeric and non-numeric keys"
    (assert-eq [1 2 3]
               (itable.update [1 3 3] 2 #(- $ 1)))
    (assert-eq {:a 1 :b 2}
               (itable.update {:a 1 :b 1} :b #(+ $ 1))))
  (testing "update creates new entries"
    (assert-eq {:a 1 :b 2}
               (itable.update {:a 1} :b #2))
    (assert-eq [1 2 3]
               (itable.update [1 2] 3 #3)))
  (testing "update returns immutable table"
    (assert-not (pcall #(tset (itable.update [1 2] 3 #3) 1 0))
                "update must return immutable table"))
  (testing "update doesn't modify table"
    (let [t {:a 1 :b 2}]
      (itable.update t :c #3)
      (assert-eq {:a 1 :b 2} t))))

(deftest update-in-test
  (testing "update-in works with numeric and non-numeric keys"
    (assert-eq [1 2 3]
               (itable.update-in [1 3 3] [2] #(- $ 1)))
    (assert-eq {:a 1 :b 2}
               (itable.update-in {:a 1 :b 1} [:b] #(+ $ 1))))
  (testing "update-in creates new entries"
    (assert-eq {:a 1 :b 2}
               (itable.update-in {:a 1} [:b] #2))
    (assert-eq [1 2 3]
               (itable.update-in [1 2] [3] #3))
    (assert-eq {:a {:b {:c 10}}}
               (itable.update-in {} [:a :b :c] #10))
    (assert-eq {:a [nil {:b [nil nil {:c 10}]}]}
               (itable.update-in {} [:a 2 :b 3 :c] #10))
    (assert-eq {:a [nil {:b [nil nil {:c 10}]}]}
               (itable.update-in nil [:a 2 :b 3 :c] #10)))
  (testing "update-in returns immutable tables"
    (let [t (itable.update-in {} [:a 2 :b 3 :c] #10)
          a t.a
          b (. a 2)
          c b.b
          d (. c 3)]
      (assert-not (pcall #(tset t 1 0))
                  "update-in must return immutable table")
      (assert-eq {:a [nil {:b [nil nil {:c 10}]}]} t)
      (assert-not (pcall #(tset a 1 0))
                  "update-in must return immutable table")
      (assert-eq [nil {:b [nil nil {:c 10}]}] a)
      (assert-not (pcall #(tset b 1 0))
                  "update-in must return immutable table")
      (assert-eq {:b [nil nil {:c 10}]} b)
      (assert-not (pcall #(tset c 1 0))
                  "update-in must return immutable table")
      (assert-eq [nil nil {:c 10}] c)
      (assert-not (pcall #(tset d 1 0))
                  "update-in must return immutable table")
      (assert-eq {:c 10} d)))
  (testing "update-in doesn't modify table"
    (let [t {:a 1 :b 2}]
      (itable.update-in t [:c] #3)
      (assert-eq {:a 1 :b 2} t))))

(deftest deepcopy-test
  (testing "deepcopy produces nested immutable tables"
    (let [t {:a {:b {:c 1}}}
          t* (itable.deepcopy t)
          a t*.a
          b a.b]
      (assert-not (pcall #(tset t* 1 0))
                  "update-in must return immutable table")
      (assert-eq {:a {:b {:c 1}}} t*)
      (assert-not (pcall #(tset a 1 0))
                  "update-in must return immutable table")
      (assert-eq {:b {:c 1}} a)
      (assert-not (pcall #(tset b 1 0))
                  "update-in must return immutable table")
      (assert-eq {:c 1} b)))
  (testing "deepcopy doesn't affect original tables"
    (let [t {:a {:b {:c 1}}}
          _ (itable.deepcopy t)
          a t.a
          b a.b]
      (assert-is (pcall #(tset t :b 0))
                 "update-in must return immutable table")
      (assert-eq {:a {:b {:c 1}} :b 0} t)
      (assert-is (pcall #(tset a :c 0))
                 "update-in must return immutable table")
      (assert-eq {:b {:c 1} :c 0} a)
      (assert-is (pcall #(tset b :d 0))
                 "update-in must return immutable table")
      (assert-eq {:c 1 :d 0} b))))

(deftest first-test
  (testing "first doesn't modify original table"
    (let [t [1 2 3]]
      (assert-eq 1 (itable.first t))
      (assert-eq [1 2 3] t)))
  (testing "first works on immutable tables"
    (let [t (itable [1 2 3])]
      (assert-eq 1 (itable.first t))
      (assert-eq [1 2 3] t))))

(deftest rest-test
  (testing "rest doesn't modify original table"
    (let [t [1 2 3]]
      (assert-eq [2 3] (itable.rest t))
      (assert-eq [1 2 3] t)))
  (testing "rest works on immutable tables"
    (let [t (itable [1 2 3 4])]
      (assert-eq [2 3 4] (itable.rest t))
      (assert-eq [1 2 3 4] t)))
  (testing "rest produces immutable table"
    (assert-not (pcall #(tset (itable.rest [1 2 3]) 1 0))
                "rest must return immutable table")))

(deftest nthrest-test
  (testing "nthrest doesn't modify original table"
    (let [t [1 2 3 4 5 6]]
      (assert-eq [3 4 5 6] (itable.nthrest t 2))
      (assert-eq [1 2 3 4 5 6] t)))
  (testing "nthrest works on immutable tables"
    (let [t (itable [1 2 3 4 5 6])]
      (assert-eq [3 4 5 6] (itable.nthrest t 2))
      (assert-eq [1 2 3 4 5 6] t)))
  (testing "nthrest produces immutable table"
    (assert-not (pcall #(tset (itable.nthrest [1 2 3] 2) 1 0))
                "nthrest must return immutable table")))

(deftest last-test
  (testing "last doesn't modify original table"
    (let [t [1 2 3]]
      (assert-eq 3 (itable.last t))
      (assert-eq [1 2 3] t)))
  (testing "last works on immutable tables"
    (let [t (itable [1 2 3])]
      (assert-eq 3 (itable.last t))
      (assert-eq [1 2 3] t))))

(deftest butlast-test
  (testing "butlast doesn't modify original table"
    (let [t [1 2 3]]
      (assert-eq [1 2] (itable.butlast t))
      (assert-eq [1 2 3] t)))
  (testing "butlast works on immutable tables"
    (let [t (itable [1 2 3])]
      (assert-eq [1 2] (itable.butlast t))
      (assert-eq [1 2 3] t)))
  (testing "butlast produces immutable table"
    (assert-not (pcall #(tset (itable.butlast [1 2 3]) 1 0))
                "butlast must return immutable table")))

(deftest join-test
  (testing "join doesn't modify original table"
    (let [t1 [1 2 3]
          t2 [4 5 6]]
      (assert-eq [1 2 3 4 5 6] (itable.join t1 t2))
      (assert-eq [1 2 3] t1)
      (assert-eq [4 5 6] t2)))
  (testing "join works on immutable tables"
    (let [t1 (itable [1 2 3])
          t2 (itable [4 5 6])]
      (assert-eq [1 2 3 4 5 6] (itable.join t1 t2))
      (assert-eq [1 2 3] t1)
      (assert-eq [4 5 6] t2)))
  (testing "join accepts any amount of tables"
    (assert-eq [1 2 3 4 5 6 7 8]
               (itable.join [1 2 3] [4] [5 6] [7] [8] [])))
  (testing "join returns immutable table"
    (assert-not (pcall #(tset (itable.join [1 2 3] [4] [5 6] [7] [8] []) 1 0))
                "join must return immutable table")))

(deftest take-test
  (testing "take doesn't modify original table"
    (let [t [1 2 3]]
      (assert-eq [1 2] (itable.take 2 t))
      (assert-eq [1 2 3] t)))
  (testing "take returns immutable table"
    (assert-not (pcall #(tset (itable.take [1 2 3] 2) 1 0))
                "take must return immutable table")))

(deftest drop-test
  (testing "drop doesn't modify original table"
    (let [t [1 2 3 4 5]]
      (assert-eq [3 4 5] (itable.drop 2 t))
      (assert-eq [1 2 3 4 5] t)))
  (testing "drop returns immutable table"
    (assert-not (pcall #(tset (itable.drop [1 2 3] 2) 1 0))
                "drop must return immutable table")))

(deftest partition-test
  (testing "partition"
    (assert-not (pcall itable.partition))
    (assert-not (pcall itable.partition 1))
    (assert-eq (itable.partition 1 [1 2 3 4]) [[1] [2] [3] [4]])
    (assert-eq (itable.partition 1 2 [1 2 3 4]) [[1] [3]])
    (assert-eq (itable.partition 3 2 [1 2 3 4 5]) [[1 2 3] [3 4 5]])
    (assert-eq (itable.partition 3 3 [0 -1 -2 -3] [1 2 3 4]) [[1 2 3] [4 0 -1]]))
  (testing "partition returns immutable table"
    (assert-not (pcall #(tset (itable.partition 1 [1 2 3 4]) 1 0))
                "partition must return immutable table")
    (each [_ t (ipairs (itable.partition 3 3 [0 -1 -2 -3] [1 2 3 4]))]
      (assert-not (pcall #(tset t 1 0))
                  "partition must contain immutable tables"))))

(deftest keys-test
  (testing "keys returns all keys"
    (assert-eq {:a :a 2 2 [4] [4]}
               (collect [_ k (ipairs (itable.keys {:a :a 2 2 [4] [4]}))]
                 (values k k))))
  (testing "keys doesn't modify original table"
    (let [t {:a 1}]
      (assert-eq [:a] (itable.keys t))
      (assert-eq {:a 1} t)))
  (testing "keys returns immutable table"
    (assert-not (pcall #(tset (itable.keys {:a 1 :b 2}) :c 0))
                "keys must return immutable table")))

(deftest vals-test
  (testing "vals returns all vals"
    (assert-eq {:a :a 2 2 [4] [4]}
               (collect [_ v (ipairs (itable.vals {:a :a 2 2 [4] [4]}))]
                 (values v v))))
  (testing "vals doesn't modify original table"
    (let [t {:a 1}]
      (assert-eq [1] (itable.vals t))
      (assert-eq {:a 1} t)))
  (testing "vals returns immutable table"
    (assert-not (pcall #(tset (itable.vals {:a 1 :b 2}) :c 0))
                "vals must return immutable table")))

(deftest group-by-test
  (testing "group-by returns grouped table and empty table of ungroupped items"
    (let [t [{:foo "bar" :baz :qux}
             {:foo "bar" :baz :qux}
             {:foo "bar" :baz :baz}
             {:foo "qux" :bar :baz}
             {:foo "foo" :bar :baz}]]
      (assert-eq [{:bar [{:foo "bar" :baz :qux}
                         {:foo "bar" :baz :qux}
                         {:foo "bar" :baz :baz}]
                   :qux [{:foo "qux" :bar :baz}]
                   :foo [{:foo "foo" :bar :baz}]} []]
                 [(itable.group-by #(. $ :foo) t)])))
  (testing "group-by returns ungrouped items in second table"
    (let [t [{:foo "bar" :baz :qux}
             {:baz :qux}
             {:baz :baz}
             {:foo "qux" :bar :baz}
             {:foo "foo" :bar :baz}]]
      (assert-eq [{:bar [{:foo "bar" :baz :qux}]
                   :qux [{:foo "qux" :bar :baz}]
                   :foo [{:foo "foo" :bar :baz}]}
                  [{:baz :qux}
                   {:baz :baz}]]
                 [(itable.group-by #(. $ :foo) t)])))
  (testing "group-by returns immutable tables"
    (let [t [{:foo "bar" :baz :qux}
             {:foo "qux" :bar :baz}
             {:bar :baz}]
          (grouped ungroupped) (itable.group-by #(. $ :qux) t)]
      (each [_ t (pairs grouped)]
        (assert-not (pcall #(tset t 1 0))
                    "group-by must return immutable groups"))
      (assert-not (pcall #(tset ungroupped 1 0))
                  "group-by must return immutable ungrouped table"))))

(deftest frequencies-test
  (testing "frequencies returns immutable table"
    (assert-not (pcall #(tset (itable.frequencies {:a 1 :b 2}) 1 0))
                "frequencies must return immutable table")))
