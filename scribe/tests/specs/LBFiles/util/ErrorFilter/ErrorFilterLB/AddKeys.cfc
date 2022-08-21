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
			title  = "AddKeys should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					fakeKey    = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeList   = mockData( $type = "words:5", $num = 1 )[ 1 ].replace( " ", ",", "all" );
					fakeMaster = { "#fakeKey#" : fakeList };

					fakeError = {};
					fakeList.each( function( item, idx ){
						fakeError[ item ]                       = mockData( $type = "words:1", $num = 1 )[ 1 ];
						fakeError[ item & randRange( 0, 100 ) ] = mockData( $type = "words:1", $num = 1 )[ 1 ];
					} );

					testobj = createmock( object = getInstance( "scribe.LBFiles.util.ErrorFilter.ErrorFilterLB" ) );
					testobj.settypeFields( fakeMaster );
				} );
				/*it('If the submitted error is empty, return a struct with each key with ''NA''', function() {
                    testme = testObj.addKeys(fakeKey, {});
                    expect(testme.keylist().listSort('text')).toBe(fakeList.listSort('text'));
                    testme
                        .keyArray()
                        .each(function(item) {
                            expect(testme[item].len()).tobe(0);
                        });
                });*/
				it( "if the fakeError has values the result should have the matching values", function(){
					testme = testObj.addKeys( fakeKey, fakeError );
					expect( testme.keylist().listSort( "text" ) ).toBe( fakeList.listSort( "text" ) );
					testme
						.keyArray()
						.each( function( item ){
							expect( testme[ item ] ).tobe( fakeError[ item ] );
						} );
				} );
				it( "any keys not in the 'fieldlist' should not be present", function(){
					testme = testObj.addKeys( fakeKey, fakeError );
					expect( testme.keylist().listSort( "text" ) ).toBe( fakeList.listSort( "text" ) );
					expect( testme.keylist().listlen() ).toBe( fakeList.listlen() );
					testme
						.keyArray()
						.each( function( item ){
							expect( testme[ item ] ).tobe( fakeError[ item ] );
						} );
				} );
				it( "If the removeAllBlankLines property is false, any blank keys should be present", function(){
					var newKey          = mockData( $num = 1, $type = "words:1" )[ 1 ];
					fakeError[ newKey ] = "";

					fakeMaster[ fakekey ] = fakeMaster[ fakekey ].listAppend( newKey );
					testObj.setremoveAllBlankLines( false );
					testme = testObj.addKeys( fakeKey, fakeError );
					expect( testme ).tohavekey( newKey );
					expect( testme[ newkey ].len() ).tobe( 0 );
				} );
				it( "If the removeAllBlankLines property is true, no blank keys should be present", function(){
					var newKey            = mockData( $num = 1, $type = "words:1" )[ 1 ];
					fakeError[ newKey ]   = "";
					fakeMaster[ fakekey ] = fakeMaster[ fakekey ].listAppend( newKey );
					testObj.setremoveAllBlankLines( true );
					testme = testObj.addKeys( fakeKey, fakeError );
					expect( testme ).nottohavekey( newKey );
				} );
			}
		);
	}

}
