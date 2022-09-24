/***
 * Acts as an interface between cfScribe and the Sentry Module
 *
 **/

component extends="coldbox.system.logging.AbstractAppender" accessors="true" {

	property name="wirebox"       inject="wirebox";
	property name="sentryService" inject="SentryService@sentry";
	property name="environment"   inject="coldbox:setting:environment";

	/***
	 * Inits the component
	 *
	 * @name The name by which this appender will be referenced
	 **/
	function init( required string name = "sentry" ){
		initSentry();
		super.init( name );
		return this;
	}

	function initSentry(){
		setSentryService( application.wirebox.getInstance( "sentryService@sentry" ) );
		getSentryService().setEnabled( true );
	}
	/***
	 * Sets the SentryService appender to true
	 *
	 **/
	function onDIComplete(){
		if ( sentryInstalled() ) {
			getSentryService().setEnabled( true );
		}
	}

	/***
	 * Returns whether the sentry module is installed in WireBox or not.
	 *
	 **/
	boolean function sentryInstalled(){
		return wirebox.containsInstance( "SentryService@sentry" );
	}

	/***
	 * Logs the actual error
	 *
	 * @logEvent A populated coldbox.system.logging.LogEvent component
	 **/
	void function logMessage( required coldbox.system.logging.LogEvent logEvent ){
		if ( sentryInstalled() ) {
			if ( isNull( getSentryService() ) || isSimpleValue( getSentryService() ) ) {
				initSentry();
			}

			return getSentryService().captureException(
				exception = logEvent.getExtraInfo(),
				level     = logevent.getSeverity()
			);
		}
	}

}
