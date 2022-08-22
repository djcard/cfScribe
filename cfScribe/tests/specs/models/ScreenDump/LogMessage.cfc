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
					testObj = createMock( object = getInstance( "ScreenAbort@cfscribe" ) );
					testObj.$( method = "doDump" );
					testObj.$( method = "doAbort" );
					fakeMessage = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeExtra   = {
						"#mockData( $type = "words:1", $num = 1 )[ 1 ]#" : mockData( $type = "words:1", $num = 1 )[ 1 ],
						"#mockData( $type = "words:1", $num = 1 )[ 1 ]#" : mockData( $type = "words:1", $num = 1 )[ 1 ]
					};
					fakeError = new coldbox.system.logging.LogEvent(
						message   = fakeMessage,
						extraInfo = fakeExtra,
						severity  = "info"
					);

					testme = testObj.logMessage( fakeError );
				} );
				it( "should run doDump 2x", function(){
					expect( testObj.$count( "doDump" ) ).tobe( 2 );
				} );
				it( "should first pass in the message, then pass in the extraInfo", function(){
					expect( testObj._MOCKCALLLOGGERS.doDump[ 1 ][ 1 ] ).tobe( fakeMessage );
					expect( testObj._MOCKCALLLOGGERS.doDump[ 2 ][ 1 ] ).tobeTypeOf( "struct" );
					expect( testObj._MOCKCALLLOGGERS.doDump[ 2 ][ 1 ].keylist() ).tobe( fakeExtra.keylist() );
					testObj._MOCKCALLLOGGERS.doDump[ 2 ][ 1 ]
						.keyArray()
						.each( function( item ){
							testObj._MOCKCALLLOGGERS.doDump[ 2 ][ 1 ][ item ] = fakeExtra[ item ];
						} );
				} );
			}
		);
	}

}
