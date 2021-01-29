# Setup the paths -
const _PATH_TO_ROOT = pwd()
const _PATH_TO_SRC = "$(_PATH_TO_ROOT)/src"
const _PATH_TO_CONFIG = "$(_PATH_TO_ROOT)/config"

# endpoint -
const _TEXT_MAGIC_REST_ENDPOINT = "https://rest.textmagic.com/api/v2"

# load external modules -
using HTTP
using DataFrames
using CSV
using TOML
using JSON
using FileWatching
using Logging

# load my codes -
include("./Types.jl")
include("./Files.jl")
include("./Factory.jl")
include("./Network.jl")
