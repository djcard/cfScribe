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
			title  = "ObtainHeaderValue should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = getInstance( "scribe@cfscribe" );
				} );
				it( "If the submitted header is not present, return a blank string", function(){
					testme = scribe.ObtainHeaderValue( "blarg " );
					expect( testme.len() ).tobe( 0 );
				} );
				it( "If the submitted header is present, return its value", function(){
					var fakeReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var event      = getRequestContext();
					prepareMock( event ).$(
						method   = "getHTTPHeader",
						callback = function(){
							if ( arguments[ 1 ].lcase() eq "x-import-debug" ) {
								return fakeReturn;
							}
							return "";
						}
					);
					testme = scribe.ObtainHeaderValue( "x-import-debug" );
					expect( testme ).tobe( fakeReturn );
				} );
			}
		);
	}

}
