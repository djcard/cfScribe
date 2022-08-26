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
			title  = "initPusher should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = createMock( object = getInstance( "Pusher@cfscribe" ) );
					scribe.$( method = "initPusher" );
				} );
				it( "Application should have the key 'pusher'", function(){
					testme = scribe.onDiComplete();
					expect( scribe.$count( "initPusher" ) ).tobe( 1 );
				} );
			}
		);
	}

}
