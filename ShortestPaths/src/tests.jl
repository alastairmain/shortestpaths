using Test

"""
Function to run small unit tests of all algorithms.

"""


function run_simple_tests()

    # Define a small graph
    simple_graph = Dict(
        "E" => [("A", 8)],
        "A" => [("D", 4), ("E", 8)],
        "C" => [("B", 5), ("D", 3)],
        "B" => [("C", 5)],
        "D" => [("A", 4), ("C", 3)]
    )

    # test Dijkstra -- all targets
    @testset "Dijkstra Tests" begin
        dist, prev = dijkstra(simple_graph, "A")
        @test dist["B"] == 12.0   # A -> D (4) -> C (3) -> B (5)
        @test prev["B"] == "C"
        @test prev["C"] == "D"
        @test prev["D"] == "A"
    end
    println()

    # test Dijkstra -- with target node
    @testset "Dijkstra Targeted Test" begin
        dist, prev = dijkstra(simple_graph, "A", target="B")
        @test dist["B"] == 12.0
        dist, prev = dijkstra(simple_graph, "A", target="E")
        @test dist["E"] == 8.0
        dist, prev = dijkstra(simple_graph, "A", target="C")
        @test dist["C"] == 7.0
    end
    println()

    # test Bellman-ford
    @testset "Bellman-Ford Tests" begin
        dist, prev = bellman_ford(simple_graph, "A")
        @test dist["B"] == 12.0
        @test dist["C"] == 7.0
        @test dist["E"] == 8.0
        @test prev["B"] == "C"
        @test prev["C"] == "D"
        @test prev["D"] == "A"
    end
    println()

    # test floydd-warshall
    @testset "Floyd-Warshall Tests" begin
        dist_matrix = floyd_warshall(simple_graph)
        nodes = sort(collect(keys(simple_graph)))
        index = Dict(n => i for (i, n) in enumerate(nodes))
        @test dist_matrix[index["A"], index["B"]] == 12.0
        @test dist_matrix[index["A"], index["E"]] == 8.0
        @test dist_matrix[index["A"], index["C"]] == 7.0
    end
    println()

    println("Completed Unit Tests")

end