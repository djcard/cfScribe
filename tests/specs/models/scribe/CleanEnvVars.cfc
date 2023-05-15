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
			title  = "CleanEnvVars should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = createMock( object = getInstance( "scribe@cfscribe" ) );
				} );
				it( "Should have the same keys as the system env", function(){
					testme = scribe.cleanEnvVars();
					expect(
						testme
							.keyArray()
							.sort( "textnocase" )
							.tolist()
					).tobe(
						createObject( "java", "java.lang.System" )
							.getEnv()
							.keyArray()
							.sort( "textnocase" )
							.tolist()
					);
				} );
			}
		);
	}

}
