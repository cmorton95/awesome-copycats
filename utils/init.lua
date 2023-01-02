local function lastIndexOf(haystack, needle)
    local i, j
    local k = 0
    repeat
        i = j
        j, k = string.find(haystack, needle, k + 1, true)
    until j == nil

    if i == haystack.length then
        return -1
    end

    return i
end

return { 
    lastIndexOf = lastIndexOf
}