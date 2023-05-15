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
			title  = "debug should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
				} );
				it( "Returns a Coldbox key which should always be there. Testing limited", function(){
					expect( true ).tobeTrue();
				} );
			}
		);
	}

}
