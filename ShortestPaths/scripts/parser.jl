
using ArgParse

"""
Function to parse user inputs.

"""


function setup_parser()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--command"
        help = "Choose a command: [generate, import, benchmark, test]"
        arg_type = String
        default = "test"

        # arguments for 'generate'
        "--vertices"
        help = "Number of vertices (for generate)"
        arg_type = Int
        default = 8

        "--edges"
        help = "Number of edges (for generate)"
        arg_type = Int
        default = 9

        "--export"
        help = "File to export generated graph to"
        arg_type = String
        default = abspath(joinpath(@__DIR__, "..", "data"))

        # arguments for 'import'
        "--file"
        help = "Path to graph JSON file"
        arg_type = String
        default =  abspath(joinpath(@__DIR__, "..", "data/exercise_baseline.json"))

        "--algorithm"
        help = "Pick a shortest path algorithm: [dijkstra-target, dijkstra-all, bellman-ford, floyd-warshall]"
        arg_type = String
        default = "dijkstra-target"

        "--source"
        help = "Source node"
        arg_type = String
        default = "cw"

        "--target"
        help = "Target node"
        arg_type = String
        default = "hp"

    end
    return s
end
