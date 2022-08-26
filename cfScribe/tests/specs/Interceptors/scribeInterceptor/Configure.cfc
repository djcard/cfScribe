/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" accessors="true" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/


	function run(){
		describe(
			title  = "CreateEmailBody should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					testObj = createObject( "cfscribe.interceptors.scribeInterceptor" );
					testObj.setController( getController() );
					testObj.configure();
				} );
				it( "should run the scribe.logMessage 1x", function(){
					expect(
						getController()
							.getInterceptorService()
							.getInterceptionStates()
							.onException
							.getMetaDataMap()
							.keyExists( "scribeInterceptor" )
					).tobeTrue();
				} );
			}
		);
	}

}
