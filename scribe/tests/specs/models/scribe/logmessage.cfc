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
			title  = "logMessage should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					// rules                                                         = controller.getconfigSettings().veritiLogRules;
					rules[ "testing" ][ "info" ][ "noForceLog" ][ "notifyLocal" ] = [ "pusher" ];
					scribe                                                        = createMock( object = getInstance( "scribe@scribe" ) );
					scribe.$( method = "transformSeverity", returns = "" );
					scribe.$( method = "obtainDynamicTargets", returns = [] );
					scribe.$( method = "cleanError", returns = {} );
					scribe.setRules( rules );
				} );
				it( "should run transformSeverity 1x", function(){
					testme = scribe.logmessage(
						message   = " **************** yoyo *************************** ",
						extraInfo = {},
						priority  = "3"
					);
					expect( scribe.$count( "transformSeverity" ) ).tobe( 1 );
				} );
				it( "If no appenders are submitted, run obtainDynamicTargets 1x", function(){
					testme = scribe.logmessage(
						message   = " **************** yoyo *************************** ",
						extraInfo = {},
						priority  = "3"
					);
					expect( scribe.$count( "obtainDynamicTargets" ) ).tobe( 1 );
				} );
				it( "If appenders are submitted, run obtainDynamicTargets 0x", function(){
					testme = scribe.logmessage(
						message       = " **************** yoyo *************************** ",
						extraInfo     = {},
						priority      = "3",
						appendersList = []
					);
					expect( scribe.$count( "obtainDynamicTargets" ) ).tobe( 0 );
				} );
				it( "If there is extrainfo and cleanErrors is false, run cleanError 0x", function(){
					scribe.setCleanErrors( false );
					testme = scribe.logmessage(
						message       = " **************** yoyo *************************** ",
						extraInfo     = {},
						priority      = "3",
						appendersList = []
					);
					expect( scribe.$count( "cleanError" ) ).tobe( 0 );
				} );
				it( "If there is extrainfo and cleanErrors is true, run cleanError 1x", function(){
					scribe.setCleanErrors( true );
					testme = scribe.logmessage(
						message       = " **************** yoyo *************************** ",
						extraInfo     = {},
						priority      = "3",
						appendersList = []
					);
					expect( scribe.$count( "cleanError" ) ).tobe( 1 );
				} );

				it( "more?", function(){
					expect( true ).tobeFalse();
				} );
			}
		);
	}

}
