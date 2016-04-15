
if !isdir("ccv")    
    run(`git clone https://github.com/liuliu/ccv`)
    cd(joinpath("ccv", "lib"))
    mv("makefile", "makefile.original") # we have our own
    cp("../../makefile", "./makefile")
    run(`./configure`)
    run(`make`)
end    
