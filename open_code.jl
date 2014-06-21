# open a pkg
PKG_DIR = Pkg.dir()

if haskey(ENV,"EDITOR")
    EDITOR = ENV["EDITOR"]
else
    EDITOR = "emacs"
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
    li = m.func.code
    string(li.file,":",li.line)
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
