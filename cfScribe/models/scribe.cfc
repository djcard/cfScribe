/**
 * Acts as a custom logger with additional logic from logbox
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
	property name="errorFilter" inject="errorFilter@errorFilter";
	property name="cleanErrors"        default="false";
	property name="coldboxSettings"    default="";
	property name="configSettings"     default="";
	property name="moduleSettings"     default="";
	property name="envVars"            default="";
	property name="systemAppenders"    default="";
	property name="systemAppenderPath" default="/coldbox/system/logging/appenders";
	property name="mandatoryKeys" inject="coldbox:setting:mandatoryKeys@cfscribe";

	function init(){
		super.init( {} );

		return this;
	}

	function onDIComplete(){
		var coldBoxConfig = getColdBox().getConfigSettings();
		setEnvVars( cleanEnvVars( createObject( "java", "java.lang.System" ).getEnv() ) );
		setCfmlEngine( getColdBox().getCFMLEngine().getEngine() );
		setCleanErrors(
			isStruct( scribeSettings ) && scribeSettings.keyExists( "cleanErrors" ) ? scribeSettings[ "cleanErrors" ] : getCleanErrors()
		);
		setColdboxSettings( getColdBox().getColdboxSettings() );
		setConfigSettings( coldBoxConfig );
		if ( coldBoxConfig.keyExists( "ModuleSettings" ) ) {
			setModuleSettings( coldBoxConfig.MODULESETTINGS );
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
				.setInitialized( true )
				.setEnvironment( getEnvironment() );
			addAppender( newAppender );
		} );
	}

	function obtainLogboxAppenders(){
		return getColdBox().getConfigSettings().LogBoxConfig.appenders;
	}

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
		string message   = "",
		any severity     = 3,
		struct extraInfo = {},
		array appenderList,
		string title = "",
		string cleanError
	){
		return logMessage(
			arguments.message,
			arguments.severity,
			arguments.extraInfo,
			arguments.appenderList ?: arguments.appenderList,
			arguments.title,
			arguments.cleanError ?: arguments.cleanError
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
		string message   = "",
		any severity     = 3,
		struct extraInfo = {},
		array appenderList,
		string title = "",
		boolean cleanError
	){
		var retme         = {};
		var severitylevel = transformSeverity( arguments.severity );
		var targetList    = !isNull( arguments.appenderList )
		 ? arguments.appenderList
		 : obtainDynamicTargets( arguments );

		var finalClean   = !isNull( arguments.cleanError ) ? arguments.cleanError : getCleanErrors();
		var cleanedError = !isSimpleValue( arguments.extraInfo ) && finalClean ? cleanError( extraInfo ) : arguments.extraInfo;

		if ( isStruct(cleanedError) && !cleanedError.keyExists( "message" ) ) {
			cleanedError[ "message" ] = "";
		}

		var logEvent = new coldbox.system.logging.LogEvent(
			message   = arguments.message,
			extraInfo = cleanedError,
			severity  = severitylevel
		);
		writeDump( var=logEvent, label="from scribe" )
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

	function fillInKeys( keyName, base ){
		var keyList = variables.mandatoryKeys.keyExists( keyName ) ? variables.mandatoryKeys[ keyname ] : "";
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
	 * @env         The environment in which this server is running. Ultimately defaults to the env setting
	 * @severity    The severity or severity of the error. Defaults to 3
	 * @forcelog    One of either 'forceLog' or 'noForceLog' depending on whether or not the 'X-Import-Debug' header is present in the call
	 * @notifyAdmin Whether or not to notify the admin of the error
	 * @notifyLocal Whether or not to notify the user of the error
	 **/
	array function obtainDynamicTargets( args ){
		var targets     = [];
		var ruleProcess = [ rules ];

		ruleDefinitions.each( function( item, idx ){
			var nextkey = processNextValue( item, args );
			if ( idx <= ruleProcess.len() && toString( nextkey ).len() ) {
				if ( isStruct( ruleProcess[ idx ] ) ) {
					ruleProcess.append( extractRules( nextkey, ruleProcess[ idx ] ) );
				}
			}
		} );

		if ( isArray( ruleProcess.last() ) ) {
			targets.append( ruleProcess.last(), true );
		}


		return targets;
	}


	function processNextValue( required any key, required struct args ){
		if ( isClosure( key ) ) {
			return key();
		} else {
			var action = key.listGetAt( 1, ":" );
			var name   = key.listGetAt( 2, ":" );

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
			}
			elseif( action eq "header" ){
				return obtainHeaderValue( name );
			}
			else if ( action eq "headerTrueFalse" ) {
				return obtainHeaderTF( name );
			}
			elseif( action eq "severity" ){
				return transformSeverity( args.keyExists( "severity" ) ? args.severity : name );
			}
			else {
				return "";
			}
		}
	}

	/**Checks the submited structure for the submitted key and either returns the selcted key Node or an empty string
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


	/** Submits a debug level log
	 *
	 * @message   The message to include
	 * @extraInfo
	 **/
	function debug( required string message = "", required struct extraInfo = {} ){
		return logMessage(
			message   = arguments.message,
			severity  = "4",
			extraInfo = arguments.extraInfo
		);
	}

	function info( required string message = "", required struct extraInfo = {} ){
		return logMessage(
			message   = arguments.message,
			severity  = "3",
			extraInfo = arguments.extraInfo
		);
	}

	function warn( required string message = "", required struct extraInfo = {} ){
		return logMessage(
			message   = arguments.message,
			severity  = "2",
			extraInfo = arguments.extraInfo
		);
	}

	function error( required string message = "", required struct extraInfo = {} ){
		return logMessage(
			message   = arguments.message,
			severity  = "1",
			extraInfo = arguments.extraInfo
		);
	}

	function fatal( required string message = "", required struct extraInfo = {} ){
		return logMessage(
			message   = arguments.message,
			severity  = "0",
			extraInfo = arguments.extraInfo
		);
	}

	function off( required string message = "", required struct extraInfo = {} ){
		return logMessage(
			message   = arguments.message,
			severity  = "-1",
			extraInfo = arguments.extraInfo
		);
	}

}
