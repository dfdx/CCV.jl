
if !isdir("ccv")    
    run(`git clone https://github.com/liuliu/ccv`)
    deps_dir = pwd()
    cd(joinpath("ccv", "lib"))
    run(`./configure`)
    run(`make`)
    cd(deps_dir)
end    
