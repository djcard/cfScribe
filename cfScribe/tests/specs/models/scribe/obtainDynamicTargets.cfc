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
			title  = "ObtainDynamicTargets should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					item1 = mockData( $num = 1, $type = "words:1" )[ 1 ];
					item2 = mockData( $num = 1, $type = "words:1" )[ 1 ];
					item3 = mockData( $num = 1, $type = "words:1" )[ 1 ];
					item4 = mockData( $num = 1, $type = "words:1" )[ 1 ];
					item5 = mockData( $num = 1, $type = "words:1" )[ 1 ];
					rules = {
						"a" : [ item1 ],
						"b" : {
							"c" : [ item3, item5 ],
							"d" : { "e" : [ item4 ], "f" : [ item2 ] }
						}
					};
					scribe = createmock( object = getInstance( "scribe@cfscribe" ) );
					scribe.setRules( rules );
					scribe.setRuleDefinitions( [
						function(){
							return "a"
						}
					] );
				} );
				it( "Should call processNextValue 1x per rule definition", function(){
					fakeVals   = { notifyAdmin : "notifyAdmin", severity : 1 };
					var testme = scribe.obtainDynamicTargets( fakeVals );
					expect( testme.len() ).tobe( 1 );
					expect( testme[ 1 ] ).tobe( item1 );
				} );
				it( "single level rules", function(){
					scribe.setRuleDefinitions( [
						function(){
							return "a"
						},
						function(){
							return "b"
						}
					] );
					fakeVals   = { notifyAdmin : "notifyAdmin", severity : 1 };
					var testme = scribe.obtainDynamicTargets( fakeVals );
					expect( testme.len() ).tobe( 1 );
					expect( testme[ 1 ] ).tobe( item1 );
				} );
				it( "should process multilevel rules", function(){
					scribe.setRuleDefinitions( [
						function(){
							return "b"
						},
						function(){
							return "c"
						}
					] );
					fakeVals   = { notifyAdmin : "notifyAdmin", severity : 1 };
					var testme = scribe.obtainDynamicTargets( fakeVals );
					expect( testme.len() ).tobe( 2 );
					expect( testme[ 1 ] ).tobe( item3 );
					expect( testme[ 2 ] ).tobe( item5 );
				} );
				it( "Even if there are more rules, when the last node extracted is an array, stop processing", function(){
					scribe.setRuleDefinitions( [
						function(){
							return "b"
						},
						function(){
							return "d"
						},
						function(){
							return "f"
						},
						function(){
							return "g"
						},
						function(){
							return "q"
						},
						function(){
							return "r"
						}
					] );
					fakeVals   = { notifyAdmin : "notifyAdmin", severity : 1 };
					var testme = scribe.obtainDynamicTargets( fakeVals );
					expect( testme.len() ).tobe( 1 );
					expect( testme[ 1 ] ).tobe( item2 );
				} );
			}
		);
	}

}
