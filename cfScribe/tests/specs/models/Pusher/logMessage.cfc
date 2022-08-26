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
					scribe = createMock( object = getInstance( "pusher@cfscribe" ) );
				} );
				it( "Simply passes the logEvent to the pusher jar file.", function(){
					// var message = mockData($num=1, $type="words:1")[1];
					// testme = scribe.logMessage(message="notify",severity=3,extraInfo={message:"|=0=|"});
					// writeDump(testme);

					var sendme = new coldbox.system.logging.LogEvent( "notify", 3 );
					sendme.setExtraInfo( { message : "|=0=|" } );
					testme = scribe.logMessage( sendme );
					expect( true ).tobeTrue();
				} );
			}
		);
	}

}
