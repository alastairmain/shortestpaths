
"""
Floyd-warshall's shortest path algorithm to find the shortest path between all pairs of vertices.

"""

function floyd_warshall(graph::Dict{String,Vector{Tuple{String,Int}}})
    # find all unique keys and create universal mapping string => integer. index
    nodes = sort!(collect(keys(graph)))
    node_to_index = Dict(node => i for (i, node) in enumerate(nodes))
    index_to_node = Dict(i => node for (node, i) in node_to_index)
    log_event("Starting Floyd-Warshall on graph with $(length(nodes)) nodes.")

    # initialise distance matrix
    n_nodes = length(nodes)
    dist = fill!(zeros(n_nodes, n_nodes), Inf)
    for node_string in nodes
        i = node_to_index[node_string]
        dist[i, i] = 0
        for conn in graph[node_string] # add in connecting vertex
            j = node_to_index[conn[1]]
            dist[i, j] = conn[2]
        end
    end

    log_event("Initialized distance matrix with direct edge weights.")

    for k in 1:n_nodes
        log_event("Processing intermediate node $(index_to_node[k]) ($k of $n_nodes).")
        for i in 1:n_nodes
            for j in 1:n_nodes
                if dist[i, k] != Inf && dist[k, j] != Inf
                    dist[i, j] = min(dist[i, j], dist[i, k] + dist[k, j])
                end
            end
        end

    end

    log_event("Completed Floyd-Warshall. Returning distance matrix.")
    return dist
end


function export_floyd_warshall_result(filename::String, dist::Matrix{Float64}, nodes::Vector{String})

    result = OrderedDict("shortest_paths" => [])

    for i in 1:length(nodes)
        for j in 1:length(nodes)
            entry = OrderedDict(
                "from" => nodes[i],
                "to" => nodes[j],
                "distance" => isinf(dist[i, j]) ? "Inf" : dist[i, j]
            )
            push!(result["shortest_paths"], entry)
        end
    end

    # Write JSON to file
    json_str = JSON.json(result)
    open(filename, "w") do io
        write(io, json_str)
    end


    println("Floyd-Warshall's results exported to $filename")
end