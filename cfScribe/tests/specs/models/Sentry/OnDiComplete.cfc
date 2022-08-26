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
			title  = "ScreenDump should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					sentryService = createMock( object = getInstance( "SentryService@sentry" ) );
					sentryService.$( method = "setEnabled", returns = false );
					scribe = createMock( object = getInstance( "Sentry@cfscribe" ) );
					scribe.$( method = "sentryInstalled", returns = true );
					scribe.setSentryService( sentryService );
				} );
				it( "If Sentry is not installed it should do nothing", function(){
					scribe.$( method = "sentryInstalled", returns = false );
					sentryService.$(
						method   = "setEnabled",
						callback = function(){
							expect( arguments[ 1 ] ).tobeFalse();
						}
					);
					testme = scribe.OnDiComplete();
					expect( sentryService.$count( "setEnabled" ) ).tobe( 0 );
				} );
				it( "If Sentry is installed it should call Sentry Service captureException 1x and pass in the logEvent", function(){
					scribe.$( method = "sentryInstalled", returns = true );
					sentryService.$(
						method   = "setEnabled",
						callback = function(){
							expect( arguments[ 1 ] ).toBeTrue();
						}
					);
					var testme = scribe.OnDiComplete();
					expect( sentryService.$count( "setEnabled" ) ).tobe( 1 );
				} );
			}
		);
	}

}
