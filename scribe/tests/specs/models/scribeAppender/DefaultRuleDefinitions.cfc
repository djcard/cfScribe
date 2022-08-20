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
			title  = "DefaultRuleDefinitions should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribeAppender = createMock( object = createObject( "scribe.models.scribeAppender" ) );
				} );
				it( "Return an array", function(){
					testme = scribeAppender.defaultRuleDefinitions();
					expect( testme ).toBeTypeOf( "array" );
				} );
				it( "The first index of the returned array should be env:environment ", function(){
					testme = scribeAppender.defaultRuleDefinitions();
					expect( testme[ 1 ] ).tobe( "env:environment" );
				} );
			}
		);
	}

}
