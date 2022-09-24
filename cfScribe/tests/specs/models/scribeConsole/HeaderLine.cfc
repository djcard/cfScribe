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
			title  = "HeaderLine should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe  = getInstance( "scribeConsole@cfscribe" );
					message = mockData( $num = 1, $type = "words:1" )[ 1 ];
					width   = randRange( 50, 80 );
				} );
				it( "should return a 3 index array ", function(){
					testme = scribe.headerLine( message, width );
					expect( testme ).toBeTypeOf( "array" );
				} );
				it( "The width of all three indicies should be the submitted width", function(){
					testme = scribe.headerLine( message, width );
					testme.each( function( item ){
						expect( item.len() ).tobe( width );
					} );
				} );
				it( "The first and last char of each line should be a |", function(){
					testme = scribe.headerLine( message, width );
					testme.each( function( item ){
						expect( item.right( 1 ) ).tobe( "|" );
						expect( item.left( 1 ) ).tobe( "|" );
					} );
				} );
				it( "There should be the width-2-message.len() spaces in the 2nd index", function(){
					testme        = scribe.headerLine( message, width );
					var allSpaces = testme[ 2 ]
						.listToArray( "" )
						.filter( function( char ){
							return char == " ";
						} );

					expect( allSpaces.len() ).tobe( width - 2 - message.len() );
				} );
				it( "There should be the width-2 '-' in the 1st and 3rd rows", function(){
					testme          = scribe.headerLine( message, width );
					var allHyphens1 = testme[ 1 ]
						.listToArray( "" )
						.filter( function( char ){
							return char == "-";
						} );
					expect( allHyphens1.len() ).tobe( width - 2 );

					var allHyphens2 = testme[ 3 ]
						.listToArray( "" )
						.filter( function( char ){
							return char == "-";
						} );
					expect( allHyphens2.len() ).tobe( width - 2 );
				} );
			}
		);
	}

}
