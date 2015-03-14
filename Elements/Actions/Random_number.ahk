﻿iniAllActions.="Random_number|" ;Add this action to list of all actions on initialisation

runActionRandom_number(InstanceID,ElementID,ElementIDInInstance)
{
	global
	local tempmin
	local tempmax
	local result
	
	if %ElementID%expressionmin=1
		tempmin:=v_replaceVariables(InstanceID,%ElementID%MinValue)
	else
		tempmin:=v_EvaluateExpression(InstanceID,%ElementID%MinValue)
	if %ElementID%expressiomax=1
		tempmax:=v_replaceVariables(InstanceID,%ElementID%MaxValue)
	else
		tempmax:=v_EvaluateExpression(InstanceID,%ElementID%MaxValue)
	;MsgBox,%  %ElementID%Varname "---" %ElementID%VarValue "---" v_replaceVariables(InstanceID,%ElementID%Varname) "---" v_replaceVariables(InstanceID,%ElementID%VarValue)
	if tempmin is number
	{
		if tempmax is number
		{
			Random,result,tempmin,tempmax
			v_SetVariable(InstanceID,v_replaceVariables(InstanceID,%ElementID%Varname),result)
			MarkThatElementHasFinishedRunning(InstanceID,ElementID,ElementIDInInstance,"normal")
		}
		else
			MarkThatElementHasFinishedRunning(InstanceID,ElementID,ElementIDInInstance,"exception")
	}
	else
		MarkThatElementHasFinishedRunning(InstanceID,ElementID,ElementIDInInstance,"exception")

	
	return
}
getNameActionRandom_number()
{
	return lang("Random_number")
}
getCategoryActionRandom_number()
{
	return lang("Variable")
}

getParametersActionRandom_number()
{
	global
	parametersToEdit:=["Label|" lang("Variable_name"),"VariableName|NewVariable|Varname","Label| " lang("Minimum value"),"Radio|1|expressionmin|" lang("This is a number") ";" lang("This is a variable name or expression") ,"Text|0|MinValue","Label| " lang("Maximum value"),"Radio|1|expressiomax|" lang("This is a number") ";" lang("This is a variable name or expression") ,"Text|100|MaxValue"]
	
	return parametersToEdit
}

GenerateNameActionRandom_number(ID)
{
	global
	
	return % lang("Random_number") "`n" GUISettingsOfElement%ID%Varname " = " GUISettingsOfElement%ID%VarValue
	
}