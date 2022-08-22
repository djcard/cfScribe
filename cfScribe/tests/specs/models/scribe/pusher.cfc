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
			title  = "ScreenDump should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = getInstance( "scribe@cfscribe" );
				} );
				it( "should dump to the system. Testing limited", function(){
					testme = scribe.pusher(
						{ message : " **************** yoyo *************************** " },
						"warn"
					);
					writeDump( testme );
					expect( true ).tobeTrue();
				} );
				it( "", function(){
				} );
			}
		);
	}

}
