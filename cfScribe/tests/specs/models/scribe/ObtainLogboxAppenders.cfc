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
			title  = "debug should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = createMock( object = getInstance( "scribe@cfscribe" ) );
					// writeDump(scribe.getscribeSettings());
				} );
				it( "call logmessage 1x", function(){
					scribe.log( "I need to log this" );
					testme = scribe.obtainLogBoxAppenders();
					expect( scribe.$count( "logmessage" ) ).tobe( 1 );
				} );
			}
		);
	}

}
