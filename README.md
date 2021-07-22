# itable

Immutable tables for Lua runtime.

## Installation

Clone this library to your project:

    git clone https://gitlab.com/andreyorst/itable.git

## Rationale

Tables in Lua are mutable by default, and the `table` module from the standard library almost exclusively consists of impure functions.
The reason behind it is partially related to garbage collection in Lua - it wasn't optimized for cleaning lots of small objects, and could result in a big GC pauses.
Lua 5.4 introduced generational garbage collector, which efficiently works with a lot of objects that can be cleaned early.

Immutable tables are much more reliable, as those can be shared without worrying that the values may change.
Not mutating tables is an option, but there's no guarantees that some function won't alter a table it was passed, either by mistake, or intentionally.
This library is meant as (sort of) a drop-in replacement for Lua's own `table` module.
It provides all functions from `table` module that now produce immutable tables, plus addition functions for more convenient immutable table manipulation.

## Design

The `itable` module contains all functions from `table` module, which produce immutable tables instead of modifying tables in place, plus a lot of additional functions for table manipulation.
Any functions that produce new inner tables ensure that these inner tables are also immutable.
Module table has a `__call` metamethod, which is used as a constructor for immutable tables:

``` lua
local itable = require "itable"

local t = itable{1, 2, 3}
```

However, note that if the table passed has inner tables, `itable` constructor won't make those immutable.
For that purpose use `deepcopy` constructor:

``` lua
local t1 = itable{numbers = {1, 2, 3}, letters = {"a", "b", "c"}}
-- can still mutate t1.numbers and t1.letters
local t2 = deepcopy{numbers = {1, 2, 3}, letters = {"a", "b", "c"}}
-- can't mutate inner tables
```

### Differences from Lua's `table` module

Apart from making all functions return a new immutable table, some functions were modified for convenience.

#### `itable.concat`

`table.concat` expects only numbers and strings in the concatenated table, which often causes runtime errors.

`itable.concat` invokes `tostring` on all elements by default, and accepts optional function to use instead of `tostring`, and a set of options for that function.
For example:

``` lua
local inspect = require "inspect" -- https://github.com/kikito/inspect.lua
local t = {1, 2, {a = 1, b = 2}}

table.concat(t, ", ")
-- invalid value (table) at index 3 in table for 'concat'
itable.concat(t, ", ")
-- 1, 2, table: 0x7c72639b80
itable.concat(t, ", ", nil, nil, inspect, {newline = " ", indent = ""})
-- 1, 2, { a = 1, b = 2 }
```

#### `itable.remove`

`table.remove` returns the value associated with the removed key.

`itable.remove` returns a new table as its first value, and the removed value as a second value:

``` lua
local t1 = {"a", "b", "c"}
local t2, v = itable.remove(t1, 2)
-- t1 left intact {"a", "b", "c"}
-- t2 is {"a", "c"}, v is "b"
-- t2 is also immutable
```

In addition to the standard Lua set of functions from `table` module, `itable` provides a lot of extra functions for table manipulation.
Descriptions, and examples can be found in the [docs](doc/src/itable.md)

### Note on the self reference

Eager immutable tables can't contain any form of self reference, so is impossible to create a cyclic table with `itable` constructor.
The `deepcopy` constructor, which produces deep immutable copies of mutable tables, will throw error on detecting a cycle.

When converting existing cyclic table with `itable` constructor, the resulting table will be immutable on the first level, but will contain a cycle to the original table:

``` lua
local inspect = require "inspect"

local cyclic = {}
cyclic['cycle'] = cyclic

inspect(itable(cyclic))
--[[
{
  cycle = <1>{
    cycle = <table 1>
  },
  <metatable> = {}
}
]]
```

## Development

This library is written using the [Fennel programming language](https://fennel-lang.org) and compiled to Lua.
The `init.lua` file is not meant for hand editing.
For testing purposes a `fennel-test` library is used as a git submodule.
It's not strictly required to write Fennel unless you're submitting a merge request or sending a patch - you can suggest additions using Lua, and I'll convert this to Fennel.

## Documentation

The documentation is auto-generated with [Fenneldoc](https://gitlab.com/andreyorst/fenneldoc) and can be found [here](https://gitlab.com/andreyorst/itable/-/blob/main/doc/src/itable.md).

## Contributing

Please do.
You can report issues or feature request at [project's GitLab repository](https://gitlab.com/andreyorst/itable).
Consider reading [contribution guidelines](https://gitlab.com/andreyorst/itable/-/blob/master/CONTRIBUTING.md) beforehand.

<!--  LocalWords:  metamethod metatable Lua metamethods itable GC
      LocalWords:  Lua's GitLab submodule
 -->
