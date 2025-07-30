
using Random

"""
Function to generate randomly connected graph.

"""

function generate_random_connected_graph(n::Int, m::Int; max_transit::Int=100)
    @assert m ≥ n - 1 "Need at least n-1 edges for connectivity"
    @assert m ≤ div(n * (n - 1), 2) "Too many edges for an undirected simple graph"

    nodes = [string('A' + i - 1) for i in 1:n]  # e.g., ["A", "B", ..., "Z"]
    edges = Set{Tuple{String,String}}()
    edge_data = []

    # Step 1: Random spanning tree (to ensure connectivity)
    shuffled = shuffle(nodes)
    for i in 2:n
        u = shuffled[i]
        v = shuffled[rand(1:i-1)]
        push!(edges, (u, v))
        push!(edge_data, Dict("from" => u, "to" => v, "transit_time" => rand(1:max_transit)))
    end

    # add in bidirectional edges
    bidirectional_edges = []
    for e in edge_data
        push!(bidirectional_edges, e)
        push!(bidirectional_edges, Dict("from" => e["to"], "to" => e["from"], "transit_time" => e["transit_time"]))
    end

    # add remaining random edges
    while length(edge_data) < m
        u, v = rand(nodes, 2)
        if u != v && !((u, v) in edges) && !((v, u) in edges)
            push!(edges, (u, v))
            push!(edge_data, Dict("from" => u, "to" => v, "transit_time" => rand(1:max_transit)))
        end
    end

    return Dict{String,Any}(
        "nodes" => nodes,
        "edges" => edge_data
    )

end


