--!strict

--[[
	Written by @TenebrisNoctua.
	Stores templates for logging messages.
--]]

return {
	attemptToModifyReadOnlyTable = "Cannot modify a read only table.",
	attemptToCreateObjectFromAbstractClass = "Cannot create an object from an abstracted class.",
	attemptToExtendAFinalClass = "Cannot create an inherited class from a final class.",
	cannotCallFunctionError = "Cannot call function \"%s\" directly.",
	cannotCallFunctionFrom = "Cannot call function \"%s\" from \"%s\".",
	cannotFindBaseClassMethod = "Property \"%s\" cannot be found or is not a function in the base class \"%s\".",
	classAlreadyExists = "Class \"%s\" already exists.",
	classDataNotTable = "Given classData value for the class \"%s\" is not a table.",
	classDataContainsMetatable = "Given classData value for the class \"%s\" contains a metatable.",
	classMemberCannotSetToNil = "Class members cannot be set to nil.",
	classMemberNotFound = "This class has no member named \"%s\".",
	classNameNotString = "Class name is not a string or is nil.",
	classNotFound = "A class with the given name cannot be found.",
	classNoMatchingFunctionError = "No match for %s function in this class.",
	classObjectLocked = "This class object has been locked.",
	classPropertyIsPrivate = "Property \"%s\" is private in this class.",
	classPropertyIsProtected = "Property \"%s\" is protected in this class.",
	classPropertyIsInternal = "Property \"%s\" is internal in this class. You cannot access it.",
	classPropertyRedeclaration = "Cannot redeclare property \"%s\".",
	classTypeMismatch = "The class type \"%s\" does not match with the intended class type \"%s\".",
	expectedFunctionError = "Expected function, got: %s.",
	extendsDeprecated = "Extends is now deprecated. Use the \"class\" function instead.",
	invalidAccessSpecifierError = "Given value is not a valid access specifier.",
	invalidAccessSpecifierInClassData = "Given classData value for the class \"%s\" contains invalid access specifier(s) or function(s).",
	invalidClassNewIndex = "Cannot set a new property for the class \"%s\" that is an invalid access specifier or a function.",
	invalidConstructor = "The current function does not match with a valid constructor function in the class \"%s\", or within its inherited classes.",
	invalidDestructorCall = "Cannot call Destroy without an object argument. Try calling the function with the ':' operator.",
	invalidInheritation = "Cannot call super in a multi-inherited class, or in a non-inherited class.",
	invalidModifierArgument = "Given argument is not a class table.",
	invalidPropertyDecleration = "Cannot create reserved property \"%s\".",
	invalidSuperCall = "Cannot call super without an object argument. Try calling the function with the ':' operator.",
	illegalModifierCombination = "Cannot create an illegal combination of modifiers: %s",
	nonNativeOperatorCall = "Operator function %s cannot be called without its operator.",
	overloadfunctionArgumentMismatch = "A function to handle the given number of arguments (%d) have not been provided for the overloaded function: \"%s\"",
	overloadfunctionNameNotSet = "A function name has not been set for the overloaded function.",
	overloadfunctionTableNotGiven = "A function table has not been given for the overloaded function.",
	staticMemberNameNotSet = "A name has not been set for the static member.",
	typeofObjectNotFound = "The given object's type cannot be found.",
	unhandledError = "An unhandled error occured in \"%s\": %s",
	unknownError = "An unknown error has occured."
}