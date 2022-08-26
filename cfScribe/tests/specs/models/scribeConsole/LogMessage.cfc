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
			title  = "Sysout should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe               = createmock( object = getInstance( "scribeConsole@cfscribe" ) );
					calcTableWidthReturn = randRange( 50, 100 );
					scribe.$( method = "calcTableWidth", returns = calcTableWidthReturn );
					scribe.$( method = "headerLine", returns = [] );
					scribe.$( method = "labelledLine", returns = [] );
					scribe.$( method = "writeToConsole", returns = [] );
					scribe.$( method = "writeSysOutTagContext", returns = [] );
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
				it( "Should run calcTableWidth 1x", function(){
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "calcTableWidth" ) ).tobe( 1 );
				} );
				it( "Should run headerLine 1x", function(){
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "headerLine" ) ).tobe( 2 );
				} );
				it( "Should run labelledLine 1x", function(){
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "labelledLine" ) ).tobe( 7 );
				} );
				it( "Should run writeToConsole 1x", function(){
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "writeToConsole" ) ).tobe( 10 );
				} );
				it( "Should run writeSysOutTagContext 1x", function(){
					testme = scribe.logmessage( logevent );
					expect( scribe.$count( "writeSysOutTagContext" ) ).tobe( 9 );
				} );
			}
		);
	}

}
