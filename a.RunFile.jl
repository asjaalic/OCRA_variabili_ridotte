#RUN FILE
using Pkg
# Calls the Packages used for the optimization problem
using JuMP
using Printf
using Gurobi
#using CPLEX
using MathOptInterface
using JLD
using TimerOutputs
using DataFrames
using XLSX
using Parameters
using Dates
using CSV

# Calls the other Julia files
include("Structures.jl")
include("SetInputParameters.jl")
include("Saving in xlsx.jl")

date = string(today())

# PREPARE INPUT DATA
to = TimerOutput()

@timeit to "Set input data" begin

  #Set run case - indirizzi delle cartelle di input ed output
  case = set_runCase()

  @unpack (DataPath,InputPath,ResultPath,CaseName) = case;

  # Set run mode (how and what to run) and Input parameters
  runMode = read_runMode_file()
  InputParameters = set_parameters(runMode, case)
  @unpack (NYears, NMonths, NHoursStep, NStages, Big, conv, bin)= InputParameters;    #NSteps, NHoursStage

  # Upload battery's characteristics
  Battery = set_battery_system(runMode, case)
  @unpack (min_SOC, max_SOC, Eff_charge, Eff_discharge, min_P, max_P, max_SOH, min_SOH, Nfull, cost) = Battery; 

  #Calculate coefficients for quadratic terms
  a,b,c,disc = calculate_coefficients(min_SOC,max_SOC,bin)

  # Set solver parameters (Gurobi etc)
  SolverParameters = set_solverParameters()

  # Read power prices from a file [€/MWh]
  #Steps_stages = [0 4380 8760 13140 17520 21900 26280 30660 35040 39420 43800 48180 52560 56940 61320 65700 70080 74460 78840 83220 87600]
  Steps_stages = [0 751 1485 2230 2916 3689 4373 5081 5753 6473 7075 7851 8535 9270 9899 10599 11213 11877 12525 13232 13873]
  NSteps = Int(Steps_stages[NStages+1])

  Battery_price_purchase = read_csv("Battery_decreasing_prices_mid.csv",case.DataPath) #degradation_cost
  Battery_price_sale = set_price(Battery_price_purchase,cost);
  
  #Pp14 = read_csv("Prezzi_2014_2023.csv", case.DataPath);
  Pp14 = read_csv("Filtered.csv", case.DataPath)

  Power_prices = Pp14 #vcat(Pp14,Pp15,Pp16,Pp17,Pp18,Pp19,Pp20,Pp21,Pp22,Pp23) .*1000;   

  # Where and how to save the results
  FinalResPath= set_run_name(case, ResultPath, NSteps)

end

#save input data
@timeit to "Save input" begin
    save(joinpath(FinalResPath,"CaseDetails.jld"), "case" ,case)
    save(joinpath(FinalResPath,"SolverParameters.jld"), "SolverParameters" ,SolverParameters)
    save(joinpath(FinalResPath,"InputParameters.jld"), "InputParameters" ,InputParameters)
    save(joinpath(FinalResPath,"BatteryCharacteristics.jld"), "BatteryCharacteristics" ,Battery)
    save(joinpath(FinalResPath,"PowerPrices.jld"),"PowerPrices",Power_prices)
end

@timeit to "Solve optimization problem" begin
  if bin ==3
    ResultsOpt_3 = solveOptimizationProblem_3(InputParameters,SolverParameters,Battery, disc, c, b);
    save(joinpath(FinalResPath, "optimization_results.jld"), "optimization_results", ResultsOpt_3)
  else
    ResultsOpt_4 = solveOptimizationProblem_4(InputParameters,SolverParameters,Battery, disc, c, b);
    save(joinpath(FinalResPath, "optimization_results.jld"), "optimization_results", ResultsOpt_4)
  end
  
end

# SAVE DATA IN EXCEL FILES
if runMode.excel_savings
  cartella = "C:\\GitHub\\OCRA_1.0_variabili ridotte\\Results"
  cd(cartella)
  if bin==3
    Saving = data_saving_3(InputParameters,ResultsOpt_3)
  else
    Saving = data_saving_4(InputParameters,ResultsOpt_4)
  end
else
  println("Solved without saving results in xlsx format.")
end


#end
print(to)




