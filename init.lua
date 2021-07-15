-- -*- buffer-read-only: t -*-
local _local_1_ = table
local concat = _local_1_["concat"]
local insert = _local_1_["insert"]
local move = _local_1_["move"]
local pack = _local_1_["pack"]
local remove = _local_1_["remove"]
local sort = _local_1_["sort"]
local unpack = _local_1_["unpack"]
local function copy(t)
  if t then
    local tbl_9_auto = {}
    for k, v in pairs(t) do
      local _2_, _3_ = k, v
      if ((nil ~= _2_) and (nil ~= _3_)) then
        local k_10_auto = _2_
        local v_11_auto = _3_
        tbl_9_auto[k_10_auto] = v_11_auto
      end
    end
    return tbl_9_auto
  end
end
local immutable_mt = {}
local function immutable(t)
  local len = #t
  local proxy = {}
  local function _6_(_241, _242)
    return t[_242]
  end
  local function _7_(_241, _242)
    return t[_242]
  end
  local function _8_()
    local function _9_(_, k)
      return next(t, k)
    end
    return _9_
  end
  local function _10_()
    return len
  end
  local function _11_()
    return error((tostring(proxy) .. " is immutable"), 2)
  end
  local function _12_()
    local function _13_(_, k)
      return next(t, k)
    end
    return _13_, nil, nil
  end
  return setmetatable(proxy, {__call = _6_, __index = _7_, __ipairs = _8_, __len = _10_, __metatable = immutable_mt, __newindex = _11_, __pairs = _12_})
end
local function iinsert(t, ...)
  local t0 = copy(t)
  do
    local _14_, _15_, _16_ = select("#", ...), ...
    if (_14_ == 0) then
      error("wrong number of arguments to 'insert'")
    elseif ((_14_ == 1) and true) then
      local _3fv = _15_
      insert(t0, _3fv)
    elseif (true and true and true) then
      local _ = _14_
      local _3fk = _15_
      local _3fv = _16_
      insert(t0, _3fk, _3fv)
    end
  end
  return immutable(t0)
end
local imove
if move then
  local function _18_(src, start, _end, tgt, dest)
    local src0 = copy(src)
    local dest0 = copy(dest)
    return immutable(move(src0, start, _end, tgt, dest0))
  end
  imove = _18_
else
imove = nil
end
local function iremove(t, key)
  local t0 = copy(t)
  local v = remove(t0, key)
  return immutable(t0), v
end
local function iconcat(t, sep, start, _end, serializer, opts)
  local serializer0 = (serializer or tostring)
  local _20_
  do
    local tbl_12_auto = {}
    for _, v in ipairs(t) do
      tbl_12_auto[(#tbl_12_auto + 1)] = serializer0(v, opts)
    end
    _20_ = tbl_12_auto
  end
  return concat(_20_, sep, start, _end)
end
local function iunpack(t)
  return (unpack or _G.unpack)(copy(t))
end
local function eq(...)
  local _21_, _22_, _23_ = select("#", ...), ...
  local function _24_(...)
    return true
  end
  if ((_21_ == 0) and _24_(...)) then
    return true
  else
    local function _25_(...)
      return true
    end
    if ((_21_ == 1) and _25_(...)) then
      return true
    elseif ((_21_ == 2) and true and true) then
      local _3fa = _22_
      local _3fb = _23_
      if (_3fa == _3fb) then
        return true
      elseif (function(_26_,_27_,_28_) return (_26_ == _27_) and (_27_ == _28_) end)(type(_3fa),type(_3fb),"table") then
        local res, count_a, count_b = true, 0, 0
        for k, v in pairs(_3fa) do
          if not res then break end
          local function _29_(...)
            local res0 = nil
            for k_2a, v0 in pairs(_3fb) do
              if res0 then break end
              if eq(k_2a, k) then
                res0 = v0
              end
            end
            return res0
          end
          res = eq(v, _29_(...))
          count_a = (count_a + 1)
        end
        if res then
          for _, _0 in pairs(_3fb) do
            count_b = (count_b + 1)
          end
          res = (count_a == count_b)
        end
        return res
      else
        return false
      end
    elseif (true and true and true) then
      local _ = _21_
      local _3fa = _22_
      local _3fb = _23_
      return (eq(_3fa, _3fb) and eq(select(2, ...)))
    end
  end
end
local function assoc(t, key, val)
  local function _35_()
    local _34_ = copy(t)
    do end (_34_)[key] = val
    return _34_
  end
  return immutable(_35_())
end
local function assoc_in(t, _36_, val)
  local _arg_37_ = _36_
  local k = _arg_37_[1]
  local ks = {(table.unpack or unpack)(_arg_37_, 2)}
  local t0 = (t or {})
  if next(ks) then
    return assoc(t0, k, assoc_in(((t0)[k] or {}), ks, val))
  else
    return assoc(t0, k, val)
  end
end
local function update(t, key, f)
  local function _40_()
    local _39_ = copy(t)
    do end (_39_)[key] = f(t[key])
    return _39_
  end
  return immutable(_40_())
end
local function update_in(t, _41_, f)
  local _arg_42_ = _41_
  local k = _arg_42_[1]
  local ks = {(table.unpack or unpack)(_arg_42_, 2)}
  local t0 = (t or {})
  if next(ks) then
    return assoc(t0, k, update_in((t0)[k], ks, f))
  else
    return update(t0, k, f)
  end
end
local function deepcopy(x)
  local function deepcopy_2a(x0, seen)
    local _44_ = type(x0)
    if (_44_ == "table") then
      local _45_ = seen[x0]
      if (_45_ == true) then
        return error("immutable tables can't contain self reference", 2)
      else
        local _ = _45_
        seen[x0] = true
        local function _46_()
          local tbl_9_auto = {}
          for k, v in pairs(x0) do
            local _47_, _48_ = deepcopy_2a(k, seen), deepcopy_2a(v, seen)
            if ((nil ~= _47_) and (nil ~= _48_)) then
              local k_10_auto = _47_
              local v_11_auto = _48_
              tbl_9_auto[k_10_auto] = v_11_auto
            end
          end
          return tbl_9_auto
        end
        return immutable(_46_())
      end
    else
      local _ = _44_
      return x0
    end
  end
  return deepcopy_2a(x, {})
end
local function first(_52_)
  local _arg_53_ = _52_
  local x = _arg_53_[1]
  return x
end
local function rest(t)
  return iremove(t, 1)
end
local function nthrest(t, n)
  local t_2a = {}
  for i = (n + 1), #t do
    insert(t_2a, t[i])
  end
  return immutable(t_2a)
end
local function last(t)
  return t[#t]
end
local function butlast(t)
  local _54_ = iremove(t, #t)
  return _54_
end
local function join(...)
  local _55_, _56_, _57_ = select("#", ...), ...
  if (_55_ == 0) then
    return nil
  elseif ((_55_ == 1) and true) then
    local _3ft = _56_
    return immutable(copy(_3ft))
  elseif ((_55_ == 2) and true and true) then
    local _3ft1 = _56_
    local _3ft2 = _57_
    local to = copy(_3ft1)
    local from = (_3ft2 or {})
    for _, v in ipairs(from) do
      insert(to, v)
    end
    return immutable(to)
  elseif (true and true and true) then
    local _ = _55_
    local _3ft1 = _56_
    local _3ft2 = _57_
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
    local _59_, _60_, _61_, _62_, _63_ = select("#", ...), ...
    local function _64_(...)
      return true
    end
    if ((_59_ == 0) and _64_(...)) then
      return error("wrong amount arguments to 'partition'")
    else
      local function _65_(...)
        return true
      end
      if ((_59_ == 1) and _65_(...)) then
        return error("wrong amount arguments to 'partition'")
      elseif ((_59_ == 2) and true and true) then
        local _3fn = _60_
        local _3ft = _61_
        return partition_2a(_3fn, _3fn, _3ft)
      elseif ((_59_ == 3) and true and true and true) then
        local _3fn = _60_
        local _3fstep = _61_
        local _3ft = _62_
        local p = take(_3fn, _3ft)
        if (_3fn == #p) then
          insert(res, p)
          return partition_2a(_3fn, _3fstep, {unpack(_3ft, (_3fstep + 1))})
        end
      elseif (true and true and true and true and true) then
        local _ = _59_
        local _3fn = _60_
        local _3fstep = _61_
        local _3fpad = _62_
        local _3ft = _63_
        local p = take(_3fn, _3ft)
        if (_3fn == #p) then
          insert(res, p)
          return partition_2a(_3fn, _3fstep, _3fpad, {unpack(_3ft, (_3fstep + 1))})
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
  local function _69_()
    local tbl_12_auto = {}
    for k, _ in pairs(t) do
      tbl_12_auto[(#tbl_12_auto + 1)] = k
    end
    return tbl_12_auto
  end
  return immutable(_69_())
end
local function vals(t)
  local function _70_()
    local tbl_12_auto = {}
    for _, v in pairs(t) do
      tbl_12_auto[(#tbl_12_auto + 1)] = v
    end
    return tbl_12_auto
  end
  return immutable(_70_())
end
local function group_by(f, t)
  local res = {}
  local ungroupped = {}
  for _, v in pairs(t) do
    local k = f(v)
    if (nil ~= k) then
      local _71_ = res[k]
      if (nil ~= _71_) then
        local t_2a = _71_
        insert(t_2a, v)
      else
        local _0 = _71_
        res[k] = {v}
      end
    else
      insert(ungroupped, v)
    end
  end
  local function _74_()
    local tbl_9_auto = {}
    for k, t0 in pairs(res) do
      local _75_, _76_ = k, immutable(t0)
      if ((nil ~= _75_) and (nil ~= _76_)) then
        local k_10_auto = _75_
        local v_11_auto = _76_
        tbl_9_auto[k_10_auto] = v_11_auto
      end
    end
    return tbl_9_auto
  end
  return immutable(_74_()), immutable(ungroupped)
end
local function frequencies(t)
  local res = {}
  for _, v in pairs(t) do
    local _78_ = res[v]
    if (nil ~= _78_) then
      local a = _78_
      res[v] = (a + 1)
    else
      local _0 = _78_
      res[v] = 1
    end
  end
  return immutable(res)
end
local itable
local function _80_(...)
  return immutable(pack(...))
end
local function _81_(t, f)
  local function _83_()
    local _82_ = copy(t)
    sort(_82_, f)
    return _82_
  end
  return immutable(_83_())
end
itable = {["assoc-in"] = assoc_in, ["group-by"] = group_by, ["update-in"] = update_in, assoc = assoc, butlast = butlast, concat = iconcat, deepcopy = deepcopy, drop = drop, eq = eq, first = first, frequencies = frequencies, insert = iinsert, join = join, keys = keys, last = last, move = imove, nthrest = nthrest, pack = _80_, partition = partition, remove = iremove, rest = rest, sort = _81_, take = take, unpack = iunpack, update = update, vals = vals}
local function _84_(_241, _242)
  return immutable(copy(_242))
end
return setmetatable(itable, {__call = _84_, __index = {_DESCRIPTION = "`itable` - immutable tables for Lua runtime.", _MODULE_NAME = "itable"}})
