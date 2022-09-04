/**
 * Acts as a custom logger with additional logic from logbox. This is meant to work within a coldbox application
 *
 * @environment The env of this system
 * @rules       A struct corresponding to environment /
 **/

component extends="coldbox.system.logging.Logger" accessors="true" {

	property name="environment"     inject="coldbox:setting:environment";
	property name="coldbox"         inject="coldbox";
	property name="logbox"          inject="logbox";
	property name="rules"           inject="coldbox:setting:rules@cfscribe";
	property name="ruleDefinitions" inject="coldbox:setting:ruleDefinitions@cfscribe";
	property name="wirebox"         inject="wirebox";
	property name="scribeSettings"  inject="coldbox:moduleSettings:cfScribe";
	property name="cfmlEngine" default="";
	property name="errorFilter"     inject="errorFilter@errorFilter";
	property name="cleanErrors"     inject="coldbox:setting:cleanErrors@cfScribe";
	property name="coldboxSettings" inject="coldbox:coldboxsettings";
	property name="configSettings"  inject="coldbox:configsettings";
	property name="moduleSettings"     default="";
	property name="envVars"            default="";
	// property name="systemAppenders"    default="";
	property name="systemAppenderPath" default="/coldbox/system/logging/appenders";
	property name="mandatoryKeys" inject="coldbox:setting:mandatoryKeys@cfscribe";

	/***
	 * Constructor
	 *
	 **/
	function init(){
		super.init( {} );

		return this;
	}


	/***
	 *
	 **/
	function onDIComplete(){
		var coldBoxConfig = getColdBox().getConfigSettings();
		setEnvVars( cleanEnvVars( createObject( "java", "java.lang.System" ).getEnv() ) );
		setCfmlEngine( getColdBox().getCFMLEngine().getEngine() );
		if ( coldBoxConfig.keyExists( "ModuleSettings" ) ) {
			setModuleSettings( coldBoxConfig.MODULESETTINGS );
			// setScribeSettings(coldBoxConfig.moduleSettings.cfscribe);
		}

		obtainLogboxAppenders().each( function( item ){
			var className = coldBoxConfig.LogBoxConfig.appenders[ item ].class.listlen( "." ) == 1 ? "coldbox.system.logging.appenders.#coldBoxConfig.LogBoxConfig.appenders[ item ].class#" : coldBoxConfig.LogBoxConfig.appenders[
				item
			].class;
			var newAppender = new "#className#"(
				name       = item,
				properties = coldBoxConfig.LogBoxConfig.appenders[ item ].keyExists( "properties" )
				 ? coldBoxConfig.LogBoxConfig.appenders[ item ].properties
				 : {}
			).setLogBox( variables.logbox )
				.setColdBox( variables.coldbox )
				.setWireBox( variables.wirebox );

			addAppender( newAppender );
		} );

		scribeSettings?.appenders?.each( function( item ){
			var newAppender = new "#scribeSettings.appenders[ item ].class#"(
				name = item,properties = scribeSettings.appenders[ item ].keyExists( "properties" ) ? scribeSettings.appenders[
					item
				].properties : {}
			).setLogBox( this )
				.setColdBox( variables.coldbox )
				.setWireBox( variables.wirebox )
				.setInitialized( true );
			addAppender( newAppender );
		} );
	}

	function obtainLogboxAppenders(){
		return getColdBox().getConfigSettings().LogBoxConfig.appenders;
	}
	/*
	function obtainSystemAppenders(){
		// Registered system appenders
		setsystemAppenders(
			directoryList(
				expandPath( getSystemAppenderPath() ),
				false, // don't recurse
				"name", // only names
				"*.cfc" // only cfcs
			).map( function( thisAppender ){
				return listFirst( thisAppender, "." );
			} )
		);
	}
*/

	/**
	 * An alias for logmessage
	 *
	 * @message       a Custom message from the reporting code
	 * @severity      The severity or severity of the error
	 * @extraInfo     The error
	 * @appendersList Array of instantiated appender components
	 * @title         Only used with the Toaster Appender. Is the title of the dialog box
	 * @cleanError    whether to override the default cleanError Value
	 **/

	any function log(
		string message = "",
		any severity   = 3,
		any extraInfo  = {},
		array appenderList,
		string title = "",
		string cleanError,
		struct argumentCollection = {}
	){
		return logMessage(
			arguments.message,
			arguments.severity,
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			arguments.cleanError ?: arguments.cleanError,
			arguments
		);
	}

	/**
	 * Handles the logging of the error
	 *
	 * @message       a Custom message from the reporting code
	 * @severity      The severity or severity of the error
	 * @extraInfo     The error
	 * @appendersList Array of instantiated appender components
	 * @title         Only used with the Toaster Appender. Is the title of the dialog box
	 * @cleanError    whether to override the default cleanError Value
	 **/
	any function logMessage(
		string message = "",
		any severity   = 3,
		any extraInfo  = {},
		array appenderList,
		string title = "",
		boolean cleanError,
		argumentCollection = {}
	){
		var retme         = {};
		var severitylevel = transformSeverity( arguments.severity );
		var targetList    = !isNull( arguments.appenderList )
		 ? arguments.appenderList
		 : obtainDynamicTargets( arguments );
		var finalClean   = !isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors();
		var cleanedError = !isSimpleValue( arguments.extraInfo ) && finalClean ? variables.cleanError( extraInfo ) : arguments.extraInfo;

		var logEvent = new coldbox.system.logging.LogEvent(
			message   = arguments.message,
			extraInfo = cleanedError,
			severity  = severitylevel
		);

		targetList.each( function( item ){
			if ( variables.mandatoryKeys.keyExists( item ) ) {
				logEvent.setExtrainfo( fillInKeys( item, logEvent.getExtrainfo() ) );
			}


			retme[ item ] = variables.appenders.keyExists( item ) ? variables.appenders[ item ].logMessage(
				logevent,
				title
			) : dump( var = "No appender defined for #item#", output = "console" );
		} );

		return retme;
	}

	/***
	 * Ensures that a certain keys are present in the resultant struct to prevent errors downstream
	 *
	 * @appenderName The name of the appender to reference any mandatory keys
	 * @base         The struct which needs the keys added
	 **/
	function fillInKeys( required string appenderName, struct base = {} ){
		var keyList = variables.mandatoryKeys.keyExists( appenderName ) ? variables.mandatoryKeys[ appenderName ] : "";
		keyList
			.ListToArray()
			.each( function( item ){
				base[ item ] = base.keyExists( item ) ? base[ item ] : "";
			} );

		return base;
	}

	/*** Support Functions ***/
	/**
	 * Accepts whatever severity is set and ensures it is in the corresponding string state
	 *
	 * @severity The numeric or string version of the severity (0-4 or fatal - debug). Defaults to 3
	 **/
	string function transformSeverity( required severity = 3 ){
		return isNumeric( arguments.severity ) ? this.loglevels.lookup( arguments.severity ) : arguments.severity;
	}

	/**
	 * Parses the error parameters and the rules to return the endpoints for logging
	 *
	 * @args The arguments passed into LogMessage
	 **/
	array function obtainDynamicTargets( args ){
		var targets     = [];
		var ruleProcess = [ rules ];
		var rp          = rules;
		ruleDefinitions.each( function( item, idx ){
			var nextkey = processNextValue( item, args );

			var res = {};

			if ( isStruct( rp ) && toString( nextkey ).len() ) {
				res = extractRules( nextkey, rp )
				if ( isStruct( res ) ) {
					rp = res;
				} else if ( isArray( res ) ) {
					targets.append( res, true );
					continue;
				}
			}
		} );

		return targets;
	}

	/***
	 * Accepts one rule definition and evaluates it to determine the next level rule
	 *
	 * @key  The next rule definition to evaluate
	 * @args
	 **/
	function processNextValue( required any key, required struct args ){
		if ( isClosure( key ) ) {
			return key();
		} else {
			var action = key.listGetAt( 1, ":" );
			var name   = key.listlen( ":" ) gt 1 ? key.listGetAt( 2, ":" ) : action;

			if ( action eq "env" ) {
				return getEnvVars().keyExists( name ) ? getEnvVars()[ name ] : "";
			} else
				if ( action eq "coldbox" ) {
					return coldboxSettings.keyExists( name ) ? coldboxSettings[ name ] : "";
				}
			else if ( action eq "config" ) {
				return configSettings.keyExists( name ) ? configSettings[ name ] : "";
			} else if ( action eq "moduleConfig" ) {
				var moduleName = name.listlast( "@" );
				var varname    = name.listFirst( "@" );
				return moduleSettings.keyExists( moduleName ) && isStruct( moduleSettings[ moduleName ] ) && moduleSettings[
					moduleName
				].keyExists( varname ) ? moduleSettings[ moduleName ][ varname ] : "";
			} else if ( action eq "header" ) {
				return obtainHeaderValue( name );
			} else if ( action eq "headerTrueFalse" ) {
				return obtainHeaderTF( name );
			} else if ( action eq "severity" ) {
				return transformSeverity( args.keyExists( "severity" ) ? args.severity : name );
			} else if ( action eq "argument" ) {
				return args.keyExists( name ) ? args[ name ] : "";
			} else {
				return "";
			}
		}
	}

	/**Checks the submited structure for the submitted key and either returns the selected key Node or an empty string
	 *
	 * @key        The key desired (corresponds to the value of the next variable desired
	 * @ruleStruct The structure of rules being analyzed
	 **/
	function extractRules( required string  key = "", required struct ruleStruct = {} ){
		return ruleStruct.keyExists( key ) ? ruleStruct[ key ] : "";
	}




	/**
	 * Runs the error through the errorFilter module to filter out non-essential info
	 *
	 * @err The error to be filtered
	 **/
	any function cleanError( required any err = {} ){
		return getErrorFilter().run( err );
	}

	/***
	 * Returns a struct of all the java.lang.system variables with uppercase keys
	 *
	 **/
	struct function cleanEnvVars(){
		var retme  = {};
		var allEnv = createObject( "java", "java.lang.System" ).getEnv();
		allEnv.each( function( item ){
			retme[ uCase( item ) ] = allEnv[ item ];
		} );

		return retme;
	}

	/*** Variable Definitoin Parsers ***/
	/**
	 * Returns either the value of the submitted http header if it is present or an empty string
	 *
	 * @header The name of the header desired
	 **/

	string function obtainHeaderValue( required string header ){
		var event = wirebox.getInstance( "coldbox:requestContext" );
		return event.getHTTPHeader( header, "" );
	}

	/**
	 * Returns a value based on whether the submitted header is present in the request or not
	 *
	 * @header The name of the header desired
	 **/

	string function obtainHeaderTF( required string header ){
		var event = wirebox.getInstance( "coldbox:requestContext" );
		// writeDump(var='ForceLog header: #event.getHTTPHeader( "X-Import-Debug", "" )#',output="console");
		return event.getHTTPHeader( header, "" ).len() > 0 ? "true" : "false";
	}


	/***** Severity Level Functions ***/


	/***
	 * submits a debug log call
	 *
	 * @message       a Custom message from the reporting code
	 * @extraInfo     The error
	 * @appendersList Array of instantiated appender components
	 * @title         Only used with the Toaster Appender. Is the title of the dialog box
	 * @cleanError    whether to override the default cleanError Value
	 **/
	function debug(
		required string message = "",
		required any extraInfo  = {},
		array appenderList,
		title = "",
		cleanError,
		argumentCollection = {}
	){
		return logMessage(
			arguments.message,
			"4",
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			!isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors(),
			arguments
		);
	}

	/***
	 * submits a info log call
	 *
	 * @message       a Custom message from the reporting code
	 * @extraInfo     The error
	 * @appendersList Array of instantiated appender components
	 * @title         Only used with the Toaster Appender. Is the title of the dialog box
	 * @cleanError    whether to override the default cleanError Value
	 **/
	function info(
		required string message = "",
		required any extraInfo  = {},
		array appenderList,
		title = "",
		cleanError,
		argumentCollection = {}
	){
		return logMessage(
			arguments.message,
			"3",
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			!isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors(),
			arguments.append( arguments.argumentCollection )
		);
	}

	/***
	 * submits a warn log call
	 *
	 * @message       a Custom message from the reporting code
	 * @extraInfo     The error
	 * @appendersList Array of instantiated appender components
	 * @title         Only used with the Toaster Appender. Is the title of the dialog box
	 * @cleanError    whether to override the default cleanError Value
	 **/
	function warn(
		required string message = "",
		required any extraInfo  = {},
		array appenderList,
		title = "",
		cleanError,
		argumentCollection
	){
		return logMessage(
			arguments.message,
			"2",
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			!isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors(),
			arguments
		);
	}

	/***
	 * submits a error log call
	 *
	 * @message       a Custom message from the reporting code
	 * @extraInfo     The error
	 * @appendersList Array of instantiated appender components
	 * @title         Only used with the Toaster Appender. Is the title of the dialog box
	 * @cleanError    whether to override the default cleanError Value
	 **/
	function error(
		required string message = "",
		required any extraInfo  = {},
		array appenderList,
		string title = "",
		cleanError,
		struct argumentCollection
	){
		return logMessage(
			arguments.message,
			"1",
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			!isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors(),
			arguments
		);
	}

	/***
	 * submits a fatal log call
	 *
	 * @message       a Custom message from the reporting code
	 * @extraInfo     The error
	 * @appendersList Array of instantiated appender components
	 * @title         Only used with the Toaster Appender. Is the title of the dialog box
	 * @cleanError    whether to override the default cleanError Value
	 **/
	function fatal(
		required string message = "",
		required any extraInfo  = {},
		array appenderList,
		title = "",
		cleanError,
		argumentCollection
	){
		return logMessage(
			arguments.message,
			"0",
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			!isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors(),
			arguments
		);
	}

	function off(
		required string message = "",
		required any extraInfo  = {},
		array appenderList,
		title = "",
		cleanError
	){
		return logMessage(
			arguments.message,
			"-1",
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			!isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors()
		);
	}

}
