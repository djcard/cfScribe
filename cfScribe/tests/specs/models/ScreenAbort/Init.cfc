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
					testObj = createMock( object = getInstance( "ScreenAbort@cfscribe" ) );
				} );
				it( "should return an instance of `screenAbort`", function(){
					testme = testObj.init();
					expect( testme ).toBeInstanceOf( "screenAbort" );
				} );
				it( "By default the name should be `screenAbort`", function(){
					expect( testObj.getName() ).tobe( "screenAbort" );
				} );
				it( "If a name is submitted, make that the name and remove special characters like `-`", function(){
					var fakeName = mockData( $type = "words:1", $num = 1 )[ 1 ];
					testObj.init( fakeName );
					expect( testObj.getName() ).tobe( fakeName );
				} );
			}
		);
	}

}
