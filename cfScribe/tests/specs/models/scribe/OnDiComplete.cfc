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
					testObj = createMock( object = getInstance( "scribe@cfscribe" ) );
					testObj.$( method = "cleanEnvVars", returns = {} );
				} );
				it( "call cleanEnvVars 1x", function(){
					testme = testObj.onDIComplete();
					expect( testObj.$count( "cleanEnvVars" ) ).tobe( 1 );
				} );

				it( "The environment should be set", function(){
					expect( testObj.getEnvironment().len() ).tobegt( 0 );
				} );
				it( "Coldbox should be set", function(){
					expect( testObj.getColdbox() ).tobeinstanceof( "controller" );
				} );
				it( "Logbox should be set", function(){
					expect( testObj.getLogbox() ).tobeinstanceof( "logbox" );
				} );
				it( "rules should be a struct", function(){
					expect( testObj.getRules() ).tobetypeof( "struct" );
				} );
				it( "ruleDefinitions should be an array", function(){
					expect( testObj.getRuledefinitions() ).tobetypeof( "array" );
				} );
				it( "getScribeSettings should be a struct", function(){
					expect( testObj.getScribeSettings() ).tobeTypeOf( "struct" );
				} );
				it( "rules should be a struct", function(){
					expect( testObj.getRules() ).tobetypeof( "struct" );
				} );
				it( "cfmlsengine should be set", function(){
					expect( testObj.getCfmlEngine().len() ).tobegt( 0 );
				} );
				it( "ErrorFilter should be set", function(){
					expect( testObj.getErrorFilter() ).tobeinstanceof( "errorFilter" );
				} );
				it( "cleanErrors should be set", function(){
					expect( testObj.getCleanErrors() ).tobeTypeOf( "boolean" );
				} );
				it( "coldboxsettings should be a struct", function(){
					expect( testObj.getColdboxSettings() ).tobetypeof( "struct" );
				} );
				it( "Configsettings should be a struct", function(){
					expect( testObj.getConfigSettings() ).tobetypeof( "struct" );
				} );
				it( "ModuleSettings should be a struct", function(){
					expect( testObj.getModuleSettings() ).tobetypeof( "struct" );
				} );
				it( "envVars should be a struct", function(){
					expect( testObj.getEnvVars() ).tobetypeof( "struct" );
				} );
				// it( "SystemAppenders should be a string", function(){
				//	expect( testObj.getSystemAppenders().len() ).tobegt( 0 );
				// } );
				it( "SystemAppenderPath should be a string", function(){
					expect( testObj.getSystemAppenderPath().len() ).tobegt( 0 );
				} );
				it( "MandatoryKeys should be a struct", function(){
					expect( testObj.getMandatoryKeys() ).tobeTypeOf( "struct" );
				} );
			}
		);
	}

}
