using DelimitedFiles
function getData()
    return string.(readdlm("data.txt"))
end

function getDigitsDict()
    digitsDict = ["one" => "1", "two" => "2", "three" => "3",
        "four" => "4", "five" => "5", "six" => "6", "seven" => "7", "eight" => "8",
        "nine" => "9"]
    digitsDict = Dict([i[1] => i[1] * i[2] * i[1] for i in digitsDict]...)
    return digitsDict
end

#Task 1
function main()
    data = getData()
    digits = map((x) -> filter(isdigit, collect(x)), data)
    return sum([parse(Int64, first(i) * last(i)) for i in digits])
end

#Task 2
#This approach works by replacing a word by word*digit*word.
#This way, even if multiple words share chars they can still function.
function mainWords()
    data = getData()
    digitsDict = getDigitsDict()
    for i in eachindex(data)
        for j in digitsDict
            data[i] = replace(data[i], j)
        end
    end
    digits = map((x) -> filter(isdigit, collect(x)), data)
    return sum([parse(Int64, first(i) * last(i)) for i in digits])
end