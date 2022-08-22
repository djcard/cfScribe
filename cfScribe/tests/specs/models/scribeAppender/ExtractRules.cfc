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
			title  = "ProcessNextValue should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					fakeKey        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeVal        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeRule       = { "#fakeVal#" : mockData( $type = "words:1", $num = 1 )[ 1 ] };
					wholeSettings  = { "#fakeKey#" : fakeVal };
					scribeAppender = createMock( object = createObject( "scribe.models.scribeAppender" ) );
				} );
				it( "if the submitted key exists in the submitted rules, return that node", function(){
					testme = scribeAppender.extractRules( fakeKey, wholeSettings );
					expect( testme ).tobe( fakeVal );
				} );
				it( "if the submitted key does not exist in the submitted rules, return an empty string", function(){
					testme = scribeAppender.extractRules( fakeKey & "a", wholeSettings );
					expect( testme.len() ).tobe( 0 );
				} );
			}
		);
	}

}
