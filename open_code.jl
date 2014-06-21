# open a pkg
# mt.defs will get the fist method


PKG_DIR = Pkg.dir()

if haskey(ENV,"EDITOR")
    EDITOR = ENV["EDITOR"]
else
    EDITOR = "emacs"
end

function get_julia_code_path()
    pathes = split(ENV["PATH"],":")
    indexes = find((p) -> match(r"julia",p) != nothing,pathes)
    pathes[indexes[1]]
end

JULIA_CODE_PATH = get_julia_code_path()
get_first_method(f::Function) = methods(f).defs

get_code(m::Method) = m.func.code

# _is_julia_method(get_first_method(+)) == true

# using JSON
# _is_julia_method(get_first_method(json)) ==  false
function _is_julia_method(m::Method)
    code = get_code(m)
    file = code.file
    !isfile(string(file)) # julia file likes file = :bool.jl
end

function _open_method(method_target)
    comment_str = string(EDITOR," ",method_target)
    e = Expr(:macrocall, symbol("@cmd"),comment_str)
    run(eval(e))
end

macro op(pkg)
    target = joinpath(PKG_DIR,string(pkg))

    _open_method(target)
end
# @op JSON


function get_method_target(m::Method)
    code = m.func.code
    string(code.file,":",code.line)
end

function getindex(m::Method, index::Int64)
    current_m = m
    for i in 1:(index -1)
        current_m = m.next
    end
    current_m
end

function of(f::Function,index::Int64)
    mt = methods(f)
    m = mt.defs[index] # get Method

    method_target = get_method_target(m)
    _open_method(m)
end

of(f::Function) = of(f,1)
# using JSON
# of(json)
# of(json,2)
