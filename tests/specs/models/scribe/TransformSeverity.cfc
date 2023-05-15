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
			title  = "TransformSeverity should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = getInstance( "scribe@cfscribe" );
				} );
				it( "if it receives a number, run this.loglevels.lookup 1x", function(){
					createmock( object = scribe.loglevels );
					scribe.loglevels.$( method = "lookup" );
					testme = scribe.transformSeverity( 1 );
					expect( scribe.loglevels.$count( "lookup" ) ).tobe( 1 );
				} );
				it( "if it receives a string, return the string", function(){
					createmock( object = scribe.loglevels );
					mockState = mockdata( $type = "word:1", $num = 1 )[ 1 ];
					testme    = scribe.transformSeverity( mockstate );
					expect( testme ).tobe( mockState );
				} );
			}
		);
	}

}
