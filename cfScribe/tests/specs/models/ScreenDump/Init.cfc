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
					testObj = createMock( object = getInstance( "screenDump@cfscribe" ) );
				} );
				it( "should return an instance of `screenDump`", function(){
					testme = testObj.init();
					expect( testme ).toBeInstanceOf( "screenDump" );
				} );
				it( "By default the name should be `screenDump`", function(){
					expect( testObj.getName() ).tobe( "screenDump" );
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
