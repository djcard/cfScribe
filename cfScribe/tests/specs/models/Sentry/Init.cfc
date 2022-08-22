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
			title  = "Init should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					namer  = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribe = createMock( object = getInstance( "sentry@cfscribe" ) );
					scribe.init( namer );
				} );
				it( "Should return an instance of sentry", function(){
					testme = scribe.init();
					expect( testme ).tobeInstanceOf( "sentry" );
				} );
				it( "if no name is submitted, set the name property to sentry.", function(){
					scribe.init();
					expect( scribe.getName() ).tobe( "sentry" );
				} );
				it( "if a name is submitted, set the name property with that.", function(){
					scribe.init( namer );
					expect( scribe.getName() ).tobe( namer.replace( "-", "", "all" ) );
				} );
			}
		);
	}

}
