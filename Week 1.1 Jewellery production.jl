using JuMP
using HiGHS

#Define the weights and values of the data
necklaceTypes = 5
mct = 7.5*60 #Machine times
MachineTimes = [7 0 0 9 0; 5 7 11 0 5; 0 3 8 15 3]
ast = 7.5*60*2
ast1 = [12 3 11 9 6]
demand = [25 10 12 15 60] #demand

profit = [50 45 85 60 55]


#Create the HiGHS optimizer
model = Model(HiGHS.Optimizer)

#Define decision variables
@variable(model, 0<= x[1:necklaceTypes])

#Define objective function
@objective(model, Max, sum(profit[i]*x[i] for i in 1:necklaceTypes))

#Define constraints
@constraint(model, [n=1:3], sum(MachineTimes[n,i]*x[i] for i in 1:necklaceTypes) <= mct)
@constraint(model, sum(ast1[i]*x[i] for i in 1:necklaceTypes) <= ast)
@constraint(model, [i=1:necklaceTypes], x[i] <= demand[i])

#Solve the model
optimize!(model)

#Get the results
println("Objective value: ", objective_value(model))
println("x = ", value.(x))
