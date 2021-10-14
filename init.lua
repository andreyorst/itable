-- -*- buffer-read-only: t -*-
 local _local_1_ = table local table_pack = _local_1_["pack"]
 local table_sort = _local_1_["sort"]
 local table_concat = _local_1_["concat"]
 local table_remove = _local_1_["remove"]
 local table_move = _local_1_["move"]
 local table_insert = _local_1_["insert"]


 local table_unpack = (table.unpack or _G.unpack)
 local lua_pairs = pairs
 local lua_ipairs = ipairs

 local function pairs(t)





 local _3_ do local _2_ = getmetatable(t) if ((_G.type(_2_) == "table") and (nil ~= (_2_).__pairs)) then local p = (_2_).__pairs
 _3_ = p elseif true then local _ = _2_
 _3_ = lua_pairs else _3_ = nil end end return _3_(t) end

 local function ipairs(t)

 local _8_ do local _7_ = getmetatable(t) if ((_G.type(_7_) == "table") and (nil ~= (_7_).__ipairs)) then local i = (_7_).__ipairs
 _8_ = i elseif true then local _ = _7_
 _8_ = lua_ipairs else _8_ = nil end end return _8_(t) end

 local function length_2a(t)

 local _13_ do local _12_ = getmetatable(t) if ((_G.type(_12_) == "table") and (nil ~= (_12_).__len)) then local l = (_12_).__len
 _13_ = l elseif true then local _ = _12_
 local function _17_(...) return #... end _13_ = _17_ else _13_ = nil end end return _13_(t) end

 local function copy(t)


 if t then local tbl_11_auto = {}
 for k, v in pairs(t) do
 local _19_, _20_ = k, v if ((nil ~= _19_) and (nil ~= _20_)) then local k_12_auto = _19_ local v_13_auto = _20_ tbl_11_auto[k_12_auto] = v_13_auto else end end return tbl_11_auto else return nil end end

 local function immutable(t)




 local len = length_2a(t)
 local proxy = {} local __len
 local function _23_() return len end __len = _23_ local __index
 local function _24_(_241, _242) return t[_242] end __index = _24_ local __newindex
 local function _25_() return error((tostring(proxy) .. " is immutable"), 2) end __newindex = _25_ local __pairs
 local function _26_() local function _27_(_, k) return next(t, k) end return _27_, nil, nil end __pairs = _26_ local __ipairs
 local function _28_() local function _29_(_, k) return next(t, k) end return _29_ end __ipairs = _28_ local __call
 local function _30_(_241, _242) return t[_242] end __call = _30_ local __fennelview
 local function _31_(_241, _242, _243, _244) return _242(t, _243, _244) end __fennelview = _31_ local __fennelrest
 local function _32_(_241, _242) return immutable({table_unpack(t, _242)}) end __fennelrest = _32_
 return setmetatable(proxy, {__index = __index, __newindex = __newindex, __len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __metatable = {__len = __len, __pairs = __pairs, __ipairs = __ipairs, __call = __call, __fennelrest = __fennelrest, __fennelview = __fennelview}}) end



















 local function insert(t, ...)






















 local t0 = copy(t)
 do local _33_, _34_, _35_ = select("#", ...), ... if (_33_ == 0) then
 error("wrong number of arguments to 'insert'") elseif ((_33_ == 1) and true) then local _3fv = _34_
 table_insert(t0, _3fv) elseif (true and true and true) then local _ = _33_ local _3fk = _34_ local _3fv = _35_
 table_insert(t0, _3fk, _3fv) else end end
 return immutable(t0) end


 local move
 if table_move then
 local function _37_(src, start, _end, tgt, dest)

















 local src0 = copy(src)
 local dest0 = copy(dest)
 return immutable(table_move(src0, start, _end, tgt, dest0)) end move = _37_ else move = nil end




 local function pack(...)


 local function _40_(...) local _39_ = {...} _39_["n"] = select("#", ...) return _39_ end return immutable(_40_(...)) end



 local function remove(t, key)






















 local t0 = copy(t)
 local v = table_remove(t0, key)
 return immutable(t0), v end


 local function concat(t, sep, start, _end, serializer, opts)














 local serializer0 = (serializer or tostring)
 local _41_ do local tbl_14_auto = {} local i_15_auto = #tbl_14_auto for _, v in ipairs(t) do
 local val_16_auto = serializer0(v, opts) if (nil ~= val_16_auto) then i_15_auto = (i_15_auto + 1) do end (tbl_14_auto)[i_15_auto] = val_16_auto else end end _41_ = tbl_14_auto end return table_concat(_41_, sep, start, _end) end


 local function unpack(t)




 return table_unpack(copy(t)) end




 local function eq(...)


















 local _43_, _44_, _45_ = select("#", ...), ... local function _46_(...) return true end if ((_43_ == 0) and _46_(...)) then return true else local function _47_(...) return true end if ((_43_ == 1) and _47_(...)) then return true elseif ((_43_ == 2) and true and true) then local _3fa = _44_ local _3fb = _45_



 if (_3fa == _3fb) then return true elseif (function(_48_,_49_,_50_) return (_48_ == _49_) and (_49_ == _50_) end)(type(_3fa),type(_3fb),"table") then


 local res, count_a, count_b = true, 0, 0
 for k, v in pairs(_3fa) do if not res then break end
 local function _51_(...) local res0 = nil
 for k_2a, v0 in pairs(_3fb) do if res0 then break end
 if eq(k_2a, k) then
 res0 = v0 else end end
 return res0 end res = eq(v, _51_(...))
 count_a = (count_a + 1) end
 if res then
 for _, _0 in pairs(_3fb) do
 count_b = (count_b + 1) end
 res = (count_a == count_b) else end
 return res else return false end elseif (true and true and true) then local _ = _43_ local _3fa = _44_ local _3fb = _45_


 return (eq(_3fa, _3fb) and eq(select(2, ...))) else return nil end end end


 local function assoc(t, key, val)








 local function _57_() local _56_ = copy(t) do end (_56_)[key] = val return _56_ end return immutable(_57_()) end


 local function assoc_in(t, _58_, val) local _arg_59_ = _58_ local k = _arg_59_[1] local ks = (function (t, k) local mt = getmetatable(t) if "table" == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) else return {(table.unpack or unpack)(t, k)} end end)(_arg_59_, 2)




















 local t0 = (t or {})
 if next(ks) then
 return assoc(t0, k, assoc_in(((t0)[k] or {}), ks, val)) else
 return assoc(t0, k, val) end end


 local function update(t, key, f)













 local function _62_() local _61_ = copy(t) do end (_61_)[key] = f(t[key]) return _61_ end return immutable(_62_()) end


 local function update_in(t, _63_, f) local _arg_64_ = _63_ local k = _arg_64_[1] local ks = (function (t, k) local mt = getmetatable(t) if "table" == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) else return {(table.unpack or unpack)(t, k)} end end)(_arg_64_, 2)


















 local t0 = (t or {})
 if next(ks) then
 return assoc(t0, k, update_in((t0)[k], ks, f)) else
 return update(t0, k, f) end end


 local function deepcopy(x)


 local function deepcopy_2a(x0, seen)
 local _66_ = type(x0) if (_66_ == "table") then
 local _67_ = seen[x0] if (_67_ == true) then
 return error("immutable tables can't contain self reference", 2) elseif true then local _ = _67_
 seen[x0] = true
 local function _68_() local tbl_11_auto = {} for k, v in pairs(x0) do
 local _69_, _70_ = deepcopy_2a(k, seen), deepcopy_2a(v, seen) if ((nil ~= _69_) and (nil ~= _70_)) then local k_12_auto = _69_ local v_13_auto = _70_ tbl_11_auto[k_12_auto] = v_13_auto else end end return tbl_11_auto end return immutable(_68_()) else return nil end elseif true then local _ = _66_


 return x0 else return nil end end
 return deepcopy_2a(x, {}) end


 local function first(_74_) local _arg_75_ = _74_ local x = _arg_75_[1]

 return x end


 local function rest(t)


 local _76_ = remove(t, 1) return _76_ end


 local function nthrest(t, n)


 local t_2a = {}
 for i = (n + 1), length_2a(t) do
 table_insert(t_2a, t[i]) end
 return immutable(t_2a) end


 local function last(t)

 return t[length_2a(t)] end


 local function butlast(t)


 local _77_ = remove(t, length_2a(t)) return _77_ end


 local function join(...)














 local _78_, _79_, _80_ = select("#", ...), ... if (_78_ == 0) then
 return nil elseif ((_78_ == 1) and true) then local _3ft = _79_
 return immutable(copy(_3ft)) elseif ((_78_ == 2) and true and true) then local _3ft1 = _79_ local _3ft2 = _80_
 local to = copy(_3ft1)
 local from = (_3ft2 or {})
 for _, v in ipairs(from) do
 table_insert(to, v) end
 return immutable(to) elseif (true and true and true) then local _ = _78_ local _3ft1 = _79_ local _3ft2 = _80_
 return join(join(_3ft1, _3ft2), select(3, ...)) else return nil end end


 local function take(n, t)













 local t_2a = {}
 for i = 1, n do
 table_insert(t_2a, t[i]) end
 return immutable(t_2a) end


 local function drop(n, t)













 return nthrest(t, n) end


 local function partition(...)
































 local res = {}
 local function partition_2a(...)
 local _82_, _83_, _84_, _85_, _86_ = select("#", ...), ... local function _87_(...) return true end if ((_82_ == 0) and _87_(...)) then
 return error("wrong amount arguments to 'partition'") else local function _88_(...) return true end if ((_82_ == 1) and _88_(...)) then return error("wrong amount arguments to 'partition'") elseif ((_82_ == 2) and true and true) then local _3fn = _83_ local _3ft = _84_
 return partition_2a(_3fn, _3fn, _3ft) elseif ((_82_ == 3) and true and true and true) then local _3fn = _83_ local _3fstep = _84_ local _3ft = _85_
 local p = take(_3fn, _3ft)
 if (_3fn == length_2a(p)) then
 table_insert(res, p)
 return partition_2a(_3fn, _3fstep, {table_unpack(_3ft, (_3fstep + 1))}) else return nil end elseif (true and true and true and true and true) then local _ = _82_ local _3fn = _83_ local _3fstep = _84_ local _3fpad = _85_ local _3ft = _86_
 local p = take(_3fn, _3ft)
 if (_3fn == length_2a(p)) then
 table_insert(res, p)
 return partition_2a(_3fn, _3fstep, _3fpad, {table_unpack(_3ft, (_3fstep + 1))}) else
 return table_insert(res, take(_3fn, join(p, _3fpad))) end else return nil end end end
 partition_2a(...)
 return immutable(res) end


 local function keys(t)

 local function _92_() local tbl_14_auto = {} local i_15_auto = #tbl_14_auto for k, _ in pairs(t) do local val_16_auto = k if (nil ~= val_16_auto) then i_15_auto = (i_15_auto + 1) do end (tbl_14_auto)[i_15_auto] = val_16_auto else end end return tbl_14_auto end return immutable(_92_()) end



 local function vals(t)

 local function _94_() local tbl_14_auto = {} local i_15_auto = #tbl_14_auto for _, v in pairs(t) do local val_16_auto = v if (nil ~= val_16_auto) then i_15_auto = (i_15_auto + 1) do end (tbl_14_auto)[i_15_auto] = val_16_auto else end end return tbl_14_auto end return immutable(_94_()) end



 local function group_by(f, t)

























 local res = {}
 local ungroupped = {}
 for _, v in pairs(t) do
 local k = f(v)
 if (nil ~= k) then
 local _96_ = res[k] if (nil ~= _96_) then local t_2a = _96_
 table_insert(t_2a, v) elseif true then local _0 = _96_
 res[k] = {v} else end else
 table_insert(ungroupped, v) end end
 local function _99_() local tbl_11_auto = {} for k, t0 in pairs(res) do
 local _100_, _101_ = k, immutable(t0) if ((nil ~= _100_) and (nil ~= _101_)) then local k_12_auto = _100_ local v_13_auto = _101_ tbl_11_auto[k_12_auto] = v_13_auto else end end return tbl_11_auto end return immutable(_99_()), immutable(ungroupped) end




 local function frequencies(t)














 local res = {}
 for _, v in pairs(t) do
 local _103_ = res[v] if (nil ~= _103_) then local a = _103_
 res[v] = (a + 1) elseif true then local _0 = _103_
 res[v] = 1 else end end
 return immutable(res) end


 local itable
 local function _105_(t, f)


 local function _107_() local _106_ = copy(t) table_sort(_106_, f) return _106_ end return immutable(_107_()) end itable = {sort = _105_, pack = pack, unpack = unpack, concat = concat, insert = insert, move = move, remove = remove, pairs = pairs, ipairs = ipairs, length = length_2a, eq = eq, deepcopy = deepcopy, assoc = assoc, ["assoc-in"] = assoc_in, update = update, ["update-in"] = update_in, keys = keys, vals = vals, ["group-by"] = group_by, frequencies = frequencies, first = first, rest = rest, nthrest = nthrest, last = last, butlast = butlast, join = join, partition = partition, take = take, drop = drop}


































 local function _108_(_241, _242) return immutable(copy(_242)) end return setmetatable(itable, {__call = _108_, __index = {_MODULE_NAME = "itable", _DESCRIPTION = "`itable` - immutable tables for Lua runtime."}})
