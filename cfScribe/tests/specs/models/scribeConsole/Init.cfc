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
			title  = "HeaderLine should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = getInstance( "scribeConsole@cfscribe" );
				} );
				it( "should return an instance of scribeConsole ", function(){
					testme = scribe.init();
					expect( testme ).toBeInstanceOf( "scribeConsole" );
				} );
				it( "If there is no name submitted, have the name `scribeConsole`", function(){
					testme = scribe.init();
					expect( testme.getName() ).tobe( "scribeConsole" );
				} );
				it( "If a name is submitted, have that name", function(){
					var fakeName = mockdata( $type = "words:1", $num = 1 )[ 1 ];
					testme       = scribe.init( fakeName );
					expect( testme.getName() ).tobe( fakeName );
				} );
			}
		);
	}

}
