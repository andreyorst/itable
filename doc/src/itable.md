# Itable (v0.0.1)
`itable` - immutable tables for Lua runtime.

**Table of contents**

- [`concat`](#concat)
- [`insert`](#insert)
- [`move`](#move)
- [`pack`](#pack)
- [`remove`](#remove)
- [`sort`](#sort)
- [`unpack`](#unpack)
- [`eq`](#eq)
- [`deepcopy`](#deepcopy)
- [`assoc`](#assoc)
- [`assoc-in`](#assoc-in)
- [`update`](#update)
- [`update-in`](#update-in)
- [`keys`](#keys)
- [`vals`](#vals)
- [`group-by`](#group-by)
- [`frequencies`](#frequencies)
- [`first`](#first)
- [`rest`](#rest)
- [`nthrest`](#nthrest)
- [`last`](#last)
- [`butlast`](#butlast)
- [`join`](#join)
- [`partition`](#partition)
- [`take`](#take)
- [`drop`](#drop)

## `concat`
Function signature:

```
(concat t sep start end serializer opts)
```

Concatenate each element of sequential table with separator `sep`.

Optionally supports `start` and `end` indexes, and a `serializer`
function, with a table `opts` for that serialization function.

If no serialization function is given, `tostring` is used.

``` fennel
(local {: view} (require :fennel))
(local t [1 2 {:a 1 :b 2}])
(assert-eq (itable.concat t ", " nil nil view {:one-line? true})
           "1, 2, {:a 1 :b 2}")
```

## `insert`
Function signature:

```
(insert t ...)
```

Inserts element at position `pos` into sequential table,
shifting up the elements.  The default value for `pos` is table length
plus 1, so that a call with just two arguments will insert the value
at the end of the table.  Returns a new immutable table.

### Examples

Original table is not modified, when element is inserted:

``` fennel
(local t1 [1 2 3])
(assert-eq [1 2 3 4] (itable.insert t1 4))
(assert-eq [1 2 3] t1)
```

New table is immutable:

``` fennel
(local t1 [1 2 3])
(local t2 (itable.insert t1 4))
(assert-not (pcall table.insert t2 5))
```

## `move`
Function signature:

```
(move src start end tgt dest)
```

Move elements from `src` table to `dest` starting at `start` to `end`,
placing elements from `tgt` and up.  The default for `dest` is `src`.
The destination range can overlap with the `src` range.  The number of
elements to be moved must fit in a Lua integer.  Returns new immutable
table.

### Examples

Move elements from 3 to 5 to another table's end:

``` fennel
(local t1 [1 2 3 4 5 6 7])
(local t2 [10 20])
(assert-eq [10 20 3 4 5] (itable.move t1 3 5 3 t2))
(assert-eq t1 [1 2 3 4 5 6 7])
(assert-eq t2 [10 20])
```

## `pack`
Function signature:

```
(pack ...)
```

Pack values into immutable table with size indication.

## `remove`
Function signature:

```
(remove t key)
```

Remove `key` from table, and return a new immutable table and value
that was associated with the `key`.

### Examples

Remove element from the end of the table:


``` fennel
(local t1 [1 2 3])
(local (t2 v) (itable.remove t1))

(assert-eq t1 [1 2 3])
(assert-eq t2 [1 2])
(assert-eq v 3)
```

The newly produced table is immutable:

``` fennel
(assert-not (pcall table.insert (itable.remove [1 2 3])))
```

## `sort`
Function signature:

```
(sort t f)
```

Return new immutable table of sorted elements from `t`.  Optionally
accepts sorting function `f`.

## `unpack`
Function signature:

```
(unpack t)
```

Unpack immutable table.

Note, that this is needed only in LuaJit and Lua 5.2, because of how
metamethods work.

## `eq`
Function signature:

```
(eq ...)
```

Deep comparison.

Works on table keys that itself are tables.  Accepts any amount of
elements.

``` fennel
(assert-is (eq 42 42))
(assert-is (eq [1 2 3] [1 2 3]))
```

Deep comparison is used for tables:

``` fennel
(assert-is (eq {[1 2 3] {:a [1 2 3]} {:a 1} {:b 2}}
               {{:a 1} {:b 2} [1 2 3] {:a [1 2 3]}}))
(assert-is (eq {{{:a 1} {:b 1}} {{:c 3} {:d 4}} [[1] [2 [3]]] {:a 2}}
               {[[1] [2 [3]]] {:a 2} {{:a 1} {:b 1}} {{:c 3} {:d 4}}}))
```

## `deepcopy`
Function signature:

```
(deepcopy x)
```

Create a deep copy of a given table, producing immutable tables for nested tables.
Copied table can't contain self references.

## `assoc`
Function signature:

```
(assoc t key val)
```

Associate `val` under a `key`.

### Examples

``` fennel
(assert-eq {:a 1 :b 2} (itable.assoc {:a 1} :b 2))
(assert-eq {:a 1 :b 2} (itable.assoc {:a 1 :b 1} :b 2))
```

## `assoc-in`
Function signature:

```
(assoc-in t [k & ks] val)
```

Associate `val` into set of immutable nested tables `t`, via given keys.
Returns a new immutable table.  Returns a new immutable table.

### Examples

Replace value under nested keys:

``` fennel
(assert-eq
 {:a {:b {:c 1}}}
 (itable.assoc-in {:a {:b {:c 0}}} [:a :b :c] 1))
```

Create new entries as you go:

``` fennel
(assert-eq
 {:a {:b {:c 1}} :e 2}
 (itable.assoc-in {:e 2} [:a :b :c] 1))
```

## `update`
Function signature:

```
(update t key f)
```

Update table value stored under `key` by calling a function `f` on
that value. `f` must take one argument, which will be a value stored
under the key in the table.

### Examples

Same as [`assoc`](#assoc) but accepts function to produce new value based on key value.

``` fennel
(assert-eq
 {:data "THIS SHOULD BE UPPERCASE"}
 (itable.update {:data "this should be uppercase"} :data string.upper))
```

## `update-in`
Function signature:

```
(update-in t [k & ks] f)
```

Update table value stored under set of immutable nested tables, via
given keys by calling a function `f` on the value stored under the
last key.  `f` must take one argument, which will be a value stored
under the key in the table.  Returns a new immutable table.

### Examples

Same as [`assoc-in`](#assoc-in) but accepts function to produce new value based on key value.

``` fennel
(fn capitalize-words [s]
  (pick-values 1
    (s:gsub "(%a)([%w_']*)" #(.. ($1:upper) ($2:lower)))))

(assert-eq
 {:user {:name "John Doe"}}
 (itable.update-in {:user {:name "john doe"}} [:user :name] capitalize-words))
```

## `keys`
Function signature:

```
(keys t)
```

Return all keys from table `t` as an immutable table.

## `vals`
Function signature:

```
(vals t)
```

Return all values from table `t` as an immutable table.

## `group-by`
Function signature:

```
(group-by f t)
```

Group table items in an associative table under the keys that are
results of calling `f` on each element of sequential table `t`.
Elements that the function call resulted in `nil` returned in a
separate table.

### Examples

Group rows by their date:

``` fennel
(local rows
  [{:date "2007-03-03" :product "pineapple"}
   {:date "2007-03-04" :product "pizza"}
   {:date "2007-03-04" :product "pineapple pizza"}
   {:date "2007-03-05" :product "bananas"}])

(assert-eq (itable.group-by #(. $ :date) rows)
           {"2007-03-03"
            [{:date "2007-03-03" :product "pineapple"}]
            "2007-03-04"
            [{:date "2007-03-04" :product "pizza"}
             {:date "2007-03-04" :product "pineapple pizza"}]
            "2007-03-05"
            [{:date "2007-03-05" :product "bananas"}]})
```

## `frequencies`
Function signature:

```
(frequencies t)
```

Return a table of unique entries from table `t` associated to amount
of their appearances.

### Examples

Count each entry of a random letter:

``` fennel
(let [fruits [:banana :banana :apple :strawberry :apple :banana]]
  (assert-eq (itable.frequencies fruits)
             {:banana 3
              :apple 2
              :strawberry 1}))
```

## `first`
Function signature:

```
(first [x])
```

Return the first element from the table.

## `rest`
Function signature:

```
(rest t)
```

Return all but the first elements from the table `t` as a new immutable
table.

## `nthrest`
Function signature:

```
(nthrest t n)
```

Return all elements from `t` starting from `n`.  Returns immutable
table.

## `last`
Function signature:

```
(last t)
```

Return the last element from the table.

## `butlast`
Function signature:

```
(butlast t)
```

Return all elements but the last one from the table as a new
immutable table.

## `join`
Function signature:

```
(join ...)
```

Join arbitrary amount of tables, and return a new immutable table.

### Examples

``` fennel
(local t1 [1 2 3])
(local t2 [4])
(local t3 [5 6])

(assert-eq [1 2 3 4 5 6] (itable.join t1 t2 t3))
(assert-eq t1 [1 2 3])
(assert-eq t2 [4])
(assert-eq t3 [5 6])
```

## `partition`
Function signature:

```
(partition ...)
```

Returns a immutable table of tables of `n` elements, at `step`
offsets.  `step defaults to `n` if not specified.  Additionally
accepts a `pad` collection to complete last partition if it doesn't
have sufficient amount of elements.

### Examples
Partition table into sub-tables of size 3:

``` fennel
(assert-eq (itable.partition 3 [1 2 3 4 5 6])
           [[1 2 3] [4 5 6]])
```

When table doesn't have enough elements to form full partition,
`partition` will not include those:

``` fennel
(assert-eq (itable.partition 2 [1 2 3 4 5]) [[1 2] [3 4]])
```

Partitions can overlap if step is supplied:

``` fennel
(assert-eq (itable.partition 2 1 [1 2 3 4]) [[1 2] [2 3] [3 4]])
```

Additional padding can be used to supply insufficient elements:

``` fennel
(assert-eq (itable.partition 3 3 [-1 -2 -3] [1 2 3 4 5 6 7])
           [[1 2 3] [4 5 6] [7 -1 -2]])
```

## `take`
Function signature:

```
(take n t)
```

Take first `n` elements from table `t` and return a new immutable
table.

### Examples

Take doesn't modify original table:

```fennel
(local t1 [1 2 3 4 5])

(assert-eq [1 2 3] (itable.take 3 t1))
(assert-eq t1 [1 2 3 4 5])
```

## `drop`
Function signature:

```
(drop n t)
```

Drop first `n` elements from table `t` and return a new immutable
table.

### Examples

Take doesn't modify original table:

```fennel
(local t1 [1 2 3 4 5])

(assert-eq [4 5] (itable.drop 3 t1))
(assert-eq t1 [1 2 3 4 5])
```


---

Copyright (C) 2021 Andrey Listopadov

License: [MIT](https://gitlab.com/andreyorst/itable/-/raw/master/LICENSE)


<!-- Generated with Fenneldoc v0.1.6
     https://gitlab.com/andreyorst/fenneldoc -->
