--!strict

--[[
	//// 
		Written by Tenebris Noctua.
		Templates for Class++ log messages.
	////
--]]

return {
	attemptToModifyReadOnlyTable = "Cannot modify a read only table.",
	attemptToCreateObjectFromAbstractClass = "Cannot create an object from an abstracted class.",
	attemptToExtendAFinalClass = "Cannot create an inherited class from a final class.",
	cannotCallFunctionError = "Cannot call function directly.",
	classAlreadyExists = "Class \"%s\" already exists.",
	classDataNotTable = "Given ClassData value is not a table.",
	classDataContainsMetatable = "Given ClassData value contains a metatable.",
	classMemberNotFound = "This class has no member named \"%s\".",
	classNameNotString = "Class name is not a string or is nil.",
	classNameNotSet = "A class name is not set for the created class.",
	classNotFound = "A class with the given name cannot be found.",
	classNoMatchingFunctionError = "No match for %s function in this class.",
	classObjectLocked = "This class object has been locked.",
	classPropertyIsPrivate = "Property \"%s\" is private in this class.",
	classPropertyIsProtected = "Property \"%s\" is protected in this class.",
	classPropertyIsInternal = "Property \"%s\" is internal in this class. You cannot access it.",
	classPropertyRedeclaration = "Cannot redeclare property \"%s\".",
	expectedFunctionError = "Expected function, got: %s.",
	invalidAccessSpecifierError = "Invalid access specifier or function found in classData table. Make sure the names are correct.",
	invalidDestructorDecleration = "Cannot create reserved function \"Destroy\".",
	illegalModifierCombination = "Cannot create an illegal combination of modifiers: %s",
	nonNativeOperatorCall = "Operator function %s cannot be called without its operator.",
	overloadfunctionNameNotSet = "A function name has not been set for the overloaded function.",
	overloadfunctionTableNotGiven = "A function table has not been given for the overloaded function.",
	overloadfunctionArgumentMismatch = "A function to handle the given number of arguments (%d) have not been provided for the overloaded function: \"%s\"",
	typeofMetatableError = "A metatable for the given object cannot be found.",
	typeofObjectNotFound = "The given object's type cannot be found.",
	typeofObjectIsNotClass = "The given object is not a class type.",
	unknownError = "An unknown error has occured.",
}
