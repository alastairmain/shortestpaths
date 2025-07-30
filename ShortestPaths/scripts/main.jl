

"""
main funtion to run library.

"""


# get the parser
include("parser.jl")

# get the library ShortestPaths 
push!(LOAD_PATH, joinpath(@__DIR__, "..", "src"))
using ShortestPaths

# CLI entry point
function main()
    # parse arguments
    parsed_args = parse_args(setup_parser())
    cmd = parsed_args["command"] # select what to do

    if cmd == "generate"
        # generate a random graph
        graph = generate_random_connected_graph(parsed_args["vertices"], parsed_args["edges"])

        # export the random graph
        if haskey(parsed_args, "export")
            export_graph_json(graph, parsed_args["export"])
        end

    elseif cmd == "import"
        # import a graph from json file and run shortest path algorithm
        # laod graph
        println(parsed_args["file"])
        adj_list = load_graph_json(parsed_args["file"])

        # run shortest path algorithms
        if get(parsed_args, "algorithm", "") == "dijkstra-target"
            # run dijkstra 
            dist, prev = dijkstra(adj_list, parsed_args["source"], target=parsed_args["target"])
            export_dijkstra_results("$(parsed_args["export"])/dijkstra-target.json", dist, prev, parsed_args["source"], target=parsed_args["target"])

        elseif get(parsed_args, "algorithm", "") == "dijkstra-all"
            # run dijkstra without a target
            dist, prev = dijkstra(adj_list, parsed_args["source"])
            export_dijkstra_results("$(parsed_args["export"])/dijkstra-all.json", dist, prev, parsed_args["source"])

        elseif get(parsed_args, "algorithm", "") == "bellman-ford"
            # run bellman-ford 
            dist, prev = bellman_ford(adj_list, parsed_args["source"])
            export_bellman_ford_results("$(parsed_args["export"])/bellman-ford.json", adj_list, parsed_args["source"], dist, prev)

        elseif get(parsed_args, "algorithm", "") == "floyd-warshall"
            # run floyd-warshall 
            dist_mat = floyd_warshall(adj_list)
            export_floyd_warshall_result("$(parsed_args["export"])/floyd.json", dist_mat, collect(keys(adj_list)))
        end

    elseif cmd == "benchmark"
        # benchmark specific algorithm
        benchmark_algorithm(parsed_args["algorithm"], parsed_args["vertices"], parsed_args["edges"])

    elseif cmd == "test"
        # run some simple unit tests
        run_simple_tests()
    end
end

main()



