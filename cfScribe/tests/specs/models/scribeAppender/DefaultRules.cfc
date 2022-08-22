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
			title  = "DefaultRules should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribeAppender = createMock( object = createObject( "cfScribe.models.scribeAppender" ) );
				} );
				it( "Return a struct", function(){
					testme = scribeAppender.defaultRules();
					expect( testme ).toBeTypeOf( "struct" );
				} );
				it( "To have the keys production, development, testing with development to have a default of screen", function(){
					testme = scribeAppender.defaultRules();
					expect( testme ).toHaveKey( "production" );
					expect( testme ).toHaveKey( "development" );
					expect( testme ).toHaveKey( "testing" );
					expect( testme.development.len() ).tobe( 1 );
					expect( testme.development[ 1 ] ).tobe( "screen" );
				} );
			}
		);
	}

}
