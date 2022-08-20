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
			title  = "DefaultFilterPhrases should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribeAppender = createMock( object = createObject( "scribe.models.scribeAppender" ) );
				} );
				it( "Return an array", function(){
					testme = scribeAppender.defaultFilterPhrases();
					expect( testme ).toBeTypeOf( "array" );
				} );
				it( "the array should have 4 items, /modules/, /lucee, coldbox/system, /testbox/", function(){
					var vals = [
						"/modules/",
						"/lucee",
						"coldbox/system",
						"/testbox/"
					];
					testme = scribeAppender.defaultFilterPhrases();
					expect( testme.len() ).tobe( 4 );
					vals.each( function( item ){
						expect( testme.findNoCase( item ) ).tobegt( 0 );
					} );
				} );
			}
		);
	}

}
