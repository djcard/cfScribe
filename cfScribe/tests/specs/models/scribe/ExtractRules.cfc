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
			title  = "CleanEnvVars should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = createMock( object = getInstance( "scribe@cfscribe" ) );
				} );
				it( "if the submitted struct has the submitted key, return that node", function(){
					mockKey=mockdata($num=1,$type="words:1")[1];
					mockStr = {"#mockKey#":mockdata($num=1,$type="words:1")[1]};
					testme = scribe.extractRules(mockKey,mockStr);
					expect( testme ).tobe( mockStr[mockKey] );
				} );
			}
		);
	}

}
