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
			title  = "FilterTagContext should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					testobj = createmock( object = getInstance( "scribe.LBFiles.util.ErrorFilter.ErrorFilterLB" ) );
				} );
				it( "If an empty array is submitted, return an empty array", function(){
					testme = testObj.filterTagContext( [] );
					expect( testme.len() ).toBe( 0 );
				} );
				it( "The returned array should be equal or less than the tagContextLines property and each index in the array should be a struct with the keys in the tagContextFields property ", function(){
					var fakePhrase                           = mockData( $type = "words:5", $num = 1 )[ 1 ].listToArray( " " );
					var fakeLen                              = randRange( 1, 4 );
					var fakeArr                              = createArray( fakelen, "template" );
					fakeArr[ randRange( 1, fakearr.len() ) ] = {
						"template" : fakePhrase[ randRange( 1, fakePhrase.len() ) ]
					};
					testObj.setfilterPhrases( fakePhrase );

					testme = testObj.filterTagContext( fakearr );
					expect( testme.len() ).toBe( fakelen - 1 );
				} );
			}
		);
	}

	function createFakeStruct( required string fields ){
		var retme = {};
		fields
			.listToArray()
			.each( function( item ){
				retme[ item ] = mockdata( $type = "words:1", $num = 1 )[ 1 ];
			} );
		return retme;
	}

	function createArray( leng, fields ){
		var retme = [];
		for ( var x = 1; x <= leng; x = x + 1 ) {
			retme.append( createfakestruct( arguments.fields ) );
		}
		return retme;
	}

}
