component extends="coldbox.system.logging.AbstractAppender" accessors="true" {

	property name="environment" inject="coldbox:setting:environment";
	property name="appid"     default="";
	property name="key"       default="";
	property name="cluster"   default="";
	property name="apiSecret" default="";


	function init( string name = "Pusher", struct properties = {} ){
		var envVars = createObject( "java", "java.lang.System" ).getEnv();
		setAppid( arguments.properties.appId ?: envVars.PUSHER_APPID ?: "" );
		setCluster( arguments.properties.cluster ?: envVars.PUSHER_CLUSTER ?: "" );
		setApiSecret( arguments.properties.apiSecret ?: envVars.PUSHER_APISECRET ?: "" );
		setKey( arguments.properties.key ?: envVars.PUSHER_KEY ?: "" );
		setEnvironment( envVars.keyExists( "ENVIRONMENT" ) ? envVars.ENVIRONMENT : "" );
		super.init( name );

		if ( !application.keyExists( "pusher" ) || isSimpleValue( application.pusher ) ) {
			initPusher();
		}
		return this;
	}

	/***
	 * Initializes the application.pusher key after the DI is complete.
	 *
	 **/
	function onDiComplete(){
		if ( !application.keyExists( "pusher" ) || isSimpleValue( application.pusher ) ) {
			initPusher();
		}
	}

	/***
	 * Creates the Pusher
	 *
	 **/
	function initPusher(){
		if ( !application.keyExists( "pusher" ) || isSimpleValue( application.pusher ) ) {
			try {
				application.pusher = createObject( "java", "com.pusher.rest.Pusher" ).init(
					getAppid(),
					getKey(),
					getApiSecret()
				);
				application.pusher.setCluster( getCluster() );
				application.pusher.setEncrypted( true );

				application.Collections = createObject( "java", "java.util.Collections" );
			} catch ( any err ) {
				// systemOutput("Could Not create the Pusher Java componet. Make sure that it is in the /lib folder");
			}
		}
	}
	/**
	 * Handles outputting the error to the systemOutput in a formatted table
	 *
	 * @logEvent an instance of coldbox.system.logging.LogEvent
	 **/
	void function logMessage( required coldbox.system.logging.LogEvent logEvent ){
		if ( !application.keyExists( "pusher" ) ) {
			initpusher();
		} else {
			application.pusher.trigger(
				getenvironment(),
				logEvent.getMessage(),
				logEvent.getextraInfo()
			);
		}
	}

}
