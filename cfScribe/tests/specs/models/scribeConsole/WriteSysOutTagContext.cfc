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
					testObj = createMock( object = getInstance( "scribeConsole@cfscribe" ) );
					testObj.$( method = "writeToConsole" );
					testObj.$( method = "labelledLine",returns=[] );
					testObj.$( method = "charSpacing",returns="" );
					testObj.$(
						method   = "headerLine",
						callback = function(){
							return [ arguments[ 1 ] ];
						}
					);
				} );
				it( "If a simple value is submitted, run writeToConsole 1x", function(){
					var fakeSub = mockdata( $num = 1, $type = "words:5" )[ 1 ];

					testObj.writeSysOutTagContext( fakeSub, 50, 100 );
					expect( testObj.$count( "writeToConsole" ) ).toBe( 1 );
					expect( testObj.$count( "headerLine" ) ).toBe( 1 );
					testObj.writeSysOutTagContext( 10, 50, 100 );
					expect( testObj.$count( "writeToConsole" ) ).toBe( 2 );
					expect( testObj.$count( "headerLine" ) ).toBe( 2 );
					testObj.writeSysOutTagContext( now(), 50, 100 );
					expect( testObj.$count( "writeToConsole" ) ).toBe( 3 );
					expect( testObj.$count( "headerLine" ) ).toBe( 3 );
					testObj.writeSysOutTagContext( true, 50, 100 );
					expect( testObj.$count( "writeToConsole" ) ).toBe( 4 );
					expect( testObj.$count( "headerLine" ) ).toBe( 4 );
				} );
				it( "if a struct is submitted, run writeToConsole and charSpacing 1x ", function(){
					var fakeSub = mockdata( $num = 1, $type = "words:5" )[ 1 ];

					testObj.writeSysOutTagContext( {}, 50, 100 );
					expect( testObj.$count( "writeToConsole" ) ).toBe( 1 );
					expect( testObj.$count( "charSpacing" ) ).toBe( 1 );
				} );
				it( "if a struct is submitted with a template key, run writeToConsole and labelledLine 1x ", function(){
					var fakeSub = mockdata( $num = 1, $type = "words:5" )[ 1 ];

					testObj.writeSysOutTagContext( {template:""}, 50, 100 );
						expect( testObj.$count( "writeToConsole" ) ).toBe( 2 );
						expect( testObj.$count( "labelledLine" ) ).toBe( 1 );
				} );
				it( "if a struct is submitted with a line key, run writeToConsole and labelledLine 1x ", function(){
					var fakeSub = mockdata( $num = 1, $type = "words:5" )[ 1 ];

					testObj.writeSysOutTagContext( {line:""}, 50, 100 );
						expect( testObj.$count( "writeToConsole" ) ).toBe( 2 );
						expect( testObj.$count( "labelledLine" ) ).toBe( 1 );
				} );
				it( "if a struct is submitted with a codePrintPlain key, run writeToConsole 1x + 1 per line in the key   and labelledLine 1x per line in the key ", function(){
					var fakeSub = mockdata( $num = 1, $type = "words:5" )[ 1 ];

					testObj.writeSysOutTagContext( {codePrintPlain:"a#chr(10)#B"}, 50, 100 );
						expect( testObj.$count( "writeToConsole" ) ).toBe( 3 );
						expect( testObj.$count( "labelledLine" ) ).toBe( 2 );
				} );
			}
		);
	}

}
