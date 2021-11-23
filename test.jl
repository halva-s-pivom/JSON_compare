using JSON, StringCases

function main(args)
	json1, json2 = JSON.parsefile.((args)) 

	unifykeys(dict::Dict{String, Any})::typeof(dict) = Dict(
	    map(collect(dict)) do (key, value)
		underscore(key) => (value isa Dict ? unifykeys(value) : value) 
	    end
	)
	function showDifference(json1::Dict, json2::Dict, indent=0; preprocess=true)
	    if preprocess
		json1, json2 = unifykeys.((json1, json2))
	    end
	    keys1, keys2 = keys.((json1, json2))
	    for key in setdiff(keys1, keys2)
		println(' '^indent, "First has key $key that second doesn't have")
	    end
	    for key in setdiff(keys2, keys1)
		println(' '^indent, "Second has key $key that first doesn't have")
	    end
	    for key in intersect(keys1, keys2)
		if json1[key] != json2[key]
		    println(' '^indent, key, ':')
		    if json1[key] isa Dict && json2[key] isa Dict
		        println(' '^indent, "    First and second are jsons:")
		        showDifference(json1[key], json2[key], indent+8)
		    else
		        println(' '^indent, "    First has value $(json1[key] isa Dict ? json(json1[key], indent+8)[1:end-2] * ' '^indent * "    }" : json1[key])\n", ' '^indent, "    Second has value $(json2[key] isa Dict ? json(json2[key], indent+8)[1:end-2] * ' '^indent * "    }" : json2[key])")
		    end
		end
	    end
	end

	showDifference(json1, json2)
end

main(ARGS)
