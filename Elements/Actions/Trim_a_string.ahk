﻿iniAllActions.="Trim_a_string|" ;Add this action to list of all actions on initialisation

runActionTrim_a_string(InstanceID,ThreadID,ElementID,ElementIDInInstance)
{
	global
	local temp
	local Result
	local length
	local OptionOmitChars
	
	local Varname:=v_replaceVariables(InstanceID,ThreadID,%ElementID%Varname)
	if not v_CheckVariableName(varname)
	{
		logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Ouput variable name '" varname "' is not valid")
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% is not valid",lang("Ouput variable name '%1%'",varname)) )
		return
	}
	
	if %ElementID%expression=1
		temp:=v_replaceVariables(InstanceID,ThreadID,%ElementID%VarValue)
	else
		temp:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%VarValue)
	if temp=
	{
		logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Warning! Input string is empty")
	}
	
	if %ElementID%TrimWhat=1 ;Trim a number of characters
	{
		length:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%Length)
		if temp is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Length is not a number.")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% is not a number.",lang("Length")))
			return
		}
		if %ElementID%LeftSide=1
			StringTrimLeft,temp,temp,%ElementID%Length
		if %ElementID%RightSide=1
			StringTrimRight,temp,temp,%ElementID%Length
			
		v_SetVariable(InstanceID,ThreadID,Varname,temp)
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"normal")
	}
	else  ;Trim specific characters
	{
		if %ElementID%SpacesAndTabs=1
			OptionOmitChars:=" `t"
		else
		{
			OptionOmitChars:=v_replaceVariables(InstanceID,ThreadID,%ElementID%OmitChars)
			if temp=
			{
				logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Warning! Omit chars is empty")
			}
		}
		
		if (%ElementID%LeftSide=1 and %ElementID%RightSide=1)
			Result:=Trim(temp,OptionOmitChars)
		else if (%ElementID%LeftSide=1 and %ElementID%RightSide=0)
			Result:=LTrim(temp,OptionOmitChars)
		else if (%ElementID%LeftSide=0 and %ElementID%RightSide=1)
			Result:=RTrim(temp,OptionOmitChars)
		
		v_SetVariable(InstanceID,ThreadID,Varname,Result)
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"normal")
	}
	

	
	return
}
getNameActionTrim_a_string()
{
	return lang("Trim_a_string")
}
getCategoryActionTrim_a_string()
{
	return lang("Variable")
}

getParametersActionTrim_a_string()
{
	global
	parametersToEdit:=Object()
	parametersToEdit.push({type: "Label", label: lang("Output variable_name")})
	parametersToEdit.push({type: "Edit", id: "Varname", default: "NewVariable", content: "VariableName", WarnIfEmpty: true})
	parametersToEdit.push({type: "Label", label:  lang("Input string")})
	parametersToEdit.push({type: "Radio", id: "expression", default: 1, choices: [lang("This is a string"), lang("This is a variable name or expression")]})
	parametersToEdit.push({type: "Edit", id: "VarValue", default: "Hello World", content: "StringOrExpression", contentParID: "expression", WarnIfEmpty: true})
	parametersToEdit.push({type: "Label", label: lang("Operation")})
	parametersToEdit.push({type: "Radio", id: "TrimWhat", default: 1, choices: [lang("Remove a number of characters"), lang("Remove specific caracters")]})
	parametersToEdit.push({type: "Label", label: lang("Remove from which side")})
	parametersToEdit.push({type: "CheckBox", id: "LeftSide", default: 1, label: lang("Left-hand side")})
	parametersToEdit.push({type: "CheckBox", id: "RightSide", default: 0, label: lang("Right-hand side")})
	parametersToEdit.push({type: "Label", label: lang("Count of characters")})
	parametersToEdit.push({type: "Edit", id: "Length", default: 6, content: "Expression", WarnIfEmpty: true})
	parametersToEdit.push({type: "Label", label: lang("Which characters")})
	parametersToEdit.push({type: "Radio", id: "SpacesAndTabs", default: 1, choices: [lang("Spaces and tabs"), lang("Following characters")]})
	parametersToEdit.push({type: "Edit", id: "OmitChars", default: "%a_space%%a_tab%", content: "String"})

	return parametersToEdit
}

GenerateNameActionTrim_a_string(ID)
{
	global
	
	return % lang("Trim_a_string") "`n" GUISettingsOfElement%ID%Varname ", " GUISettingsOfElement%ID%VarValue
	
}

CheckSettingsActionTrim_a_string(ID)
{
	static previousLeftSide=0
	static previousRightSide=0
	
	if GUISettingsOfElement%ID%TrimWhat1=1 ;Trim a count of characters
	{
		GuiControl,Enable,GUISettingsOfElement%ID%Length
		GuiControl,Disable,GUISettingsOfElement%ID%SpacesAndTabs1
		GuiControl,Disable,GUISettingsOfElement%ID%SpacesAndTabs2
		GuiControl,Disable,GUISettingsOfElement%ID%OmitChars
	}
	else ;Trim specific characters
	{
		GuiControl,Disable,GUISettingsOfElement%ID%Length
		GuiControl,Enable,GUISettingsOfElement%ID%SpacesAndTabs1
		GuiControl,Enable,GUISettingsOfElement%ID%SpacesAndTabs2
		
		if GUISettingsOfElement%ID%SpacesAndTabs1=1
		{
			GuiControl,Disable,GUISettingsOfElement%ID%OmitChars
		}
		else
			GuiControl,Enable,GUISettingsOfElement%ID%OmitChars
	}
	
	
	if (GUISettingsOfElement%ID%LeftSide=0 and GUISettingsOfElement%ID%RightSide=0)
	{
		if previousRightSide=1
		{
			GuiControl,,GUISettingsOfElement%ID%LeftSide,1
			previousLeftSide=1
			previousRightSide=0
		}
		else
		{
			GuiControl,,GUISettingsOfElement%ID%RightSide,1
			previousRightSide=1
			previousLeftSide=0
		}
	}
	else
	{
		previousLeftSide:=GUISettingsOfElement%ID%LeftSide
		previousRightSide:=GUISettingsOfElement%ID%RightSide
	}
}