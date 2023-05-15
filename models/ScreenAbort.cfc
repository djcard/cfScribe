/***
 * Dumps out the Message and ExtraInfo from the error and abort the flow in order to return the error display to the client
 *
 **/
component extends="coldbox.system.logging.AbstractAppender" accessors="true" {

	/***
	 * Inits the Appender
	 *
	 * @name The name of this appender to be referenced in the cfScribe rules
	 **/
	function init( string name = "screenAbort" ){
		super.init( name );
		return this;
	}

	void function logMessage( required coldbox.system.logging.LogEvent logEvent ){
		doDump( logEvent.getMessage() );
		doDump( logevent.getExtraInfo() );
		doAbort();
	}

	void function doDump( required any item ){
		writeDump( item );
	}
	void function doAbort(){
		abort;
	}

}
