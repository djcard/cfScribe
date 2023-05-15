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
					scribe = getInstance( "scribeConsole@cfscribe" );
				} );
				it( "should return an instance of scribeConsole ", function(){
					testme = scribe.onDiComplete();
					expect( testme ).toBeInstanceOf( "scribeConsole" );
				} );
				it( "should set the cfmlEngine property to either lucee or adobe", function(){
					var engineArr = [ "lucee", "adobe" ];
					testme        = scribe.onDiComplete();
					expect( scribe.getCFMLEngine().len() ).tobegt( 0 );
					expect( engineArr.findNoCase( scribe.getCFMLEngine() ) ).tobegt( 0 );
				} );
			}
		);
	}

}
