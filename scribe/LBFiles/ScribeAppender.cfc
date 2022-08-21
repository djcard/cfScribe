component accessors="true" extends="coldbox.system.logging.AbstractAppender" {

	property name="environment"       default="";
	property name="coldbox"           default="";
	property name="logbox"            default="";
	property name="rules"             default="";
	property name="ruleDefinitions"   default="";
	property name="cfmlEngine"        default="";
	property name="errorFilter"       default="";
	property name="cleanErrors"       default="false";
	property name="settingsPopulated" default="false";
	property name="coldboxSettings"   default="";
	property name="configSettings"    default="";
	property name="moduleSettings"    default="";
	property name="appenders"         default="";
	property name="envVars"           default="";
	property name="doNotAddList"      default="";

	property name="typeFields"			default='';
	property name="tagContextLines"   default="3";
	property name="tagContextFields"  default="codePrintPlain,line,template";
	property name="filterPhrases" default="";
	property name="errorClasses" default="";
	property name="removeAllBlankLines" default="";


	variables.doNotAddList = [ "SCRIBEAPPENDER", "sentry_appender" ];



	/**
	 * Constructor
	 *
	 * @name       The unique name for this appender.
	 * @properties A map of configuration properties for the appender"
	 * @layout     The layout class to use in this appender for custom message rendering.
	 */
	function init(
		required name="scribeAppender",
		struct properties = {},
		layout            = ""
	){
		setEnvVars( cleanEnvVars() );
		setEnvironment( getEnvVars().environment );

		var combinedVars = allDefaults();
		combinedVars.append(arguments.properties,true);

		combinedVars.keyArray().each(function(item){
			variables[item] = combinedVars[item];
		});
		setAppenders( {} );

		initErrorFilter();
		super.init( argumentCollection = arguments );

		initDI();

		return this;
	}

	function initErrorFilter(){
		var properties = {
			typeFields : variables.typeFields,
			filterPhrases : variables.filterPhrases,
			errorClasses : variables.errorClasses,
			"tagContextLines" : variables.tagContextLines,
			"tagContextFields" : variables.tagContextFields,
			"removeAllBlankLines" : variables.removeAllBlankLines
		};
		try {
			var ef = new coldbox.system.logging.util.ErrorFilter.ErrorFilterLB(properties = properties);
		} catch(any err){
			var ef = new scribe.LBFiles.util.ErrorFilter.ErrorFilterLB(properties = properties);
		}
		setErrorFilter(ef);
	}

	function initAppenders(){
		// install the LogBox Appenders
		obtainLogboxAppenders().each( function( item ){
			if ( variables.doNotAddList.findNoCase( item ) == 0 ) {
				var className = getConfigSettings().LogBoxConfig.appenders[ item ].class.listlen( "." ) == 1
				 ? "coldbox.system.logging.appenders.#getConfigSettings().LogBoxConfig.appenders[ item ].class#"
				 : getConfigSettings().LogBoxConfig.appenders[ item ].class;
				var newAppender = new "#className#"(
					name       = item,
					properties = getConfigSettings().LogBoxConfig.appenders[ item ].keyExists( "properties" )
					 ? getConfigSettings().LogBoxConfig.appenders[ item ].properties
					 : {}
				).setLogBox( variables.logbox )
					.setColdBox( variables.coldbox )
					.setWireBox( variables.wirebox );
				variables.appenders[ item ] = newAppender;
			}
		} );

		// Install the local Appenders if the scribe module has been made.
		if ( fileExists( expandPath( "/scribe/ModuleConfig.cfc" ) ) ) {
			var appenderData = properties.appenders ?: defaultAppenders();

			appenderData?.each( function( item ){
				try {
					var newAppender = new "#appenderData[ item ].class#"(
						name = item, properties = appenderData[ item ].keyExists( "properties" ) ? appenderData[ item ].properties : {}
					);
				} catch ( any err ) {
					writeDump( err );
					abort;
				}
				// .setLogBox( this )
				// .setColdBox( variables.coldbox )
				// .setWireBox( variables.wirebox )
				// .setInitialized( true )
				// .setEnvironment( getEnvironment() );
				variables.appenders[ item ] = newAppender;
			} );
		} else {
			systemOutput( "Scribe module not made yet" );
		}
	}

	function obtainLogboxAppenders(){
		return getColdBox().getConfigSettings().LogBoxConfig.appenders;
	}

	/**
	 * Tries to populate the various settings properties from the existence of Coldbox which is injected by Coldbox on startup
	 *
	 **/
	function initDI(){
		if ( !isSimpleValue( getColdbox() ) ) {
			var coldBoxConfig = getColdBox().getConfigSettings();
			setCfmlEngine( getColdbox().getCFMLEngine().getEngine() );
			setColdboxSettings( getColdBox().getColdboxSettings() );
			setConfigSettings( coldBoxConfig );
			if ( coldBoxConfig.keyExists( "ModuleSettings" ) ) {
				setModuleSettings( coldBoxConfig.MODULESETTINGS );
			}
		}
	}

	function initDiComplete(){
		return !getEnvironment().len() &&
		!getCfmlEngine().len() &&
		!isSimpleValue( getColdboxSettings() ) &&
		!isSimpleValue( getConfigSettings() ) &&
		!isSimpleValue( getModuleSettings() );
	}

	function logMessage( required coldbox.system.logging.LogEvent logEvent ){
		var loge      = arguments.logEvent;
		var timestamp = loge.getTimestamp();
		var message   = loge.getMessage();
		var entry     = "";
		var severity  = logEvent.getSeverity();

		if ( !initDiComplete() ) {
			initDI();
			initAppenders();
		}

		var cleanedError = !isSimpleValue( logEvent.getExtraInfo() ) && getcleanerrors()
			? getErrorFilter().run( logEvent.getExtraInfo() )
			: logEvent.getExtraInfo();

		if ( isStruct(cleanedError) && !cleanedError.keyExists( "message" ) ) {
			cleanedError[ "message" ] = "";
		}

		logEvent.setExtraInfo(cleanedError);

		var targetList = !isNull( arguments.appendersList )
		 ? arguments.appendersList
		 : obtainDynamicTargets( arguments );

		targetList.each( function( item ){

			retme[ item ] = variables.appenders.keyExists( item ) ? variables.appenders[ item ].logMessage(
				logevent
			) : dump( var = "No appender defined for #item#", output = "console" );
		} );
		/*
// Message Layout
    if ( hasCustomLayout() ) {
      entry = getCustomLayout().format( loge );
    } else {
// Cleanup main message
      if ( len( loge.getExtraInfoAsString() ) ) {
        message &= " ExtraInfo: " & loge.getExtraInfoAsString();
      }

// Entry string
      entry = "#dateFormat( timestamp, "yyyy-mm-dd" )# #timeFormat( timestamp, "HH:MM:SS" )# #loge.getCategory()# #message#";
    }

// Log it
    switch ( logEvent.getSeverity() ) {
// Fatal + Error go to error stream
      case "0":
      case "1": {
// log message
        queueMessage( { message : entry, isError : true } );
        break;
      }
// Warning and above go to info stream
      default: {
// log message
        queueMessage( { message : entry, isError : false } );
        break;
      }
    }
*/
		return this;
	}


	/**
	 * Parses the error parameters and the rules to return the endpoints for logging
	 *
	 * @arg
	 **/
	array function obtainDynamicTargets( struct args ){
		var targets     = [];
		var ruleProcess = [ rules ];

		ruleDefinitions.each( function( item, idx ){
			var nextkey = processNextValue( item, args );

			if ( idx <= ruleProcess.len() && nextkey.len() ) {
				if ( isStruct( ruleProcess[ idx ] ) ) {
					ruleProcess.append( extractRules( nextkey, ruleProcess[ idx ] ) );
				} else {
					// writeDump( "exit" );
				}
			} else {
				// writeDump( "exit more" );
			}
		} );

		if ( isArray( ruleProcess.last() ) ) {
			targets.append( ruleProcess.last(), true );
		}


		return targets;
	}

	/**
	 * accepts
	 *
	 **/
	function processNextValue( required any key, struct args = {} ){
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
			elseif( action eq "config" ){
				return configSettings.keyExists( name ) ? configSettings[ name ] : "";
			}
			elseif( action eq "moduleConfig" ){
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
				return transformSeverity( name );
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

	/*** Variable Definitoin Parsers ***/
	/**
	 * Returns either the value of the submitted http header if it is present or an empty string
	 *
	 * @header The name of the header desired
	 **/

	string function obtainHeaderValue( required string header ){
		var event = !isNull( wirebox ) && wirebox.containsInstance( "coldbox:requestContext" ) ? wirebox.getInstance( "coldbox:requestContext" ) : "";
		return !isSimpleValue( event ) ? event.getHTTPHeader( header, "" ) : "";
	}

	/**
	 * Returns a value based on whether the submitted header is present in the request or not
	 *
	 * @header The name of the header desired
	 **/

	string function obtainHeaderTF( required string header ){
		var event = wirebox.getInstance( "coldbox:requestContext" );
		return event.getHTTPHeader( header, "" ).len() ? "true" : "false";
	}


	/*** Default Settings ***/

	function allDefaults(){
		return {
			rules : defaultRules(),
			ruleDefinitions: defaultRuleDefinitions(),
			typeFields: defaultTypeFields(),
			filterPhrases: defaultFilterPhrases(),
			errorClasses:defaultErrorClasses(),
			"tagContextLines"     : 3,
			"tagContextFields"    : "codePrintPlain,line,template",
			"removeAllBlankLines" : false,
			"cleanErrors": true
		};
	}


	/**
	 * Returns a default set of rules for various environments
	 *
	 **/
	function defaultRules(){
		return {
			"production"  : [],
			"development" : [ "scribeConsole" ],
			"testing"     : []
		};
	}


	/**
	 * Returns a default set of rule Definitions
	 **/
	array function defaultRuleDefinitions(){
		return [ "env:environment" ];
	}

	/**
	 * The default appender configuration. This can be copied and used as a base in the Coldbox settings
	 *
	 **/
	struct function defaultAppenders(){
		return {
			"screenDump"    : { "class" : "scribe.models.screenDump" },
			"screenAbort"   : { "class" : "scribe.models.screenAbort" },
			"scribeConsole" : { "class" : "scribe.models.systemOut" },
			"pusher"        : { "class" : "scribe.models.pusher", "properties" : {} },
			"sentry"        : { "class" : "scribe.models.sentry" },
			"toaster"       : { "class" : "scribe.models.toaster" }
		};
	}



	/*** Error Filtering Rules ***/
	/**
	 * Returns a list of fields to be included in the error filtering process
	 *
	 * @type The error type (i.e. database, expression, etc
	 **/
	struct function defaultTypeFields( required string type = "" ){
		return {
			"Database"   : "Datasource,Detail,ErrorCode,Message,NativeErrorCode,Sql,SqlState,Type,type,where,stackTrace",
			"Expression" : "Message,Detail,ErrNumber,ErrorCode,Extended_Info,ExtendedInfo,Type,TagContext,stackTrace",
			"general"    : "Message,Detail,tagContext,stackTrace"
		};

		//return typeFields.keyExists( type ) ? typeFields[ type ] : typeFields[ "general" ];
	}

	/**
	 * Returns default values by which to filter the indicies in the TagContext array based on the name of the template
	 *
	 **/
	array function defaultFilterPhrases(){
		return [
			"/modules/",
			"/lucee",
			"coldbox/system",
			"/testbox/"
		];
	}

	struct function cleanEnvVars(){
		var retme  = {};
		var allEnv = createObject( "java", "java.lang.System" ).getEnv();
		allEnv.each( function( item ){
			retme[ uCase( item ) ] = allEnv[ item ];
		} );

		return retme;
	};

	struct function defaultErrorClasses(){
		return {
			"Database"   : "coldbox.system.logging.util.errorFilter.databaseLB",
			"Expression" : "coldbox.system.logging.util.errorFilter.expressionLB",
			"Any"        : "coldbox.system.logging.util.errorFilter.generalLB"
		};
	};

}
