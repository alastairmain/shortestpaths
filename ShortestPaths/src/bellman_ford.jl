
"""
Bellman-ford algorithm to find distance form a single vertex to all other vertices.

"""

function bellman_ford(graph::Dict{String,Vector{Tuple{String,Int}}}, source::String)

    #setup collection of distances and path
    dist = Dict(node => Inf for node in keys(graph))
    prev = Dict{String,Union{Nothing,String}}(node => nothing for node in keys(graph))

    dist[source] = 0 # start at source

    nodes = collect(keys(graph))
    V = length(nodes)

    log_event("Starting Bellman-Ford from source: $source on graph with $V nodes.")

    # Relax edges V-1 times
    for i in 1:(V-1)
        log_event("Iteration $i of edge relaxation")
        for (u, neighbors) in graph
            for (v, weight) in neighbors
                if dist[u] + weight < dist[v]
                    dist[v] = dist[u] + weight
                    prev[v] = u
                    log_event("Updated dist[$v] = $(dist[v]) via $u (weight: $weight)")
                end
            end
        end
    end

    # Checking for negative-weight cycles
    for (u, neighbors) in graph
        for (v, weight) in neighbors
            if dist[u] + weight < dist[v]
                log_event("Negative-weight cycle detected involving edge $u -> $v")
                error("Graph contains a negative-weight cycle")
            end
        end
    end

    log_event("Bellman-Ford completed.")

    return dist, prev
end

function reconstruct_path(prev::Dict{String,Union{Nothing,String}}, target::String)
    # go backwards through prev until we hit the target.
    path = String[]
    while target !== nothing
        pushfirst!(path, target)
        target = prev[target]
    end
    return path
end

function export_bellman_ford_results(filename::String, graph::Dict, source::String, dist::Dict, prev::Dict)

    # reorder the resutls to generate the paths
    results = Dict{String,Any}()
    results["source"] = source
    results["paths"] = []

    # loop through all nodes, reconstruct the path and append to resutls--> exprot to json
    for node in sort(collect(keys(graph)))
        path = reconstruct_path(prev, node)
        push!(results["paths"], Dict(
            "to" => node,
            "path" => path,
            "distance" => dist[node]
        ))
    end

    # Write JSON to file
    json_str = JSON.json(results)
    open(filename, "w") do io
        write(io, json_str)
    end

    println("Bellman-Ford results exported to $filename")
end