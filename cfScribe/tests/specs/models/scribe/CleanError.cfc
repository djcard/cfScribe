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
			title  = "CleanError should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe           = createMock( object = getInstance( "scribe@cfscribe" ) );
					mockFilterReturn = mockData( $type = "words:1", $num = 1 )[ 1 ];
					errorFilter      = createMock( object = getInstance( "errorFilter@errorFilter" ) );
					errorFilter.$( method = "run", returns = mockFilterReturn );
					scribe.setErrorFilter( errorFilter );
				} );
				it( "call getErrorFilter().run() 1x", function(){
					testme = scribe.cleanError();
					expect( errorFilter.$count( "run" ) ).tobe( 1 );
				} );
			}
		);
	}

}
