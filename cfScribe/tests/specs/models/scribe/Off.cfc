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
			title  = "Off should",
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
					testme = scribe.off( message, extraInfo );
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
					testme = scribe.off( message, extraInfo );
					expect( testme ).tobe( testReturn );
				} );
				it( "should pass message, priority (-1), and extrainfo in that order", function(){
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
							expect( arguments[ 1 ] ).tobe( message );
							expect( arguments[ 2 ] ).tobe( -1 );
							expect( arguments[ 3 ] ).toBeTypeOf( "struct" );
							expect( arguments[ 3 ].keylist() ).tobe( extraInfo.keyList() );
						}
					);
					testme = scribe.off( message, extraInfo );
				} );
			}
		);
	}

}
