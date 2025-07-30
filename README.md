# This Julia package provides tools for:
- Generating random graphs
- Running shortest path algorithms (like Dijkstra, Bellman-ford, and Floyd-Warshall)



## Step 1: Installing the Julia language

Before you can use this project, you need to install the Julia language.
You can download it from the official website at:

https://julialang.org/downloads/

Just follow the instructions on the webpage. If prompted you can add julia to PATH. 
Depending on your platform, you may have to do this manually. More information can be found here


https://julialang.org/downloads/platform/


### Step 1.1: Verify the installation

Verify your installation by running the following in the terminal

```>> julia --version```

Terminal output should be something like: 

```julia version 1.xx.x```


## Step 2: Clone the repository (or unpack the provided zip file)

We now need to get hold of the code for the project.

```>> git clone https://github.com/your-username/ShortestPaths.jl.git```

Go to the location of the folder

```>> cd ShortestPaths```

We are now ready to setup the project. First launch Julia in the terminal by typing

```>> julia```


You should see something in the form of

```
julia

               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.11.6 (2025-07-09)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |
```

Now run the following commands one by one


```>> using Pkg```

```>> Pkg.activate(".")```

```>> Pkg.instantiate()```

This will install all required packages and set up the project. It should look something like this.


```

C:\Users\name\Desktop\maersk_task>julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.11.6 (2025-07-09)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Pkg

julia> Pkg.activate(".")
  Activating project at `C:\Users\name\Desktop\maersk_task`

julia> Pkg.instantiate()
┌ Warning: The active manifest file has dependencies that were resolved with a different julia version (1.10.2). Unexpected behavior may occur.
└ @ C:\Users\name\Desktop\maersk_task\Manifest.toml:0
   Installed Compat ───────────── v4.18.0
   Installed Parsers ──────────── v2.8.3
   Installed OrderedCollections ─ v1.8.1
   Installed TextWrap ─────────── v1.0.2
   Installed ArgParse ─────────── v1.2.0
   Installed JSON ─────────────── v0.21.4
   Installed Preferences ──────── v1.4.3
   Installed BenchmarkTools ───── v1.6.0
   Installed PrecompileTools ──── v1.2.1
   Installed DataStructures ───── v0.18.22
Precompiling project...
  11 dependencies successfully precompiled in 11 seconds. 17 already precompiled.

```



We can now exit Julia by running:

```>> exit()```

# Step 3: Running the library

The structure of the project

```
ShortestPaths/
├── Project.toml          # Project dependencies and UUID
├── Manifest.toml         # Manifest
├── src/
│   ├── ShortestPaths.jl  # Module definition
│   ├── bellman-ford.jl     
│   ├── dijkstra.jl     
│   ├── floyd_warshall.jl     
│   ├── generator.jl     
│   ├── io.jl     
│   ├── benchmark.jl      
│   ├── logger.jl        
│   └── tests.jl         
├── scripts/
│   ├── main.jl           # CLI entry point
│   └── parser.jl         # Argument parser for CLI
├── data/                 # JSON input/output files
├── logs/                 # Log files
└── README.md             # This file
```


## The library has several options for functionality

```
usage: main.jl [--command COMMAND] [--vertices VERTICES]
               [--edges EDGES] [--export EXPORT] [--file FILE]
               [--algorithm ALGORITHM] [--source SOURCE]
               [--target TARGET] [-h]
```

### The user must pick a command from a list (generate, import, benchmark, test) (default: "test")

```generate```: used for generating a random bidirectional graph with n vertices and m edges

```import```: used for importing a bidirectional graph from a JSON file and running a shortest path algorithm such as dijkstra.

```benchmark```: used to benchmark the performance of the shortest path algorithm

```test```: used to run simple unit tests to assess the health of the shortest path algorithms.


### The user can specify additional arguments such as

```
optional arguments:
  --vertices VERTICES   Number of vertices (for generate) (type:
                        Int64, default: 8)
  --edges EDGES         Number of edges (for generate) (type: Int64,
                        default: 9)
  --export EXPORT       File to export generated graph to (default:
                        "/Users/.../ShortestPaths/data")
  --file FILE           Path to graph JSON file (default:
                        "/Users/.../ShortestPaths/data/exercise_baseline.json")
  --algorithm ALGORITHM
                        Pick a shortest path algorithm:
                        (dijkstra-target, dijkstra-all, bellman-ford,
                        floyd-warshall) (default: "dijkstra-target")
  --source SOURCE       Source node (default: "cw")
  --target TARGET       Target node (default: "hp")
  -h, --help            show this help message and exit
```


## Example usage

Generate running unit tests

```julia --project=. ShortestPaths/scripts/main.jl --command test```


Benchmarking algorithm with 10 vertices and 14 edges

```julia --project=. ShortestPaths/scripts/main.jl --command benchmark --algorithm dijkstra-target --vertices 10 --edges 14```


Generate and export a Random Graph with 10 vertices and 14 edges

```julia --project=. ShortestPaths/scripts/main.jl --command generate --vertices 10 --edges 14 --export data/mygraph.json```



Import a Graph and Run Dijkstra with a target node

```julia --project=. ShortestPaths/scripts/main.jl --command import --file path_to_fil/mygraph.json --algorithm dijkstra-target --source cw --target B```

Results are written to data/dijkstra-target.json.




Import a Graph and Run Dijkstra from source to all other vertices

```julia --project=. ShortestPaths/scripts/main.jl --command import --file path_to_fil/mygraph.json --algorithm dijkstra-all --source A```

Results are written to data/dijkstra-target.json.



Import a Graph and Run Dijkstra from source to all other vertices

```julia --project=. ShortestPaths/scripts/main.jl --command import --file path_to_fil/mygraph.json --algorithm floyd-warshall```

Results are written to data/floyd.json.

