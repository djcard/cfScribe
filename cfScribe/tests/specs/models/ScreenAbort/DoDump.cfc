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
			title  = "DoDump should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
				} );
				it( "Only does writeDump. Limited Testing", function(){
					expect( true ).tobeTrue();
				} );
			}
		);
	}

}
