math.randomseed(os.time())
--chromosome class
local Chromosome = {}
Chromosome.__index = Chromosome

function Chromosome.new(array)
    local self = setmetatable({}, Chromosome)
    self.length = 50
    self.genes = array --Array of 1s and 0s for now, pretty lame, of length 100
    self.fitness = 0
    return self
end


--multiple crossover style not really conducive to desired effect, i dont think
function Chromosome.new_kid(mom, dad, c_rate, m_rate)
    local self = setmetatable({}, Chromosome)
    local gene_parent = false
    self.length = mom.length
    self.fitness = 0
    self.genes = {}

    --imparting genes
    for x = 1, self.length do
        if math.random() < c_rate then
            gene_parent = true --false = mom, true = dad
        end

        if not gene_parent then
            self.genes[x] = mom.genes[x]
        else
            self.genes[x] = dad.genes[x]
        end
    end

    --mutation
    for i,v in ipairs(self.genes) do
        if math.random() < m_rate then
            if v == 1 then
                self.genes[i] = 0
            else
                self.genes[i] = 1
            end
        end
    end

    return self
end



--temporary fitness function = sum of gene array = 14
--temporary generation limit: 10

crossover = .6
mutation = .005

chromosome_list = {}
local mammy = {}
local pappy = {}

for x=1,5000 do
    table.insert(mammy, math.random(0,1))
    table.insert(pappy, math.random(0,1))
end

local sortfunc = function(a,b) return a.fitness > b.fitness end

local m = Chromosome.new(mammy)
local d = Chromosome.new(pappy)

table.insert(chromosome_list, m)
table.insert(chromosome_list, d)

local gen_limit = 100000
local fitness_goal = 5
local length = chromosome_list[1].length
local k
for x=0,gen_limit do


    local mom_val = 1
    while(math.random() > .8 and mom_val < #chromosome_list) do mom_val = mom_val + 1 end

    local dad_val = #chromosome_list
    while(math.random() > .2 and dad_val > 1) do dad_val = dad_val - 1 end




    --selecting parents
 --   local mom_val = math.random(1,#chromosome_list)
--    local dad_val = math.random(1,#chromosome_list)
    while dad_val == mom_val do
        dad_val = math.random(1,#chromosome_list)
    end

    if math.random() < .5 then
        k = Chromosome.new_kid(chromosome_list[mom_val],chromosome_list[dad_val],crossover/length*10, mutation/length*10)
    else
        k = Chromosome.new_kid(chromosome_list[dad_val],chromosome_list[mom_val],crossover/length*10, mutation/length*10)
    end

    local gene_tally = 0
    for _, v in ipairs(k.genes) do
        gene_tally = gene_tally + v
    end

    k.fitness = 1 / (math.abs(fitness_goal-gene_tally) + 1)

    --check if best fit
    if k.fitness == 1.0 then
        print("Done at generation " .. x)
        for _,v in ipairs(k.genes) do io.write(v) end
        break
    end

    table.insert(chromosome_list, k)
    table.sort(chromosome_list, sortfunc)
    if #chromosome_list > 500 then
        table.remove(chromosome_list)
    end


    --print format
    print()
    io.write("Generation " .. x .. "    ")
    --[[[for _,i in pairs(k.genes) do
        io.write(i)
    end
    --]]
    io.write("   Fitness:  " .. k.fitness)
    print()
end

