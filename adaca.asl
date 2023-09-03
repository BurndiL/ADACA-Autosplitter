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
	// Change timing method to Game Time if it is currently set to real time.
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
		var timingMessage = MessageBox.Show(
			"ADACA speedrunning rules requires the timer to be set to Game Time.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"It will now be changed to Game Time."+
			"(You can change it back to Real Time in (Right Click > Compare Against > Real Time)",
			"ADACA Autosplitter",	// Window title
			MessageBoxButtons.OK, MessageBoxIcon.Exclamation); // Window buttons
		
		timer.CurrentTimingMethod = TimingMethod.GameTime;
	}

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
	vars.ResetDateTime = DateTime.Now;
	vars.ShouldReset = false;
	vars.JustStarted = false;
}
start
{
    if((current.stage != "/Game/Maps/MenuLevel_E1") && (current.stage != null) && (current.stage != old.stage))
    {
	vars.IGT = current.IGT;
	vars.ResetDateTime = DateTime.Now;
	vars.ShouldReset = false;
	vars.JustStarted = true;
	return true;
    }
}

gameTime
{
    if (vars.JustStarted) 
    {
        vars.JustStarted = false;
        return TimeSpan.Zero;
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

reset 
{
	if (current.stage == "/Game/Maps/MenuLevel_E1")
	{
		if (!vars.ShouldReset) 
		{
			vars.ShouldReset = true;
			vars.ResetDateTime = DateTime.Now;
		} else {		
			if (DateTime.Now - vars.ResetDateTime > TimeSpan.FromMilliseconds(500))
			{
				return true;
			}
		}
	} else {
		vars.ShouldReset = false;
	}
	return false;
} 

isLoading 
{
	if (current.loading == 0)
	{
		vars.IGT = current.IGT;
	}
	return current.loading == 0 || current.IGT == vars.IGT;
}
