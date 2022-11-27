state("ADACA-Win64-Shipping", "1.0.6")
{
    	string100 stage: "ADACA-Win64-Shipping.exe", 0x4A54520, 0x520, 0x4A8, 0x0;
	float IGT: "ADACA-Win64-Shipping.exe", 0x4509078;	
	int loading: "ADACA-Win64-Shipping.exe", 0x44BD181;
}

state("ADACA-Win64-Shipping", "1.1.5")
{
	string100 stage: "ADACA-Win64-Shipping.exe", 0x499D120, 0x520, 0x4A8, 0x0;
	float IGT: "ADACA-Win64-Shipping.exe", 0x4454308;
	int loading: "ADACA-Win64-Shipping.exe", 0x4408401;
}

init
{	
	// This is to know what version you are playing on
    	switch (modules.First().ModuleMemorySize) 
    	{ 
	case  82018304: version = "1.1.5";
	    break;
	case  82821120: version = "1.0.6"; 
	    break;
	default:        version = ""; 
	    break;
    	}
    	vars.prevStage = "";
	vars.IGT = 0;
}
start
{
    if((current.stage != "/Game/Maps/MenuLevel_E1") && (current.stage != null) && (current.stage != old.stage))
    {
	vars.IGT = 0;
	return true;
    }
}

split
{
    if((current.stage == null) && (old.stage != null))
    {
        vars.prevStage = old.stage;
    }
    if((current.stage != "/Game/Maps/MenuLevel_E1") && (current.stage != null) && (old.stage == null) && (current.stage != vars.prevStage))
    {
        return true;
    }
}

isLoading 
{
	if (current.loading == 0)
	{
		vars.IGT = current.IGT;
	}
	return current.loading == 0 || current.IGT == vars.IGT;
}
