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
			title  = "log should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					// rules                                                         = controller.getconfigSettings().veritiLogRules;
					rules[ "testing" ][ "info" ][ "noForceLog" ][ "notifyLocal" ] = [ "pusher" ];
					scribe                                                        = createMock( object = getInstance( "scribe@cfscribe" ) );
					scribe.$( method = "logMessage", returns = "" );
					scribe.setRules( rules );
				} );
				it( "should run logMessage 1x", function(){
					testme = scribe.log(
						message   = " **************** yoyo *************************** ",
						extraInfo = {},
						priority  = "3"
					);
					expect( scribe.$count( "logMessage" ) ).tobe( 1 );
				} );
				it( "pass the correct data to logMessage ", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						message : " **************** yoyo *************************** ",
						type    : "blarg"
					};
					severity   = "4";
					testReturn = mockData( $type = "words:1", $num = 1 )[ 1 ];
					scribe.$(
						method   = "logmessage",
						callback = function(){
							expect( arguments[ "1" ] ).tobe( message );
							expect( arguments[ "2" ] ).tobe( severity );
							expect( arguments[ "3" ].keyList() ).tobe( extraInfo.keyList() );
							expect( arguments[ "4" ] ).tobeTypeOf( "array" );
							expect( arguments[ "5" ] ).tobe( testReturn );
							expect( arguments[ "6" ] ).tobe( true );
							expect( arguments.len() ).tobe( 6 );
						}
					);
					testme = scribe.debug(
						message      = message,
						severity     = severity,
						extraInfo    = extraInfo,
						appenderList = [],
						title        = testReturn,
						cleanError   = true
					);
					expect( scribe.$count( "logmessage" ) ).tobe( 1 );
				} );
			}
		);
	}

}
