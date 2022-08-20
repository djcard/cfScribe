/***
 * Creates an Appender for
 *
 **/
component extends="coldbox.system.logging.AbstractAppender" accessors="true" {

	property name="launchUtil"  default="";
	property name="timeout"     default="5000";
	property name="environment" default="";

	any function init( required string name = "toaster" ){
		createLauncher();
		super.init( name );
		return this;
	}

	/***
	 * Attempts to create the Java based LaunchUtil and set it to the LaunchUtil property
	 *
	 **/
	void function createLauncher(){
		try {
			setLaunchUtil( createObject( "java", "runwar.LaunchUtil" ) );
		} catch ( any err ) {
			systemOutput( "Toaster Appender could not be made" );
		}
	}

	void function logMessage( required coldbox.system.logging.LogEvent logEvent, string title = "" ){
		var finalTimeout = arguments.logEvent.getSeverity() == "error" ? 0 : getTimeout();

		launchUtil.displayMessage(
			arguments.title,
			arguments.logEvent.getSeverity(),
			arguments.logEvent.getMessage(),
			finalTimeout
		);
	}

}
