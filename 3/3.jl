using DelimitedFiles

function getData()
    return string.(readdlm("data.txt"))
    #return string.(readdlm("test.txt"))
end

function getNeighbours(i, j, rowL, colL)
    neighbours = Vector{Tuple{Int,Int}}(undef, 0)
    if (i > 1) && (i < rowL)
        left = (i - 1, j)
        right = (i + 1, j)
        push!(neighbours, left)
        push!(neighbours, right)
    end
    if (j > 1) && (j < colL)
        up = (i, j - 1)
        down = (i, j + 1)
        push!(neighbours, up)
        push!(neighbours, down)
    end
    if (i > 1) && (j > 1)
        push!(neighbours, (i - 1, j - 1))
    end
    if (i < rowL) && (j > 1)
        push!(neighbours, (i + 1, j - 1))
    end
    if (i > 1) && (j < colL)
        push!(neighbours, (i - 1, j + 1))
    end
    if (i < rowL) && (j < colL)
        push!(neighbours, (i + 1, j + 1))
    end
    return neighbours
end

function checkNeighbours(i, j, data)
    rowL = length(first(data))

    #checkCurrentCharacter
    currentChar = isdigit(data[j][i])

    out = nothing
    if currentChar
        #crawlLeft
        leftPos = i
        while (leftPos > 1) && isdigit(data[j][leftPos-1])
            leftPos = leftPos - 1
        end

        #crawlRight
        rightPos = i
        while (rightPos < rowL) && isdigit(data[j][rightPos+1])
            rightPos = rightPos + 1
        end
        out = (leftPos:rightPos, j)
    end
    return out
end

function getPositions(data, needle)
    vals = findall.(needle, data)
    pos = []
    for j in eachindex(vals)
        if vals[j] != []
            for k in vals[j]
                push!(pos, (k, j))
            end
        end
    end
    return pos
end

function main()
    data = getData()
    needle(x) = (!isdigit(x)) && (!(x == '.'))
    positions = getPositions(data, needle)
    rowL = length(first(data))
    colL = length(data)
    neighbours = []
    for pos in positions
        if pos != []
            append!(neighbours, getNeighbours(first(pos), last(pos), rowL, colL))
        end
    end
    digitsLocations = []
    for n in neighbours
        push!(digitsLocations, checkNeighbours(n..., data))
    end
    #Filter and check for uniqueness
    digitsLocations = filter(!isnothing, unique(digitsLocations))
    sumDigits = 0
    for i in digitsLocations
        sumDigits += (parse(Int64, (data[i[2]][i[1]])))
    end
    return sumDigits
end

function getGearRatio(neighbours, data)
    digitNeighbours = []
    for neighbour in neighbours
        push!(digitNeighbours, checkNeighbours(neighbour..., data))
    end
    digitNeighbours = unique(filter(!isnothing, digitNeighbours))
    gearRatio = 0
    if length(digitNeighbours) == 2
        gearRatio = 1
        for d in digitNeighbours
            gearRatio *= (parse(Int64, (data[d[2]][d[1]])))
        end
    end
    return gearRatio
end

function mainGears()
    data = getData()
    needle(x) = (x == '*')
    positions = getPositions(data, needle)
    rowL = length(first(data))
    colL = length(data)
    neighbours = []
    for pos in positions
        if pos != []
            append!(neighbours, [getNeighbours(first(pos), last(pos), rowL, colL)])
        end
    end
    sumGearRatio = 0
    for n in neighbours
        sumGearRatio += getGearRatio(n, data)
    end
    return sumGearRatio
end