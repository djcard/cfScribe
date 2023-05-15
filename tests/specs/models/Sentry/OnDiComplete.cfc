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
					sentryService = createMock( object = getInstance( "SentryService@sentry" ) );
					sentryService.$( method = "setEnabled", returns = sentryService );
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
							return sentryService;
						}
					);
					testme = scribe.OnDiComplete();
					expect( sentryService.$count( "setEnabled" ) ).tobe( 0 );
				} );
				it( "Sentry should be enabled", function(){
					scribe.$( method = "sentryInstalled", returns = true );
					var testme = scribe.OnDiComplete();
					// writeDump( scribe.getsentryService() );
					expect( scribe.getsentryService().getEnabled() ).tobeTrue();
				} );
			}
		);
	}

}
