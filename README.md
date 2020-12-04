# skywater130_decred_miner

# Environment setup
Follow the steps at https://github.com/efabless/openlane#quick-start. 
Note that as of the time of this writing, the develop branch of open lane was used (i.e., git clone https://github.com/efabless/openlane.git --branch develop). If the docker is run manually, you'll need to specify rc5 instead of rc4.

After ```make test``` succeeds, proceed to check out step next.

# Check out
```
cd openlane/designs
git clone https://github.com/SweeperAA/skywater130_decred_miner.git ./caravel
cd caravel
make uncompress
```

# Build decred flow
At this point, there are two ways build the decred ASIC flow. At the time of this writing, each option has it's own deficiencies but you can get some intermediate results.

Option 1: Build the macro independent of the caravel chip harness user space area.
```
cd caravel/openlane
make decred_top
```

Option 2: Build the entire user space together with decred.
```
cd caravel/openlane
make user_project_wrapper
```
