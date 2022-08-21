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
					testObj = createMock( object = getInstance( "scribe.LBFiles.util.ErrorFilter.ErrorFilterLB" ) );
				} );
				it( "should return an instance of `ErrorFilterLb`", function(){
					testme = testObj.init();
					expect( testme ).toBeInstanceOf( "ErrorFilterLB" );
				} );
				it( "by Default all Properties should be blank`", function(){
					testme = testObj.init();
					expect( testme.gettypeFields().len() ).tobe( 0 );
					expect( testme.gettagContextLines().len() ).tobe( 0 );
					expect( testme.gettagContextFields().len() ).tobe( 0 );
					expect( testme.geterrorClasses().len() ).tobe( 0 );
					expect( testme.getfilterPhrases().len() ).tobe( 0 );
					expect( testme.getremoveAllBlankLines().len() ).tobe( 0 );
				} );
				it( "If a properties struct is submitted, all corresponding variable values will be populated`", function(){
					var properties = {
						typeFields=mockData($num=1,$type="words:1")[1],
						tagContextLines=mockData($num=1,$type="words:1")[1],
						tagContextFields=mockData($num=1,$type="words:1")[1],
						errorClasses=mockData($num=1,$type="words:1")[1],
						filterPhrases=mockData($num=1,$type="words:1")[1],
						removeAllBlankLines=mockData($num=1,$type="words:1")[1]
					};

					testme = testObj.init(properties);
						expect( testme.gettypeFields() ).tobe( properties.typeFields );
						expect( testme.gettagContextLines() ).tobe( properties.tagContextLines );
						expect( testme.gettagContextFields() ).tobe( properties.TagContextFields );
						expect( testme.geterrorClasses() ).tobe( properties.ErrorClasses );
						expect( testme.getfilterPhrases() ).tobe( properties.FilterPhrases );
						expect( testme.getremoveAllBlankLines() ).tobe( properties.RemoveAllBlankLines );
				} );
			}
		);
	}

}
