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
			title  = "debug should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = createMock( object = getInstance( "scribe@cfscribe" ) );
				} );
				it( "call logmessage 1x", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						message : " **************** yoyo *************************** ",
						type    : "blarg"
					};
					severity   = "WARN";
					testReturn = mockData( $type = "words:1", $num = 1 )[ 1 ];
					scribe.$( method = "logmessage", returns = testReturn );
					testme = scribe.fatal( message, extraInfo );
					expect( scribe.$count( "logmessage" ) ).tobe( 1 );
				} );
				it( "pass the correct data to logMessage ", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						message : " **************** yoyo *************************** ",
						type    : "blarg"
					};
					severity   = "0";
					testReturn = mockData( $type = "words:1", $num = 1 )[ 1 ];
					scribe.$(
						method   = "logmessage",
						callback = function(){
							expect( arguments[ "message" ] ).tobe( message );
							expect( arguments[ "severity" ] ).tobe( severity );
							expect( arguments[ "extraInfo" ].keyList() ).tobe( extraInfo.keyList() );
							expect( arguments[ "appenderList" ] ).tobeTypeOf( "array" );
							expect( arguments[ "title" ] ).tobe( testReturn );
							expect( arguments[ "cleanError" ] ).tobe( true );
							expect( arguments.keyArray().len() ).tobe( 7 );
						}
					);
					testme = scribe.fatal(
						message      = message,
						extraInfo    = extraInfo,
						appenderList = [],
						title        = testReturn,
						cleanError   = true
					);
					expect( scribe.$count( "logmessage" ) ).tobe( 1 );
				} );
				it( "should return what it receives from logMessage", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						message : " **************** yoyo *************************** ",
						type    : "blarg"
					};
					severity   = "WARN";
					testReturn = mockData( $type = "words:1", $num = 1 )[ 1 ];
					scribe.$( method = "logmessage", returns = testReturn );
					testme = scribe.fatal( message, extraInfo );
					expect( testme ).tobe( testReturn );
				} );
				it( "should pass message, priority (0), and extrainfo in that order", function(){
					message   = mockData( $type = "words:5", $num = 1 )[ 1 ];
					extraInfo = {
						message : " **************** yoyo *************************** ",
						type    : "blarg"
					};
					severity   = "WARN";
					testReturn = mockData( $type = "words:1", $num = 1 )[ 1 ];
					scribe.$(
						method   = "logmessage",
						callBack = function(){
							expect( arguments[ "message" ] ).tobe( message );
							expect( arguments[ "severity" ] ).tobe( 0 );
							expect( arguments[ "extraInfo" ] ).toBeTypeOf( "struct" );
							expect( arguments[ "extraInfo" ].keylist() ).tobe( extraInfo.keyList() );
						}
					);
					testme = scribe.fatal( message, extraInfo );
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
					testme = scribe.fatal(
						message             = " **************** This one *************************** ",
						extraInfo           = {},
						severity            = "6",
						attributeCollection = appendedStuct
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
							expect( arguments[ "attributeCollection" ] ).tobetypeof( "struct" );
							expect( testme[ "attributeCollection" ] ).tohaveKey( "blarg" );
							expect( testme[ "attributeCollection" ][ "blarg" ] ).tobe( valu );
							return [];
						}
					);
					testme = scribe.fatal(
						message   = " **************** This one *************************** ",
						extraInfo = {},
						severity  = "6",
						blarg     = valu
					);
					expect( scribe.$count( "logMessage" ) ).tobe( 1 );
				} );
			}
		);
	}

}
