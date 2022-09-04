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
							expect( arguments.len() ).tobe( 7 );
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





				it( "If an argument collection is submitted, it should pass all arguments and all values from the argument collection append to obtainDynamicTargets", function(){
					var appendedStuct = {
						"#mockData( $num = 1, $type = "words:1" )[ 1 ]#" : mockData( $num = 1, $type = "words:1" )[ 1 ]
					};
					scribe.$(
						method   = "logMessage",
						callBack = function(){
							var testme = arguments;
							expect( arguments[ 7 ] ).tobetypeof( "struct" );
							appendedStuct
								.keyArray()
								.each( function( item ){
									expect( testme[ 7 ] ).tohaveKey( item );
									expect( testme[ 7 ][ item ] ).tobe( appendedStuct[ item ] );
								} );
							return [];
						}
					);
					testme = scribe.log(
						message            = " **************** This one *************************** ",
						extraInfo          = {},
						severity           = "6",
						argumentCollection = appendedStuct
					);
					expect( scribe.$count( "logMessage" ) ).tobe( 1 );
				} );
				it( "If the arguments are overloaded, the overloaded arguments should be sent to obtainDynamicTargets", function(){
					var key  = "#mockData( $num = 1, $type = "words:1" )[ 1 ]#";
					var valu = mockData( $num = 1, $type = "words:1" )[ 1 ];

					scribe.$(
						method   = "logMessage",
						callBack = function(){
							var testme = arguments;
							expect( arguments[ 7 ] ).tobetypeof( "struct" );
							expect( testme[ 7 ] ).tohaveKey( key );
							expect( testme[ 7 ][ key ] ).tobe( valu );
							return [];
						}
					);
					testme = scribe.log(
						message   = " **************** This one *************************** ",
						extraInfo = {},
						severity  = "6",
						"#key#"   = valu
					);
					expect( scribe.$count( "logMessage" ) ).tobe( 1 );
				} );
			}
		);
	}

}
