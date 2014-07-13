#!/usr/bin/env lua

-- script to update names of all file in a specific directory with uppercase or lowercase
-- author: Evandro Leopoldino Gonçalves <evandrolgoncalves@gmail.com>
-- https://github.com/evandrolg
-- Licence: MIT

require 'lfs'

-- split function
-- http://lua-users.org/wiki/SplitJoin
function split(str, pat)
   local t = {} 
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
        table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function update_filenames(dir, m)
  local method = string.upper
  local is_lower = m == '-l' or m == '--lower'

  if is_lower then method = string.lower end

  for filename in lfs.dir(dir) do
    new_file = method(string.gsub(filename, ' ', '-'))
    os.rename(dir .. filename, dir .. new_file)
  end

  print('the files were updated successfully!')
end

function is_dir(index)
  return not not (string.find(arg[index], '^(-d)=') 
             or string.find(arg[index], '^(--directory)='))
end

function get_value(str)
  local element = split(str, '=')
  return element[2]
end

function main()
  local param_dir = arg[2]
  local param_method = arg[1] 

  if is_dir(1) then
    param_dir = arg[1]
    param_method = arg[2]
  end

  local dir = get_value(param_dir) .. '/'

  update_filenames(dir, param_method)
end

main()
