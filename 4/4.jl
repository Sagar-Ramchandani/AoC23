using DelimitedFiles
function getData()
    return string.(readdlm(
        IOBuffer(replace(read("data.txt", String), ":" => "|")), '|'))
    #IOBuffer(replace(read("test.txt", String), ":" => "|")), '|'))
end

function getMatches(card)
    winning = map((x) -> parse(Int64, x), filter(!isempty, split(card[2], " ")))
    hand = map((x) -> parse(Int64, x), filter(!isempty, split(card[3], " ")))
    matches = 0
    for i in hand
        if i in winning
            matches += 1
        end
    end
    return matches
end

function getMatchPoints(matches)
    matchPoints = 0
    if matches > 0
        matchPoints = 2^(matches - 1)
    end
    return matchPoints
end

function main()
    return sum(getMatchPoints.(getMatches.(eachrow(getData()))))
end

function mainCopies()
    data = getData()
    nCards = size(data, 1)
    copies = ones(Int64, nCards)
    matches = getMatches.(eachrow(data))
    for (i, j) in enumerate(matches)
        currentCopies = copies[i]
        while j > 0
            j -= 1
            i += 1
            copies[i] += currentCopies
        end
    end
    return sum(copies)
end