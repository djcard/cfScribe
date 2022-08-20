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
			title  = "ProcessNextValue should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					fakeKey        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeVal        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeRule       = { "#fakeVal#" : mockData( $type = "words:1", $num = 1 )[ 1 ] };
					wholeSettings  = { "#fakeKey#" : fakeVal };
					scribeAppender = createMock( object = createObject( "scribe.models.scribeAppender" ) );
				} );
				it( "If wirebox is not injected, return a blank string", function(){
					testme = scribeAppender.obtainHeaderValue( fakeKey );
					expect( testme.len() ).tobe( 0 );
				} );
				it( "If wirebox is present but the instance coldbox.requestContext doesn't exist, return a blank string", function(){
					scribeAppender.setWirebox( getWirebox() );
					testme = scribeAppender.obtainHeaderValue( fakeKey );
					expect( testme.len() ).tobe( 0 );
				} );
				it( "If wirebox is present but the instance coldbox.requestContext doesn't exist, return a blank string", function(){
					scribeAppender.setWirebox( getWirebox() );
					testme = scribeAppender.obtainHeaderValue( fakeKey );
					expect( testme.len() ).tobe( 5 );
				} );
			}
		);
	}

}
