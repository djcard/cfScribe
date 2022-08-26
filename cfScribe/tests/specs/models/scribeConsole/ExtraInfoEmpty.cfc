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
			title  = "ExtraInfoEmpty should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					scribe = getInstance( "scribeConsole@cfscribe" );
				} );
				it( "If an empty struct is submitted, return true", function(){
					testme = scribe.ExtraInfoEmpty( {} );
					expect( testme ).tobeTrue();
				} );







				it( "If an struct with a tagContext with length is submitted, return false", function(){
					testme = scribe.ExtraInfoEmpty( { tagContext : [ "hello" ] } );
					expect( testme ).tobeFalse();
				} );
			}
		);
	}

}
