
if !isdir("ccv")
    run(`git clone https://github.com/liuliu/ccv`)
end
cd("ccv")
run(`git pull`)
cd("lib")
mv("makefile", "makefile.original", remove_destination=true) # we have our own
cp("../../makefile", "./makefile")
run(`make clean`)
run(`./configure`)
run(`make`)
