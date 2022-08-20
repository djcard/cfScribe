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
			title  = "DefaultAppenders should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribeAppender = createMock( object = createObject( "scribe.models.scribeAppender" ) );
				} );
				it( "Return an struct", function(){
					testme = scribeAppender.defaultAppenders();
					expect( testme ).toBeTypeOf( "struct" );
				} );
				it( "Each key should be a struct", function(){
					testme = scribeAppender.defaultAppenders();
					testme.each( function( item ){
						expect( testme[ item ] ).toBeTypeOf( "struct" );
					} );
				} );
				it( "Each key's struct should have the key `class`", function(){
					testme = scribeAppender.defaultAppenders();
					testme.each( function( item ){
						expect( testme[ item ] ).tohavekey( "class" );
					} );
				} );
			}
		);
	}

}
