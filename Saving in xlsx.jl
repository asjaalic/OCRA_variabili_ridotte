# EXCEL SAVINGS
#using DataFrames
#using XLSX

function data_saving_3(InputParameters::InputParam,ResultsOpt_3::Results)

    @unpack (NYears, NMonths, NStages, Big, NHoursStep) = InputParameters;       #NSteps,NHoursStage
    
   #@unpack (charge,discharge, soc,soc_quad, gain_stage, x, y, z, w_xx, w_yy, w_zz, w_xy, w_xz, w_zy) = ResultsOpt;  
   @unpack (charge,discharge,rev,cap,soc,soc_quad, deg, deg_stage, gain_stage, cost_rev, revenues_per_stage,x, y, z, xy,xz,yz,xyz) = ResultsOpt_3;
   @unpack (min_SOC, max_SOC, min_P, max_P, Eff_charge, Eff_discharge, max_SOH, min_SOH, Nfull,fix ) = Battery ; 

    hour=string(now())
    a=replace(hour,':'=> '-')

    nameF= "Prova revamping ogni 6 mesi 3 variabili"
    nameFile="Summary " 

    folder = "$nameF NEW"
    mkdir(folder)
    cd(folder)
    main=pwd()

    general = DataFrame()
    #general_1 = DataFrame()
    battery_costs= DataFrame()

    capacity=zeros(NStages)
    capacity_finale = zeros(NStages)

    for iStage=1:NStages
        capacity[iStage]=cap[(Steps_stages[iStage]+2)] #(Steps_stages[iStage]+2)
    end

    for iStage=2:NStages
        capacity_finale[iStage-1] = cap[Steps_stages[iStage]+1]
    end
        capacity_finale[end] = cap[end]
    
    general[!,"Stage"] = 1:1:NStages
    general[!,"Initial Capacity MWh"] = capacity[:]
    general[!,"Final Capacity MWh"] = capacity_finale[:]
    general[!,"Revamping MWh"] = rev[:]
    #general[!, "Binary revamp"] = e[:]
    general[!,"Degradation MWh"] = deg_stage[:]
    general[!,"Net_Revenues €"] = revenues_per_stage[:]
    general[!,"Arbitrage €"] = gain_stage[:]
    general[!,"Cost revamping"] = cost_rev[:]

    battery_costs[!,"Purchase costs €/MWh"] = Battery_price_purchase[1:NStages]    #Battery_price_purchase

    XLSX.writetable("$nameFile.xlsx", overwrite=true,                                       #$nameFile
    results_stages = (collect(DataFrames.eachcol(general)),DataFrames.names(general)),
    costs = (collect(DataFrames.eachcol(battery_costs)),DataFrames.names(battery_costs)),
    )

    for iStage=1:NStages
        steps = DataFrame()

        steps[!,"Step"] = (Steps_stages[iStage]+1):(Steps_stages[iStage+1])
        steps[!, "Energy_prices €/MWh"] = Power_prices[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Energy capacity MWh"] = cap[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "SOC MWh"] = soc[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Charge MW"] = charge[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Discharge MW"] = discharge[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "SOC_quad MWh"] = soc_quad[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Deg MWh"] = deg[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]

        XLSX.writetable("$iStage stage .xlsx", overwrite=true,                                       #$nameFile
        results_steps = (collect(DataFrames.eachcol(steps)),DataFrames.names(steps)),
        )

    end

    cd(main)             # ritorno nella cartella di salvataggio dati


    return println("Saved data in xlsx")
end


function data_saving_4(InputParameters::InputParam,ResultsOpt_4::Results_4_bin)

    @unpack (NYears, NMonths, NStages, Big, NHoursStep) = InputParameters;       #NSteps,NHoursStage
    
   #@unpack (charge,discharge, soc,soc_quad, gain_stage, x, y, z, w_xx, w_yy, w_zz, w_xy, w_xz, w_zy) = ResultsOpt;  
   @unpack (charge,discharge,rev,cap,soc,soc_quad, deg, deg_stage, gain_stage, cost_rev, revenues_per_stage, x, y, z, xy, xz, xu, yz, yu, zu, xyzu) = ResultsOpt_4;
   @unpack (min_SOC, max_SOC, min_P, max_P, Eff_charge, Eff_discharge, max_SOH, min_SOH, Nfull,fix ) = Battery ; 

    hour=string(now())
    a=replace(hour,':'=> '-')

    nameF= "Prova revamping ogni 6 mesi 27.11 4 variabili"
    nameFile="Summary " 

    folder = "$nameF NEW"
    mkdir(folder)
    cd(folder)
    main=pwd()

    general = DataFrame()
    #general_1 = DataFrame()
    battery_costs= DataFrame()

    capacity=zeros(NStages)
    capacity_finale = zeros(NStages)

    for iStage=1:NStages
        capacity[iStage]=cap[(Steps_stages[iStage]+2)] #(Steps_stages[iStage]+2)
    end

    for iStage=2:NStages
        capacity_finale[iStage-1] = cap[Steps_stages[iStage]+1]
    end
        capacity_finale[end] = cap[end]
    
    general[!,"Stage"] = 1:1:NStages
    general[!,"Initial Capacity MWh"] = capacity[:]
    general[!,"Final Capacity MWh"] = capacity_finale[:]
    general[!,"Revamping MWh"] = rev[:]
    #general[!, "Binary revamp"] = e[:]
    general[!,"Degradation MWh"] = deg_stage[:]
    general[!,"Net_Revenues €"] = revenues_per_stage[:]
    general[!,"Arbitrage €"] = gain_stage[:]
    general[!,"Cost revamping"] = cost_rev[:]

    battery_costs[!,"Purchase costs €/MWh"] = Battery_price_purchase[1:NStages]    #Battery_price_purchase

    XLSX.writetable("$nameFile.xlsx", overwrite=true,                                       #$nameFile
    results_stages = (collect(DataFrames.eachcol(general)),DataFrames.names(general)),
    costs = (collect(DataFrames.eachcol(battery_costs)),DataFrames.names(battery_costs)),
    )

    for iStage=1:NStages
        steps = DataFrame()

        steps[!,"Step"] = (Steps_stages[iStage]+1):(Steps_stages[iStage+1])
        steps[!, "Energy_prices €/MWh"] = Power_prices[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Energy capacity MWh"] = cap[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "SOC MWh"] = soc[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Charge MW"] = charge[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Discharge MW"] = discharge[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "SOC_quad MWh"] = soc_quad[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]
        steps[!, "Deg MWh"] = deg[(Steps_stages[iStage]+1):(Steps_stages[iStage+1])]

        XLSX.writetable("$iStage stage .xlsx", overwrite=true,                                       #$nameFile
        results_steps = (collect(DataFrames.eachcol(steps)),DataFrames.names(steps)),
        )

    end

    cd(main)             # ritorno nella cartella di salvataggio dati


    return println("Saved data in xlsx")
end



