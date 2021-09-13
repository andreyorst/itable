-- -*- buffer-read-only: t -*-
local _local_1_ = table
local concat = _local_1_["concat"]
local insert = _local_1_["insert"]
local move = _local_1_["move"]
local pack = _local_1_["pack"]
local remove = _local_1_["remove"]
local sort = _local_1_["sort"]
local _unpack = (table.unpack or _G.unpack)
local function mtpairs(t)
  local _3_
  do
    local _2_ = getmetatable(t)
    if ((type(_2_) == "table") and (nil ~= (_2_).__pairs)) then
      local p = (_2_).__pairs
      _3_ = p
    else
      local _ = _2_
      _3_ = pairs
    end
  end
  return _3_(t)
end
local function mtipairs(t)
  local _8_
  do
    local _7_ = getmetatable(t)
    if ((type(_7_) == "table") and (nil ~= (_7_).__ipairs)) then
      local i = (_7_).__ipairs
      _8_ = i
    else
      local _ = _7_
      _8_ = ipairs
    end
  end
  return _8_(t)
end
local function mtlength(t)
  local _13_
  do
    local _12_ = getmetatable(t)
    if ((type(_12_) == "table") and (nil ~= (_12_).__len)) then
      local l = (_12_).__len
      _13_ = l
    else
      local _ = _12_
      local function _17_(...)
        return #...
      end
      _13_ = _17_
    end
  end
  return _13_(t)
end
local function copy(t)
  if t then
    local tbl_9_auto = {}
    for k, v in mtpairs(t) do
      local _19_, _20_ = k, v
      if ((nil ~= _19_) and (nil ~= _20_)) then
        local k_10_auto = _19_
        local v_11_auto = _20_
        tbl_9_auto[k_10_auto] = v_11_auto
      end
    end
    return tbl_9_auto
  end
end
local function immutable(t)
  local len = mtlength(t)
  local proxy = {}
  local __len
  local function _23_()
    return len
  end
  __len = _23_
  local __pairs
  local function _24_()
    local function _25_(_, k)
      return next(t, k)
    end
    return _25_, nil, nil
  end
  __pairs = _24_
  local __ipairs
  local function _26_()
    local function _27_(_, k)
      return next(t, k)
    end
    return _27_
  end
  __ipairs = _26_
  local __call
  local function _28_(_241, _242)
    return t[_242]
  end
  __call = _28_
  local function _29_(_241, _242)
    return t[_242]
  end
  local function _30_()
    return error((tostring(proxy) .. " is immutable"), 2)
  end
  return setmetatable(proxy, {__call = __call, __index = _29_, __ipairs = __ipairs, __len = __len, __metatable = {__call = __call, __ipairs = __ipairs, __len = __len, __pairs = __pairs}, __newindex = _30_, __pairs = __pairs})
end
local function iinsert(t, ...)
  local t0 = copy(t)
  do
    local _31_, _32_, _33_ = select("#", ...), ...
    if (_31_ == 0) then
      error("wrong number of arguments to 'insert'")
    elseif ((_31_ == 1) and true) then
      local _3fv = _32_
      insert(t0, _3fv)
    elseif (true and true and true) then
      local _ = _31_
      local _3fk = _32_
      local _3fv = _33_
      insert(t0, _3fk, _3fv)
    end
  end
  return immutable(t0)
end
local imove
if move then
  local function _35_(src, start, _end, tgt, dest)
    local src0 = copy(src)
    local dest0 = copy(dest)
    return immutable(move(src0, start, _end, tgt, dest0))
  end
  imove = _35_
else
imove = nil
end
local function ipack(...)
  local function _38_(...)
    local _37_ = {...}
    _37_["n"] = select("#", ...)
    return _37_
  end
  return immutable(_38_(...))
end
local function iremove(t, key)
  local t0 = copy(t)
  local v = remove(t0, key)
  return immutable(t0), v
end
local function iconcat(t, sep, start, _end, serializer, opts)
  local serializer0 = (serializer or tostring)
  local _39_
  do
    local tbl_12_auto = {}
    for _, v in mtipairs(t) do
      tbl_12_auto[(#tbl_12_auto + 1)] = serializer0(v, opts)
    end
    _39_ = tbl_12_auto
  end
  return concat(_39_, sep, start, _end)
end
local function iunpack(t)
  return _unpack(copy(t))
end
local function eq(...)
  local _40_, _41_, _42_ = select("#", ...), ...
  local function _43_(...)
    return true
  end
  if ((_40_ == 0) and _43_(...)) then
    return true
  else
    local function _44_(...)
      return true
    end
    if ((_40_ == 1) and _44_(...)) then
      return true
    elseif ((_40_ == 2) and true and true) then
      local _3fa = _41_
      local _3fb = _42_
      if (_3fa == _3fb) then
        return true
      elseif (function(_45_,_46_,_47_) return (_45_ == _46_) and (_46_ == _47_) end)(type(_3fa),type(_3fb),"table") then
        local res, count_a, count_b = true, 0, 0
        for k, v in mtpairs(_3fa) do
          if not res then break end
          local function _48_(...)
            local res0 = nil
            for k_2a, v0 in mtpairs(_3fb) do
              if res0 then break end
              if eq(k_2a, k) then
                res0 = v0
              end
            end
            return res0
          end
          res = eq(v, _48_(...))
          count_a = (count_a + 1)
        end
        if res then
          for _, _0 in mtpairs(_3fb) do
            count_b = (count_b + 1)
          end
          res = (count_a == count_b)
        end
        return res
      else
        return false
      end
    elseif (true and true and true) then
      local _ = _40_
      local _3fa = _41_
      local _3fb = _42_
      return (eq(_3fa, _3fb) and eq(select(2, ...)))
    end
  end
end
local function assoc(t, key, val)
  local function _54_()
    local _53_ = copy(t)
    do end (_53_)[key] = val
    return _53_
  end
  return immutable(_54_())
end
local function assoc_in(t, _55_, val)
  local _arg_56_ = _55_
  local k = _arg_56_[1]
  local ks = {(table.unpack or unpack)(_arg_56_, 2)}
  local t0 = (t or {})
  if next(ks) then
    return assoc(t0, k, assoc_in(((t0)[k] or {}), ks, val))
  else
    return assoc(t0, k, val)
  end
end
local function update(t, key, f)
  local function _59_()
    local _58_ = copy(t)
    do end (_58_)[key] = f(t[key])
    return _58_
  end
  return immutable(_59_())
end
local function update_in(t, _60_, f)
  local _arg_61_ = _60_
  local k = _arg_61_[1]
  local ks = {(table.unpack or unpack)(_arg_61_, 2)}
  local t0 = (t or {})
  if next(ks) then
    return assoc(t0, k, update_in((t0)[k], ks, f))
  else
    return update(t0, k, f)
  end
end
local function deepcopy(x)
  local function deepcopy_2a(x0, seen)
    local _63_ = type(x0)
    if (_63_ == "table") then
      local _64_ = seen[x0]
      if (_64_ == true) then
        return error("immutable tables can't contain self reference", 2)
      else
        local _ = _64_
        seen[x0] = true
        local function _65_()
          local tbl_9_auto = {}
          for k, v in mtpairs(x0) do
            local _66_, _67_ = deepcopy_2a(k, seen), deepcopy_2a(v, seen)
            if ((nil ~= _66_) and (nil ~= _67_)) then
              local k_10_auto = _66_
              local v_11_auto = _67_
              tbl_9_auto[k_10_auto] = v_11_auto
            end
          end
          return tbl_9_auto
        end
        return immutable(_65_())
      end
    else
      local _ = _63_
      return x0
    end
  end
  return deepcopy_2a(x, {})
end
local function first(_71_)
  local _arg_72_ = _71_
  local x = _arg_72_[1]
  return x
end
local function rest(t)
  local _73_ = iremove(t, 1)
  return _73_
end
local function nthrest(t, n)
  local t_2a = {}
  for i = (n + 1), mtlength(t) do
    insert(t_2a, t[i])
  end
  return immutable(t_2a)
end
local function last(t)
  return t[mtlength(t)]
end
local function butlast(t)
  local _74_ = iremove(t, mtlength(t))
  return _74_
end
local function join(...)
  local _75_, _76_, _77_ = select("#", ...), ...
  if (_75_ == 0) then
    return nil
  elseif ((_75_ == 1) and true) then
    local _3ft = _76_
    return immutable(copy(_3ft))
  elseif ((_75_ == 2) and true and true) then
    local _3ft1 = _76_
    local _3ft2 = _77_
    local to = copy(_3ft1)
    local from = (_3ft2 or {})
    for _, v in mtipairs(from) do
      insert(to, v)
    end
    return immutable(to)
  elseif (true and true and true) then
    local _ = _75_
    local _3ft1 = _76_
    local _3ft2 = _77_
    return join(join(_3ft1, _3ft2), select(3, ...))
  end
end
local function take(n, t)
  local t_2a = {}
  for i = 1, n do
    insert(t_2a, t[i])
  end
  return immutable(t_2a)
end
local function drop(n, t)
  return nthrest(t, n)
end
local function partition(...)
  local res = {}
  local function partition_2a(...)
    local _79_, _80_, _81_, _82_, _83_ = select("#", ...), ...
    local function _84_(...)
      return true
    end
    if ((_79_ == 0) and _84_(...)) then
      return error("wrong amount arguments to 'partition'")
    else
      local function _85_(...)
        return true
      end
      if ((_79_ == 1) and _85_(...)) then
        return error("wrong amount arguments to 'partition'")
      elseif ((_79_ == 2) and true and true) then
        local _3fn = _80_
        local _3ft = _81_
        return partition_2a(_3fn, _3fn, _3ft)
      elseif ((_79_ == 3) and true and true and true) then
        local _3fn = _80_
        local _3fstep = _81_
        local _3ft = _82_
        local p = take(_3fn, _3ft)
        if (_3fn == mtlength(p)) then
          insert(res, p)
          return partition_2a(_3fn, _3fstep, {_unpack(_3ft, (_3fstep + 1))})
        end
      elseif (true and true and true and true and true) then
        local _ = _79_
        local _3fn = _80_
        local _3fstep = _81_
        local _3fpad = _82_
        local _3ft = _83_
        local p = take(_3fn, _3ft)
        if (_3fn == mtlength(p)) then
          insert(res, p)
          return partition_2a(_3fn, _3fstep, _3fpad, {_unpack(_3ft, (_3fstep + 1))})
        else
          return insert(res, take(_3fn, join(p, _3fpad)))
        end
      end
    end
  end
  partition_2a(...)
  return immutable(res)
end
local function keys(t)
  local function _89_()
    local tbl_12_auto = {}
    for k, _ in mtpairs(t) do
      tbl_12_auto[(#tbl_12_auto + 1)] = k
    end
    return tbl_12_auto
  end
  return immutable(_89_())
end
local function vals(t)
  local function _90_()
    local tbl_12_auto = {}
    for _, v in mtpairs(t) do
      tbl_12_auto[(#tbl_12_auto + 1)] = v
    end
    return tbl_12_auto
  end
  return immutable(_90_())
end
local function group_by(f, t)
  local res = {}
  local ungroupped = {}
  for _, v in mtpairs(t) do
    local k = f(v)
    if (nil ~= k) then
      local _91_ = res[k]
      if (nil ~= _91_) then
        local t_2a = _91_
        insert(t_2a, v)
      else
        local _0 = _91_
        res[k] = {v}
      end
    else
      insert(ungroupped, v)
    end
  end
  local function _94_()
    local tbl_9_auto = {}
    for k, t0 in mtpairs(res) do
      local _95_, _96_ = k, immutable(t0)
      if ((nil ~= _95_) and (nil ~= _96_)) then
        local k_10_auto = _95_
        local v_11_auto = _96_
        tbl_9_auto[k_10_auto] = v_11_auto
      end
    end
    return tbl_9_auto
  end
  return immutable(_94_()), immutable(ungroupped)
end
local function frequencies(t)
  local res = {}
  for _, v in mtpairs(t) do
    local _98_ = res[v]
    if (nil ~= _98_) then
      local a = _98_
      res[v] = (a + 1)
    else
      local _0 = _98_
      res[v] = 1
    end
  end
  return immutable(res)
end
local itable
local function _100_(t, f)
  local function _102_()
    local _101_ = copy(t)
    sort(_101_, f)
    return _101_
  end
  return immutable(_102_())
end
itable = {["assoc-in"] = assoc_in, ["group-by"] = group_by, ["update-in"] = update_in, assoc = assoc, butlast = butlast, concat = iconcat, deepcopy = deepcopy, drop = drop, eq = eq, first = first, frequencies = frequencies, insert = iinsert, ipairs = mtipairs, join = join, keys = keys, last = last, length = mtlength, move = imove, nthrest = nthrest, pack = ipack, pairs = mtpairs, partition = partition, remove = iremove, rest = rest, sort = _100_, take = take, unpack = iunpack, update = update, vals = vals}
local function _103_(_241, _242)
  return immutable(copy(_242))
end
return setmetatable(itable, {__call = _103_, __index = {_DESCRIPTION = "`itable` - immutable tables for Lua runtime.", _MODULE_NAME = "itable"}})
