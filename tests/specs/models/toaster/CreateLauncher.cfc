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
			title  = "ScreenDump should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = createMock( object = getInstance( "toaster@cfscribe" ) );
				} );
				it( "Should make the LaunchUtil property the java launcher", function(){
					testme = scribe.createLauncher();
					expect( isSimpleValue( scribe.getLaunchUtil() ) ).tobeFalse();
				} );
			}
		);
	}

}
