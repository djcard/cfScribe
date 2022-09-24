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
					sentryService.$( method = "captureException" );

					scribe = createMock( object = getInstance( "Sentry@cfscribe" ) );
					scribe.$( method = "sentryInstalled", returns = true );
					scribe.setSentryService( sentryService );

					message  = " **************** yoyo *************************** ";
					severity = "warn";
					try {
						var a = b;
					} catch ( any err ) {
						logEvent = new coldbox.system.logging.LogEvent(
							message   = message,
							extraInfo = err,
							severity  = severity
						);
					}
				} );
				it( "If Sentry is not installed it should do nothing", function(){
					scribe.$( method = "sentryInstalled", returns = false );
					sentryService.$( method = "captureException" );
					testme = scribe.logmessage( logevent );
					expect( sentryService.$count( "captureException" ) ).tobe( 0 );
				} );
				it( "If Sentry is installed it should call Sentry Service captureException 1x and pass in the logEvent", function(){
					scribe.$( method = "sentryInstalled", returns = true );
					sentryService.$(
						method   = "captureException",
						callback = function(){
							expect( arguments[ 1 ] ).tohavekey( "type" );
							expect( arguments[ 2 ] ).toBe( severity );
						}
					);
					var testme = scribe.logmessage( logevent );
					expect( sentryService.$count( "captureException" ) ).tobe( 1 );
				} );
			}
		);
	}

}
