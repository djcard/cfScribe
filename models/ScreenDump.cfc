component extends="coldbox.system.logging.AbstractAppender" accessors="true" {

	property name="environment" inject="coldbox:setting:environment";

	function init( string name = "screenDump", struct properties = {} ){
		super.init( name );
		return this;
	}

	void function logMessage( required coldbox.system.logging.LogEvent logEvent ){
		doDump( logEvent.getMessage() );
		doDump( logevent.getExtraInfo() );
	}

	void function doDump( required any item ){
		writeDump( item );
	}
	void function doAbort(){
		abort;
	}

}
