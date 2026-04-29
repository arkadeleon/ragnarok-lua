globalVar = { 0.0, 1.0 }

function myFunction(parameter)
    if parameter >= globalVar[1] and parameter <= globalVar[2] then
        return true
    else
        return false
    end
end
