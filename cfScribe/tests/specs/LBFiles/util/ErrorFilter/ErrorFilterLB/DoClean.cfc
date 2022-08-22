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
					fakeError={};
					fakeType=mockData($type='words:1',$num=1)[1];
					fakeKeysReturn = {"#mockData($type='words:1',$num=1)[1]#":mockData($num=1,$num=1)[1]};
					fakeTagContextReturn={"#mockData($type='words:1',$num=1)[1]#":mockData($num=1,$num=1)[1]};
					fakeStackTraceReturn = {"#mockData($type='words:1',$num=1)[1]#":mockData($num=1,$num=1)[1]};

					testObj = createMock( object = getInstance( "scribe.LBFiles.util.ErrorFilter.ErrorFilterLB" ) );
					testObj.$(method="addKeys",returns=fakeKeysReturn);
					testObj.$(method="trimAndFilterTagContext",returns=fakeTagContextReturn);
					testObj.$(method="trimAndFilterStackTrace",returns=fakeStackTraceReturn);
				} );
				it( "should run addKeys 1x", function(){
					testme = testObj.doClean( fakeError, fakeType );
					expect( testObj.$count("addKeys") ).tobe( 1 );
				} );
				it( "if the error passed in does not have a tagContext keys,  run trimAndFilterTagContext 0x", function(){
					testObj.$(method="trimAndFilterTagContext",callBack = function(){
						expect(arguments[1].keylist()).tobe(fakeKeysReturn.keyList());
						return fakeTagContextReturn;
					});
					testme = testObj.doClean( fakeError, fakeType );
					expect( testObj.$count("trimAndFilterTagContext") ).tobe( 0 );
				} );
				it( "if the error passed in does have a tagContext keys,  run trimAndFilterTagContext 1x", function(){
					var faker=mockData($type='words:1',$num=1)[1];
					fakeError.tagContext=[faker];
					testObj.$(method="trimAndFilterTagContext",callBack = function(){
						expect(arguments[1]).tobeTypeOf("array");
						expect(arguments[1][1]).tobe(faker);
						return fakeTagContextReturn;
					});
					testme = testObj.doClean( fakeError, fakeType );
					expect( testObj.$count("trimAndFilterTagContext") ).tobe( 1 );
				} );

				it( "if the error passed in does not have a stackTrace keys,  run trimAndFilterStackTrace 0x", function(){
					testObj.$(method="trimAndFilterStackTrace",callBack = function(){
							expect(arguments[1].keylist()).tobe(fakeKeysReturn.keyList());
						return fakeStackTraceReturn;
					});
					testme = testObj.doClean( fakeError, fakeType );
						expect( testObj.$count("trimAndFilterStackTrace") ).tobe( 0 );
				} );
				it( "if the error passed in does not have a stacktrack keys,  run trimAndFilterStackTrace 1x", function(){
					var faker=mockData($type='words:1',$num=1)[1];
					fakeError.stackTrace=faker;
					testObj.$(method="trimAndFilterTagContext",callBack = function(){
						expect(arguments[1]).tobe(faker);
						return fakeTagContextReturn;
					});
					testme = testObj.doClean( fakeError, fakeType );
					expect( testObj.$count("trimAndFilterStackTrace") ).tobe( 1 );
				} );
/*it( "Should run the doClean on the returned component", function(){
    testme = testObj.run( fakeError );
    expect( fakeComponent.$count("doClean") ).tobe( 1 );
} );*/
			}
		);
	}

}
