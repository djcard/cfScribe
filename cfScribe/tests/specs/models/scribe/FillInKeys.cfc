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
			title  = "debug should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					mockKey                = mockdata( $num = 1, $type = "words:1" )[ 1 ];
					mockStr                = {};
					mockStr[ "#mockKey#" ] = "#mockdata( $num = 1, $type = "words:1" )[ 1 ]#,#mockdata( $num = 1, $type = "words:1" )[ 1 ]#";
					scribe                 = createMock( object = getInstance( "scribe@cfscribe" ) );
				} );
				it( "If the name of the appender is in the mandatorykey property Struct, add a key for each item in the value", function(){
					scribe.setMandatoryKeys( mockStr );
					testme = scribe.fillInKeys( mockKey, {} );
					mockStr[ mockKey ]
						.listToArray()
						.each( function( item ){
							expect( testme ).toHaveKey( item );
						} );
				} );
				it( "If the name of the appender is not the mandatorykey property Struct, return it", function(){
					scribe.setMandatoryKeys( mockStr );
					testme = scribe.fillInKeys( "no", {} );
					mockStr[ mockKey ].each( function( item ){
						expect( testme.keyList() ).tobe( "" );
					} );
				} );
			}
		);
	}

}
