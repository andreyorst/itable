-- -*- buffer-read-only: t -*-
local _local_1_ = table
local pack = _local_1_["pack"]
local sort = _local_1_["sort"]
local concat = _local_1_["concat"]
local remove = _local_1_["remove"]
local move = _local_1_["move"]
local insert = _local_1_["insert"]
local _unpack = (table.unpack or _G.unpack)
local function mtpairs(t)
  local _3_
  do
    local _2_ = getmetatable(t)
    if ((_G.type(_2_) == "table") and (nil ~= (_2_).__pairs)) then
      local p = (_2_).__pairs
      _3_ = p
    elseif true then
      local _ = _2_
      _3_ = pairs
    else
      _3_ = nil
    end
  end
  return _3_(t)
end
local function mtipairs(t)
  local _8_
  do
    local _7_ = getmetatable(t)
    if ((_G.type(_7_) == "table") and (nil ~= (_7_).__ipairs)) then
      local i = (_7_).__ipairs
      _8_ = i
    elseif true then
      local _ = _7_
      _8_ = ipairs
    else
      _8_ = nil
    end
  end
  return _8_(t)
end
local function mtlength(t)
  local _13_
  do
    local _12_ = getmetatable(t)
    if ((_G.type(_12_) == "table") and (nil ~= (_12_).__len)) then
      local l = (_12_).__len
      _13_ = l
    elseif true then
      local _ = _12_
      local function _17_(...)
        return #...
      end
      _13_ = _17_
    else
      _13_ = nil
    end
  end
  return _13_(t)
end
local function copy(t)
  if t then
    local tbl_10_auto = {}
    for k, v in mtpairs(t) do
      local _19_, _20_ = k, v
      if ((nil ~= _19_) and (nil ~= _20_)) then
        local k_11_auto = _19_
        local v_12_auto = _20_
        tbl_10_auto[k_11_auto] = v_12_auto
      else
      end
    end
    return tbl_10_auto
  else
    return nil
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
  local __fennelview
  local function _29_(_241, _242, _243, _244)
    return _242(t, _243, _244)
  end
  __fennelview = _29_
  local function _30_(_241, _242)
    return t[_242]
  end
  local function _31_()
    return error((tostring(proxy) .. " is immutable"), 2)
  end
  return setmetatable(proxy, {__index = _30_, __newindex = _31_, __len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __metatable = {__len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __fennelview = __fennelview}})
end
local function iinsert(t, ...)
  local t0 = copy(t)
  do
    local _32_, _33_, _34_ = select("#", ...), ...
    if (_32_ == 0) then
      error("wrong number of arguments to 'insert'")
    elseif ((_32_ == 1) and true) then
      local _3fv = _33_
      insert(t0, _3fv)
    elseif (true and true and true) then
      local _ = _32_
      local _3fk = _33_
      local _3fv = _34_
      insert(t0, _3fk, _3fv)
    else
    end
  end
  return immutable(t0)
end
local imove
if move then
  local function _36_(src, start, _end, tgt, dest)
    local src0 = copy(src)
    local dest0 = copy(dest)
    return immutable(move(src0, start, _end, tgt, dest0))
  end
  imove = _36_
else
  imove = nil
end
local function ipack(...)
  local function _39_(...)
    local _38_ = {...}
    _38_["n"] = select("#", ...)
    return _38_
  end
  return immutable(_39_(...))
end
local function iremove(t, key)
  local t0 = copy(t)
  local v = remove(t0, key)
  return immutable(t0), v
end
local function iconcat(t, sep, start, _end, serializer, opts)
  local serializer0 = (serializer or tostring)
  local _40_
  do
    local tbl_13_auto = {}
    for _, v in mtipairs(t) do
      tbl_13_auto[(#tbl_13_auto + 1)] = serializer0(v, opts)
    end
    _40_ = tbl_13_auto
  end
  return concat(_40_, sep, start, _end)
end
local function iunpack(t)
  return _unpack(copy(t))
end
local function eq(...)
  local _41_, _42_, _43_ = select("#", ...), ...
  local function _44_(...)
    return true
  end
  if ((_41_ == 0) and _44_(...)) then
    return true
  else
    local function _45_(...)
      return true
    end
    if ((_41_ == 1) and _45_(...)) then
      return true
    elseif ((_41_ == 2) and true and true) then
      local _3fa = _42_
      local _3fb = _43_
      if (_3fa == _3fb) then
        return true
      elseif (function(_46_,_47_,_48_) return (_46_ == _47_) and (_47_ == _48_) end)(type(_3fa),type(_3fb),"table") then
        local res, count_a, count_b = true, 0, 0
        for k, v in mtpairs(_3fa) do
          if not res then break end
          local function _49_(...)
            local res0 = nil
            for k_2a, v0 in mtpairs(_3fb) do
              if res0 then break end
              if eq(k_2a, k) then
                res0 = v0
              else
              end
            end
            return res0
          end
          res = eq(v, _49_(...))
          count_a = (count_a + 1)
        end
        if res then
          for _, _0 in mtpairs(_3fb) do
            count_b = (count_b + 1)
          end
          res = (count_a == count_b)
        else
        end
        return res
      else
        return false
      end
    elseif (true and true and true) then
      local _ = _41_
      local _3fa = _42_
      local _3fb = _43_
      return (eq(_3fa, _3fb) and eq(select(2, ...)))
    else
      return nil
    end
  end
end
local function assoc(t, key, val)
  local function _55_()
    local _54_ = copy(t)
    do end (_54_)[key] = val
    return _54_
  end
  return immutable(_55_())
end
local function assoc_in(t, _56_, val)
  local _arg_57_ = _56_
  local k = _arg_57_[1]
  local ks = {(table.unpack or unpack)(_arg_57_, 2)}
  local t0 = (t or {})
  if next(ks) then
    return assoc(t0, k, assoc_in(((t0)[k] or {}), ks, val))
  else
    return assoc(t0, k, val)
  end
end
local function update(t, key, f)
  local function _60_()
    local _59_ = copy(t)
    do end (_59_)[key] = f(t[key])
    return _59_
  end
  return immutable(_60_())
end
local function update_in(t, _61_, f)
  local _arg_62_ = _61_
  local k = _arg_62_[1]
  local ks = {(table.unpack or unpack)(_arg_62_, 2)}
  local t0 = (t or {})
  if next(ks) then
    return assoc(t0, k, update_in((t0)[k], ks, f))
  else
    return update(t0, k, f)
  end
end
local function deepcopy(x)
  local function deepcopy_2a(x0, seen)
    local _64_ = type(x0)
    if (_64_ == "table") then
      local _65_ = seen[x0]
      if (_65_ == true) then
        return error("immutable tables can't contain self reference", 2)
      elseif true then
        local _ = _65_
        seen[x0] = true
        local function _66_()
          local tbl_10_auto = {}
          for k, v in mtpairs(x0) do
            local _67_, _68_ = deepcopy_2a(k, seen), deepcopy_2a(v, seen)
            if ((nil ~= _67_) and (nil ~= _68_)) then
              local k_11_auto = _67_
              local v_12_auto = _68_
              tbl_10_auto[k_11_auto] = v_12_auto
            else
            end
          end
          return tbl_10_auto
        end
        return immutable(_66_())
      else
        return nil
      end
    elseif true then
      local _ = _64_
      return x0
    else
      return nil
    end
  end
  return deepcopy_2a(x, {})
end
local function first(_72_)
  local _arg_73_ = _72_
  local x = _arg_73_[1]
  return x
end
local function rest(t)
  local _74_ = iremove(t, 1)
  return _74_
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
  local _75_ = iremove(t, mtlength(t))
  return _75_
end
local function join(...)
  local _76_, _77_, _78_ = select("#", ...), ...
  if (_76_ == 0) then
    return nil
  elseif ((_76_ == 1) and true) then
    local _3ft = _77_
    return immutable(copy(_3ft))
  elseif ((_76_ == 2) and true and true) then
    local _3ft1 = _77_
    local _3ft2 = _78_
    local to = copy(_3ft1)
    local from = (_3ft2 or {})
    for _, v in mtipairs(from) do
      insert(to, v)
    end
    return immutable(to)
  elseif (true and true and true) then
    local _ = _76_
    local _3ft1 = _77_
    local _3ft2 = _78_
    return join(join(_3ft1, _3ft2), select(3, ...))
  else
    return nil
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
    local _80_, _81_, _82_, _83_, _84_ = select("#", ...), ...
    local function _85_(...)
      return true
    end
    if ((_80_ == 0) and _85_(...)) then
      return error("wrong amount arguments to 'partition'")
    else
      local function _86_(...)
        return true
      end
      if ((_80_ == 1) and _86_(...)) then
        return error("wrong amount arguments to 'partition'")
      elseif ((_80_ == 2) and true and true) then
        local _3fn = _81_
        local _3ft = _82_
        return partition_2a(_3fn, _3fn, _3ft)
      elseif ((_80_ == 3) and true and true and true) then
        local _3fn = _81_
        local _3fstep = _82_
        local _3ft = _83_
        local p = take(_3fn, _3ft)
        if (_3fn == mtlength(p)) then
          insert(res, p)
          return partition_2a(_3fn, _3fstep, {_unpack(_3ft, (_3fstep + 1))})
        else
          return nil
        end
      elseif (true and true and true and true and true) then
        local _ = _80_
        local _3fn = _81_
        local _3fstep = _82_
        local _3fpad = _83_
        local _3ft = _84_
        local p = take(_3fn, _3ft)
        if (_3fn == mtlength(p)) then
          insert(res, p)
          return partition_2a(_3fn, _3fstep, _3fpad, {_unpack(_3ft, (_3fstep + 1))})
        else
          return insert(res, take(_3fn, join(p, _3fpad)))
        end
      else
        return nil
      end
    end
  end
  partition_2a(...)
  return immutable(res)
end
local function keys(t)
  local function _90_()
    local tbl_13_auto = {}
    for k, _ in mtpairs(t) do
      tbl_13_auto[(#tbl_13_auto + 1)] = k
    end
    return tbl_13_auto
  end
  return immutable(_90_())
end
local function vals(t)
  local function _91_()
    local tbl_13_auto = {}
    for _, v in mtpairs(t) do
      tbl_13_auto[(#tbl_13_auto + 1)] = v
    end
    return tbl_13_auto
  end
  return immutable(_91_())
end
local function group_by(f, t)
  local res = {}
  local ungroupped = {}
  for _, v in mtpairs(t) do
    local k = f(v)
    if (nil ~= k) then
      local _92_ = res[k]
      if (nil ~= _92_) then
        local t_2a = _92_
        insert(t_2a, v)
      elseif true then
        local _0 = _92_
        res[k] = {v}
      else
      end
    else
      insert(ungroupped, v)
    end
  end
  local function _95_()
    local tbl_10_auto = {}
    for k, t0 in mtpairs(res) do
      local _96_, _97_ = k, immutable(t0)
      if ((nil ~= _96_) and (nil ~= _97_)) then
        local k_11_auto = _96_
        local v_12_auto = _97_
        tbl_10_auto[k_11_auto] = v_12_auto
      else
      end
    end
    return tbl_10_auto
  end
  return immutable(_95_()), immutable(ungroupped)
end
local function frequencies(t)
  local res = {}
  for _, v in mtpairs(t) do
    local _99_ = res[v]
    if (nil ~= _99_) then
      local a = _99_
      res[v] = (a + 1)
    elseif true then
      local _0 = _99_
      res[v] = 1
    else
    end
  end
  return immutable(res)
end
local itable
local function _101_(t, f)
  local function _103_()
    local _102_ = copy(t)
    sort(_102_, f)
    return _102_
  end
  return immutable(_103_())
end
itable = {sort = _101_, pack = ipack, unpack = iunpack, concat = iconcat, insert = iinsert, move = imove, remove = iremove, pairs = mtpairs, ipairs = mtipairs, length = mtlength, eq = eq, deepcopy = deepcopy, assoc = assoc, ["assoc-in"] = assoc_in, update = update, ["update-in"] = update_in, keys = keys, vals = vals, ["group-by"] = group_by, frequencies = frequencies, first = first, rest = rest, nthrest = nthrest, last = last, butlast = butlast, join = join, partition = partition, take = take, drop = drop}
local function _104_(_241, _242)
  return immutable(copy(_242))
end
return setmetatable(itable, {__call = _104_, __index = {_MODULE_NAME = "itable", _DESCRIPTION = "`itable` - immutable tables for Lua runtime."}})
