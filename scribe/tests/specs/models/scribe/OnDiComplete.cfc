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
			title  = "OnDiComplete should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					testObj = createMock( object = getInstance( "scribe@scribe" ) );
					testObj.setscribeSettings( "" );
					testObj.$( method = "cleanEnvVars", returns = {} );
				} );
				it( "call cleanEnvVars 1x", function(){
					writeDump( testObj );
					testme = testObj.onDIComplete();
					expect( testObj.$count( "cleanEnvVars" ) ).tobe( 1 );
				} );
				it( "By default getCleanErrors should be False", function(){
					testme = testObj.onDIComplete();
					expect( testObj.getCleanErrors() ).tobeFalse();
				} );
				it( "If scribe modulesettings are defined but there is no cleanError key, be false", function(){
					testObj.setscribeSettings( { cleanErrors : false } );
					testme = testObj.onDIComplete();
					expect( testObj.getCleanErrors() ).tobeFalse();
				} );
				it( "If scribe modulesettings are defined but there is a cleanError key, be that value", function(){
					testObj.setscribeSettings( { cleanErrors : true } );
					testme = testObj.onDIComplete();
					expect( testObj.getCleanErrors() ).tobeTrue();
				} );
			}
		);
	}

}
