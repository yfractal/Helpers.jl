# open a pkg
PKG_DIR = Pkg.dir()

macro op(pkg)
    if haskey(ENV,"EDITOR")
        editor = ENV["EDITOR"]
    else
        editor = "emacs"
    end
    
    dir = joinpath(PKG_DIR,string(pkg))
    comment_str = string(editor," ",dir)
    
    e = Expr(:macrocall, symbol("@cmd"),comment_str)
    
    run(eval(e))
end
# open a method
