component extends="coldbox.system.Interceptor" accessors="true" {

	property name="scribe" inject="scribe@cfscribe";

	function configure(){
		controller.getInterceptorService().registerInterceptor( interceptorObject = this );
		controller
			.getInterceptorService()
			.registerInterceptionPoint(
				interceptorKey = "scribeInterceptor",
				state          = "onException",
				oInterceptor   = this
			);
	}

	function onException(
		data = {},
		event,
		interceptData,
		prc,
		rc,
		buffer
	){
		getscribe().logMessage(
			message   = "Handled by Scribe Interceptor",
			severity  = "error",
			extraInfo = isStruct( arguments.data ) && arguments.data.keyExists( "exception" ) ? arguments.data.exception : arguments.data
		);
	}

}
