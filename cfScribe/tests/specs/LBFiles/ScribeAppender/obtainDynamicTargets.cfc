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
			title  = "ObtainTargets should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = createmock( object = getInstance( "scribe.LBfiles.ScribeAppender" ) );
				} );
				it( "if an environment is submitted use that as environment", function(){
					rules[ "testing" ][ "error" ][ "0" ][ "notifyAdmin" ] = [ "screen" ];
					scribe.setRules( rules );
					fakeVals   = { notifyAdmin : "notifyAdmin", severity : 1 };
					var testme = scribe.obtainDynamicTargets( fakeVals );
					writeDump( var = testme, label = "testme" );
					// expect( testme[ 1 ] ).tobe( fakeType );
				} );
				it( "if an environment is submitted use that as environment", function(){
					env                                                     = mockdata( $type = "oneof:production:development:testing", $num = 1 )[ 1 ];
					fakeEnv                                                 = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeType                                                = mockData( $type = "words:1", $num = 1 )[ 1 ];
					priority                                                = 2;
					forceLog                                                = "forceLog";
					notifyAdmin                                             = true;
					notifyLocal                                             = false;
					rules[ fakeEnv ][ "warn" ][ forcelog ][ "notifyAdmin" ] = [ fakeType ];
					scribe.setRules( rules );
					var testme = scribe.obtainDynamicTargets(
						fakeEnv,
						priority,
						forceLog,
						notifyAdmin,
						notifyLocal
					);
					expect( testme[ 1 ] ).tobe( fakeType );
				} );
			}
		);
	}

}
