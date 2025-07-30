
using DataStructures

"""
Dijkstra's shortest path algorithm to find the path from vertex to vertex or from vertex to all other vetices.

"""

function dijkstra(graph::Dict{String,Vector{Tuple{String,Int}}}, source::String; target::Union{Nothing,String}=nothing)

    log_event("Starting Dijkstra from '$source'" * (target !== nothing ? " to '$target'" : "") * ".")

    # define the nodes that the graph has
    node_set = Set(keys(graph))
    for neighbors in values(graph)
        for (neighbor, _) in neighbors
            push!(node_set, neighbor)
        end
    end
    nodes = collect(node_set)

    # setup collection of distances and path
    dist = Dict(node => Inf for node in nodes)
    prev = Dict(node => "" for node in nodes)
    dist[source] = 0

    # use priorityqueue to auto-sort best vertices
    pq = PriorityQueue{String,Float64}()
    enqueue!(pq, source => 0.0)

    while !isempty(pq)
        current_node = dequeue!(pq)
        current_dist = dist[current_node]
        log_event("Visiting node '$current_node' with current distance $current_dist.")

        # Stop early if target is reached
        if target !== nothing && current_node == target
            log_event("Reached target '$target'. Early termination.")
            break
        end

        # get neighbors
        for (neighbor, weight) in get(graph, current_node, [])
            new_dist = current_dist + weight
            if new_dist < dist[neighbor]
                dist[neighbor] = new_dist
                prev[neighbor] = current_node
                log_event("Updated distance for '$neighbor': $new_dist via '$current_node'.")
                if haskey(pq, neighbor)
                    delete!(pq, neighbor)
                end
                enqueue!(pq, neighbor => new_dist)
            end
        end
    end
    log_event("Dijkstra completed. Returning distances and paths.")
    return dist, prev
end


function reconstruct_path(prev::Dict{String,String}, target::String)
    path = String[]
    current = target
    while current != ""
        pushfirst!(path, current)
        current = prev[current]
    end
    return path
end

function export_dijkstra_results(filename::String, dist::Dict{String,Float64}, prev::Dict{String,String}, source::String; target::Union{Nothing,String}=nothing)
    paths = Dict{String,Any}()

    if target !== nothing
        # Export only the single path from source to target
        path = reconstruct_path(prev, target)
        paths["$source->$target"] = Dict("distance" => dist[target], "path" => path)
    else
        # Export all paths from source to every other node
        for node in keys(dist)
            if node != source && dist[node] < Inf
                path = reconstruct_path(prev, node)
                paths["$source->$node"] = Dict("distance" => dist[node], "path" => path)
            end
        end
    end

    # Write JSON to file
    json_str = JSON.json(paths)
    open(filename, "w") do io
        write(io, json_str)
    end

    println("Dijkstra's results exported to $filename")
end
