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
			title  = "ScreenDump should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					fakeProcessClass = mockData($num=1,$type="words:1")[1];
					fakeComponentReturn = mockData($num=1,$type="words:1")[1];
					fakeError = {};
					fakeComponent = createStub();
					fakeComponent.$(method="doClean",returns=fakeComponentReturn);

					testObj = createMock( object = getInstance( "scribe.LBFiles.util.ErrorFilter.ErrorFilterLB" ) );
					testObj.$(method="obtainProcessClass",returns=fakeProcessClass);
					testObj.$(method="createProcessClass",returns=fakeComponent);
				} );
				it( "should run ObtainprocessClass 1x`", function(){
					testme = testObj.run( fakeError );
					expect( testObj.$count("obtainProcessClass") ).tobe( 1 );
				} );
				it( "Should run createProcessClass 1x and pass in what was returned from obtainProcessClass", function(){
					testObj.$(method="createProcessClass",callBack = function(){
						expect(arguments[1]).tobe(fakeProcessClass);
					});
					testme = testObj.run( fakeError );
					expect( testObj.$count("createProcessClass") ).tobe( 1 );
				} );
				it( "Should run the doClean on the returned component", function(){
					testme = testObj.run( fakeError );
					expect( fakeComponent.$count("doClean") ).tobe( 1 );
				} );
			}
		);
	}

}
