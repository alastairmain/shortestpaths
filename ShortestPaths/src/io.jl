using JSON

"""
Function to parse user provided JSON files.

"""


function build_adjacency_list(graph_data::Dict{String,Any})
    adj_list = Dict{String,Vector{Tuple{String,Int}}}()

    for edge in graph_data["edges"]
        from = edge["from"]
        to = edge["to"]
        transit_time = edge["transit_time"]

        # if the node does not appear as a key already, then create it
        if !haskey(adj_list, from)
            adj_list[from] = []
        end
        push!(adj_list[from], (to, transit_time)) # add connection to node

        # if bidirectional; check if connecting node key exists in dict
        if !haskey(adj_list, to)
            adj_list[to] = [] # create it 
        end
        push!(adj_list[to], (from, transit_time)) # insert reverse connection
    end

    return adj_list
end

function load_graph_json(file::String)
    # reas JSON
    inst = JSON.parsefile(file)

    # restructure graph into dictionary (node1) => [(node2, transit_time),(node3, transit_time),(node4, transit_time)] 
    adj_list = build_adjacency_list(inst)

    return adj_list
end

function export_graph_json(graph::Dict{String,Any}, filename::String)
    # Ensure ordered structure
    ordered = OrderedDict{String,Any}()

    # Order the top-level keys: nodes first, then edges
    ordered["nodes"] = graph["nodes"]

    # Convert each edge to an OrderedDict with desired key order
    ordered_edges = OrderedDict{String,Any}[]
    for edge in graph["edges"]
        push!(ordered_edges, OrderedDict(
            "from" => edge["from"],
            "to" => edge["to"],
            "transit_time" => edge["transit_time"]))
    end

    ordered["edges"] = ordered_edges

    json_str = JSON.json(ordered)
    open(filename, "w") do io
        write(io, json_str)
    end

    println("Graph exported to $filename")
end



