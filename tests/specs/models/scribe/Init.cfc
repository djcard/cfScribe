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
		// super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/


	function run(){
		describe(
			title  = "Init should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = getInstance( "scribe@cfscribe" );
				} );
				it( "Return an instance of scribe", function(){
					testme = scribe.init();
					expect( testme ).toBeInstanceOf( "scribe" );
				} );
				it( "", function(){
				} );
			}
		);
	}

}
