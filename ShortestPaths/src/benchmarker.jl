using BenchmarkTools

function benchmark_algorithm(algorithm::String, vertices::Int, edges::Int)
    # Step 1: Generate a new random graph and build adjacency list
    graph_tmp = generate_random_connected_graph(vertices, edges)
    graph = build_adjacency_list(graph_tmp)

    # Step 2: Randomly select source and target
    nodes = collect(keys(graph))
    source = rand(nodes)
    target = rand(filter(x -> x != source, nodes))  # make sure target ≠ source

    println("Benchmarking $algorithm on graph with $vertices vertices and $edges edges...")
    println("Randomly selected source = $source, target = $target")

    # Step 3: Benchmark based on algorithm type
    if algorithm == "dijkstra-target"
        display(@benchmark  dijkstra($graph, $source, target=$target))

    elseif algorithm == "dijkstra-all"
        display(@benchmark  dijkstra($graph, $source))

    elseif algorithm == "bellman-ford"
        display(@benchmark  bellman_ford($graph, $source))

    elseif algorithm == "floyd-warshall"
        display(@benchmark floyd_warshall($graph))

    end
end