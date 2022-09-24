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
			title  = "ScreenDump should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = getInstance( "scribeConsole@cfscribe" );
				} );
				it( "should return a string of the length of the submitted amount ", function(){
					var whatchar = randRange( 32, 126 );
					var length   = randRange( 1, 100 );
					testme       = scribe.charspacing( chr( whatchar ), length );
					expect( testme.len() ).tobe( length );
				} );
				it( "The entire string should be the char submitted", function(){
					var whatchar = randRange( 32, 126 );
					var length   = randRange( 1, 100 );
					testme       = scribe.charspacing( chr( whatchar ), length );
					testme
						.listToArray( "" )
						.each( function( item, idx ){
							expect( asc( item ) ).tobe( whatchar );
						} );
				} );
			}
		);
	}

}
