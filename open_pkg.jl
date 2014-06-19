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

# open the first method
function of(f::Function)
    mt = methods(json)
    m = mt.defs # get Method

    method_target = get_method_target(m)
    _open_method(m)
end
# using JSON
# of(json)
