using DelimitedFiles
function getData()
    return map((x) -> filter(!isempty, x), eachrow(string.(readdlm(
        IOBuffer(replace(read("data.txt", String), ":" => ";")), ';'))))
end

function processGame(game; config=[12, 13, 14])
    d = replace.(filter(!isempty, split(game, ' ')), "," => "")
    pass = true
    for i in eachindex(d)
        compare = 0
        if d[i] == "red"
            compare = 1
        elseif d[i] == "green"
            compare = 2
        elseif d[i] == "blue"
            compare = 3
        end
        if !(compare == 0)
            if parse(Int64, d[i-1]) > config[compare]
                pass = false
            end
        end
    end
    return pass
end

function processGameMinimum(game, config=zeros(Int64, 3))
    d = replace.(filter(!isempty, split(game, ' ')), "," => "")
    for i in eachindex(d)
        compare = 0
        val = 0
        if d[i] == "red"
            val = parse(Int64, d[i-1])
            compare = 1
        elseif d[i] == "green"
            val = parse(Int64, d[i-1])
            compare = 2
        elseif d[i] == "blue"
            val = parse(Int64, d[i-1])
            compare = 3
        end
        if !(compare == 0)
            if config[compare] < val
                config[compare] = val
            end
        end
    end
    return config
end

function processAllGames(data)
    total = 0
    for d in data
        if (all(processGame.(d[2:end])))
            #println(first(d))
            total += parse(Int64, prod(filter(isdigit, first(d))))
        end
    end
    return total
end

function processAllGamesMinimum(data)
    total = 0
    for d in data
        config = zeros(Int64, 3)
        for g in d[2:end]
            processGameMinimum(g, config)
        end
        total += prod(config)
    end
    return total
end

#Task 1:
#processAllGames(getData())
#Task 2:
#processAllGamesMinimum(getData())