﻿;Always add this element class name to the global list
AllElementClasses.push("Action_Select_file")

Element_getPackage_Action_Select_file()
{
	return "default"
}

Element_getElementType_Action_Select_file()
{
	return "action"
}

Element_getName_Action_Select_file()
{
	return lang("Select_file")
}

Element_getIconPath_Action_Select_file()
{
	return "Source_elements\default\icons\New variable.png"
}

Element_getCategory_Action_Select_file()
{
	return lang("User_interaction") "|" lang("Files")
}

Element_getParameters_Action_Select_file()
{
	return ["Varname", "title", "folder", "filter", "MultiSelect", "SaveButton", "fileMustExist", "PathMustExist", "PromptNewFile", "PromptOverwriteFile", "NoShortcutTarget"]
}

Element_getParametrizationDetails_Action_Select_file()
{
	parametersToEdit:=Object()
	parametersToEdit.push({type: "Label", label: lang("Output variable_name")})
	parametersToEdit.push({type: "Edit", id: "Varname", default: "selectedFiles", content: "VariableName", WarnIfEmpty: true})
	parametersToEdit.push({type: "Label", label: lang("Prompt")})
	parametersToEdit.push({type: "Edit", id: "title", default: lang("Select a file"), content: "String"})
	parametersToEdit.push({type: "Label", label: lang("Root directory")})
	parametersToEdit.push({type: "folder", id: "folder"})
	parametersToEdit.push({type: "Label", label: lang("Filter")})
	parametersToEdit.push({type: "Edit", id: "filter", default: lang("Any files") " (*.*)", content: "String"})
	parametersToEdit.push({type: "Label", label: lang("Options")})
	parametersToEdit.push({type: "checkbox", id: "MultiSelect", default: 0, label: lang("Allow to select multiple files")})
	parametersToEdit.push({type: "checkbox", id: "SaveButton", default: 0, label: lang("'Save' button instead of an 'Open' button")})
	parametersToEdit.push({type: "checkbox", id: "fileMustExist", default: 0, label: lang("File must exist")})
	parametersToEdit.push({type: "checkbox", id: "PathMustExist", default: 0, label: lang("Path must exist")})
	parametersToEdit.push({type: "checkbox", id: "PromptNewFile", default: 0, label: lang("Prompt to create new file")})
	parametersToEdit.push({type: "checkbox", id: "PromptOverwriteFile", default: 0, label: lang("Prompt to overwrite file")})
	parametersToEdit.push({type: "checkbox", id: "NoShortcutTarget", default: 0, label: lang("Don't resolve shortcuts to their targets")})

	return parametersToEdit
}

Element_run_Action_Select_file(Environment, ElementParameters)
{
	;~ d(ElementParameters, "element parameters")
	Varname := x_replaceVariables(Environment, ElementParameters.Varname)
	title := x_replaceVariables(Environment, ElementParameters.title)
	folder := x_replaceVariables(Environment, ElementParameters.folder)
	filter := x_replaceVariables(Environment, ElementParameters.filter)
	
	options:=0
	if (ElementParameters.fileMustExist)
		options+=1
	if (ElementParameters.PathMustExist)
		options+=2
	if (ElementParameters.PromptNewFile)
		options+=8
	if (ElementParameters.PromptOverwriteFile)
		options+=16
	if (ElementParameters.NoShortcutTarget)
		options+=32
	if (ElementParameters.SaveButton)
		options:="S" options
	if (ElementParameters.MultiSelect)
		options:="M" options
	
	inputVars:={options: options, folder: folder, title: title, filter: filter}
	outputVars:=["selectedFile", "result", "message"]
	code =
	( ` , LTrim %
	
		FileSelectFile,selectedFile,%options%,%folder%,%title%,%filter%
		if errorlevel
		{
			result := "exception"
			message := "User dismissed the dialog without selecting a file or system refused to show the dialog."
		}
		else
		{
			IfInString, options, m ;If multiselect, make a list
			{
				selectedFileCopy:=selectedFile
				selectedFile:=Object()
				Loop,parse,selectedFileCopy,`n
				{
					if a_index=1
						tempActionSelectFiledir:=A_LoopField
					else
						selectedFile.push(tempActionSelectFiledir "\" A_LoopField )
					
				}
			}
			
			result := "normal"
		}
	)
	;Translations: lang("User dismissed the dialog without selecting a file or system refused to show the dialog.")
	
	uniqueID := x_NewUniqueExecutionID(Environment)
	functionObject := x_NewExecutionFunctionObject(Environment, uniqueID, "Action_Select_file_FinishExecution", ElementParameters)
	x_SetExecutionValue(uniqueID, "functionObject", functionObject)
	x_SetExecutionValue(uniqueID, "Varname", Varname)
	x_ExecuteInNewThread(Environment, uniqueID, functionObject, code, inputVars, outputVars)
}

Action_Select_file_FinishExecution(Environment, values, ElementParameters)
{
	;~ d(values,"asdf")
	;~ d(ElementParameters,"asdf")
	uniqueID:=x_GetMyUniqueExecutionID(Environment)
	
	if (values.result="normal")
	{
		varname := x_GetExecutionValue(uniqueID, "Varname")
		if (ElementParameters.MultiSelect)
			x_SetVariable(Environment, Varname, values.selectedFile, "list")
		else
			x_SetVariable(Environment, Varname, values.selectedFile)
		x_finish(Environment,values.result, values.message)
	}
	else
	{
		x_finish(Environment,"exception", values.message)
	}
	x_DeleteMyUniqueExecutionID(uniqueID)
	
}


Element_GenerateName_Action_Select_file(Environment, ElementParameters)
{
	global
	return % lang("Select_file") " - " ElementParameters.varname " - " ElementParameters.folder
	
}

CheckSettingsActionSelect_file(ID)
{
	if (ElementParameters.MultiSelect = True)
	{
		x_Par_Disable(Environment,"SaveButton")
		x_Par_SetValue(Environment,"SaveButton", False)
	}
	else
	{
		x_Par_Enable(Environment,"SaveButton")
	}
	if (ElementParameters.SaveButton = True)
	{
		x_Par_Disable(Environment,"fileMustExist")
		x_Par_SetValue(Environment,"fileMustExist", False)
	}
	else
	{
		x_Par_Enable(Environment,"fileMustExist")
	}
}