/**
 * Module Directives as public properties
 *
 * this.title 				= "Title of the module";
 * this.author 			= "Author of the module";
 * this.webURL 			= "Web URL for docs purposes";
 * this.description 		= "Module description";
 * this.version 			= "Module Version";
 * this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
 * this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.
 * this.entryPoint  		= "" (Optional) // If set, this is the default event (ex:forgebox:manager.index) or default route (/forgebox) the framework will use to create an entry link to the module. Similar to a default event.
 * this.cfmapping			= "The CF mapping to create";
 * this.modelNamespace		= "The namespace to use for registered models, if blank it uses the name of the module."
 * this.dependencies 		= "The array of dependencies for this module"
 *
 * structures to create for configuration
 * - parentSettings : struct (will append and override parent)
 * - settings : struct
 * - interceptorSettings : struct of the following keys ATM
 * 	- customInterceptionPoints : string list of custom interception points
 * - interceptors : array
 * - layoutSettings : struct (will allow to define a defaultLayout for the module)
 * - wirebox : The wirebox DSL to load and use
 *
 * Available objects in variable scope
 * - controller
 * - appMapping (application mapping)
 * - moduleMapping (include,cf path)
 * - modulePath (absolute path)
 * - log (A pre-configured logBox logger object for this object)
 * - binder (The wirebox configuration binder)
 * - wirebox (The wirebox injector)
 *
 * Required Methods
 * - configure() : The method ColdBox calls to configure the module.
 *
 * Optional Methods
 * - onLoad() 		: If found, it is fired once the module is fully loaded
 * - onUnload() 	: If found, it is fired once the module is unloaded
 **/
component {

	// Module Properties
	this.title              = "cfScribe";
	this.author             = "";
	this.webURL             = "";
	this.description        = "";
	this.version            = "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup   = true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint         = "cfScribe";
	// Inherit Entry Point
	this.inheritEntryPoint  = false;
	// Model Namespace
	this.modelNamespace     = "cfScribe";
	// CF Mapping
	this.cfmapping          = "cfScribe";
	// Auto-map models
	this.autoMapModels      = true;
	// Module Dependencies
	this.dependencies       = [ "errorFilter", "sentry" ];

	/**
	 * Configure the module
	 */
	function configure(){
		// parent settings
		parentSettings = {};

		// module settings - stored in modules.name.settings
		settings = {
			enableLogBoxAppender  : false,
			addAppenderToRoot     : false,
			disableSentryAppender : false,
			levelMin              : 0,
			levelMax              : 4,
			appenders             : {
				"screenDump"    : { "class" : "cfScribe.models.screenDump" },
				"screenAbort"   : { "class" : "cfScribe.models.screenAbort" },
				"scribeConsole" : { "class" : "cfScribe.models.scribeConsole" },
				"pusher"        : { "class" : "cfScribe.models.pusher", "properties" : {} },
				"sentry"        : { "class" : "cfScribe.models.sentry" },
				"toaster"       : { "class" : "cfScribe.models.toaster" }
			},
			rules : {
				"production"  : "",
				"development" : [ "screenDump" ],
				"testing"     : [ "screenDump" ]
			},
			"ruleDefinitions" : [ "property:environment" ],
			"cleanErrors"     : true,
			"mandatoryKeys"   : { "sentry" : "message" },
			"doNotAddList"    : [ "scribeAppender", "sentry_appender" ]
		};

		// Layout Settings
		layoutSettings = { defaultLayout : "" };

		// Custom Declared Points
		interceptorSettings = { customInterceptionPoints : [] };

		// Custom Declared Interceptors
		interceptors = [];

		// Binder Mappings
		// binder.map("Alias").to("#moduleMapping#.models.MyService");
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		controller.getInterceptorService().unregister( interceptorName = "ModuleConfig:sentry" );
		controller
			.getInterceptorService()
			.registerInterceptor( interceptorClass = "#moduleMapping#.interceptors.scribeInterceptor" );

		// Load the LogBox Appenders
		if ( settings.enableLogBoxAppender ) {
			loadAppenders();
		}
	}

	function afterAspectsLoad(){
		if ( settings.disableSentryAppender ) {
			logBox.getLoggerRegistry().ROOT.removeAppender( "sentry_appender" );
			var rootConfig = logBox.getConfig().getRoot();
			if ( rootConfig.appenders.listfindNoCase( "sentry_appender" ) > 0 ) {
				rootConfig.appenders = rootConfig.appenders.listDeleteAt(
					rootConfig.appenders.listfindNoCase( "sentry_appender" )
				);
			}
		}
		if ( settings.addAppenderToRoot ) {
			logBox.getLoggerRegistry()[ "Root" ].addAppender( logbox.getappenderRegistry().scribeAppender );
		}
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

	// **************************************** PRIVATE ************************************************//

	/**
	 * Load LogBox Appenders
	 */
	private function loadAppenders(){
		// Get config
		var logBoxConfig = logBox.getConfig();
		var rootConfig   = "";

		// Register tracer appender
		rootConfig = logBoxConfig.getRoot();
		logBoxConfig.appender(
			name     = "scribeAppender",
			class    = "#moduleMapping#.models.ScribeAppender",
			levelMin = settings.levelMin,
			levelMax = settings.levelMax
		);
		logBoxConfig.root(
			levelMin  = rootConfig.levelMin,
			levelMax  = rootConfig.levelMax,
			appenders = listAppend( rootConfig.appenders, "scribeAppender" )
		);

		// Store back config
		logBox.configure( logBoxConfig );
	}

}
