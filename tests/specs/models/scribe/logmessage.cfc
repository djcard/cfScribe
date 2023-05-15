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
			title  = "logMessage should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					// rules                                                         = controller.getconfigSettings().veritiLogRules;
					rules[ "testing" ][ "info" ][ "noForceLog" ][ "notifyLocal" ] = [ "pusher" ];
					scribe                                                        = createMock( object = getInstance( "scribe@cfscribe" ) );
					scribe.$( method = "transformSeverity", returns = "" );
					scribe.$( method = "obtainDynamicTargets", returns = [] );
					scribe.$( method = "cleanError", returns = {} );
					scribe.setRules( rules );
				} );
				it( "should run transformSeverity 1x", function(){
					testme = scribe.logmessage(
						message   = " **************** yoyo *************************** ",
						extraInfo = {},
						severity  = "3"
					);
					expect( scribe.$count( "transformSeverity" ) ).tobe( 1 );
				} );
				it( "If no appenders are submitted, run obtainDynamicTargets 1x", function(){
					testme = scribe.logmessage(
						message   = " **************** yoyo *************************** ",
						extraInfo = {},
						severity  = "3"
					);
					expect( scribe.$count( "obtainDynamicTargets" ) ).tobe( 1 );
				} );
				it( "If appenders are submitted, run obtainDynamicTargets 0x", function(){
					testme = scribe.logmessage(
						message      = " **************** yoyo *************************** ",
						extraInfo    = {},
						severity     = "3",
						appenderList = [ "scribeConsole" ]
					);
					expect( scribe.$count( "obtainDynamicTargets" ) ).tobe( 0 );
				} );
				it( "If an argument collection is submitted, it should pass all arguments and all values from the argument collection append to obtainDynamicTargets", function(){
					var appendedStruct = {};
					appendedStruct[ "#mockData( $num = 1, $type = "words:1" )[ 1 ]#" ] = mockData(
						$num  = 1,
						$type = "words:1"
					)[ 1 ];

					scribe.$(
						method   = "obtainDynamicTargets",
						callBack = function(){
							var testme = arguments;
							expect( arguments[ 1 ] ).tobetypeof( "struct" );
							appendedStruct
								.keyArray()
								.each( function( item ){
									expect( testme[ 1 ] ).tohaveKey( item );
									expect( testme[ 1 ][ item ] ).tobe( appendedStruct[ item ] );
								} );
							return [];
						}
					);
					testme = scribe.logmessage(
						message             = " **************** This one *************************** ",
						extraInfo           = {},
						severity            = "6",
						attributeCollection = appendedStruct
					);
					expect( scribe.$count( "obtainDynamicTargets" ) ).tobe( 1 );
				} );
				it( "If the arguments are overloaded, the overloaded arguments should be sent to obtainDynamicTargets", function(){
					var key  = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var valu = mockData( $num = 1, $type = "words:1" )[ 1 ];

					scribe.$(
						method   = "obtainDynamicTargets",
						callBack = function(){
							var testme = arguments;
							expect( arguments[ 1 ] ).tobetypeof( "struct" );
							expect( testme[ 1 ] ).tohaveKey( "blarg" );
							expect( testme[ 1 ][ "blarg" ] ).tobe( valu );
							return [];
						}
					);
					testme = scribe.logmessage(
						message   = " **************** This one *************************** ",
						extraInfo = {},
						severity  = "6",
						blarg     = valu
					);
					expect( scribe.$count( "obtainDynamicTargets" ) ).tobe( 1 );
				} );





				it( "If there is extrainfo and cleanErrors is false, run cleanError 0x", function(){
					scribe.setCleanErrors( false );
					testme = scribe.logmessage(
						message      = " **************** yoyo *************************** ",
						extraInfo    = {},
						severity     = "3",
						appenderList = []
					);
					expect( scribe.$count( "cleanError" ) ).tobe( 0 );
				} );
				it( "If there is extrainfo and cleanErrors is true, run cleanError 1x", function(){
					scribe.setCleanErrors( true );
					testme = scribe.logmessage(
						message      = " **************** yoyo *************************** ",
						extraInfo    = {},
						severity     = "3",
						appenderList = []
					);
					expect( scribe.$count( "cleanError" ) ).tobe( 1 );
				} );
				it( "If there is extrainfo and cleanErrors is false but cleanError Is Submitted, run cleanError 1x", function(){
					scribe.setCleanErrors( false );
					testme = scribe.logmessage(
						message      = " **************** yoyo *************************** ",
						extraInfo    = {},
						severity     = "3",
						appenderList = [],
						cleanError   = true
					);
					expect( scribe.$count( "cleanError" ) ).tobe( 1 );
				} );
				it( "Run logmessage on the selected appender 1x", function(){
					fakeAppender = createMock( object = createstub() );
					fakeAppender.$(
						method   = "logMessage",
						callback = function(){
						}
					);
					scribe.setAppenders( { blarg : fakeAppender } );
					testme = scribe.logmessage(
						message      = " **************** yoyo *************************** ",
						extraInfo    = {},
						severity     = "3",
						appenderList = [ "blarg" ]
					);
					expect( fakeAppender.$count( "logMessage" ) ).tobe( 1 );
				} );
				it( "If the named appender is on the mandatoryKeys struct, run fillinKeys", function(){
					fakeAppender = createMock( object = createstub() );
					fakeAppender.$(
						method   = "logMessage",
						callback = function(){
						}
					);
					scribe.setAppenders( { blarg : fakeAppender } );
					scribe.setmandatoryKeys( { blarg : "heya" } );
					scribe.$( method = "fillInKeys", returns = {} );
					testme = scribe.logmessage(
						message      = " **************** yoyo *************************** ",
						extraInfo    = {},
						severity     = "3",
						appenderList = [ "blarg" ]
					);
					expect( scribe.$count( "fillInKeys" ) ).tobe( 1 );
				} );
				it( "send the logEvent and the title argument to the Appender", function(){
					fakeTitle    = mockdata( $num = 1, $type = "words:1" )[ 1 ];
					fakeMessage  = mockdata( $num = 1, $type = "words:1" )[ 1 ];
					fakeSeverity = randRange( 1, 4 );
					scribe.$( method = "transformSeverity", returns = fakeSeverity );
					fakeAppender = createMock( object = createstub() );
					fakeAppender.$(
						method   = "logMessage",
						callback = function(){
							expect( arguments[ 1 ] ).tobeinstanceof( "logEvent" );
							expect( arguments[ 1 ].getMessage() ).tobe( fakeMessage );
							expect( arguments[ 1 ].getSeverity() ).tobe( fakeseverity );
							expect( arguments[ 2 ] ).tobe( fakeTitle );
						}
					);
					scribe.setAppenders( { blarg : fakeAppender } );
					scribe.setmandatoryKeys( { blarg : "heya" } );
					scribe.$( method = "fillInKeys", returns = {} );
					testme = scribe.logmessage(
						message      = fakeMessage,
						extraInfo    = {},
						severity     = fakeseverity,
						appenderList = [ "blarg" ],
						title        = fakeTitle
					);
					expect( scribe.$count( "fillInKeys" ) ).tobe( 1 );
				} );
			}
		);
	}

}
