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
			title  = "ProcessNextValue should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					fakeKey       = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeVal       = mockData( $type = "words:1", $num = 1 )[ 1 ];
					fakeRule      = { "#fakeVal#" : mockData( $type = "words:1", $num = 1 )[ 1 ] };
					wholeSettings = { "#fakeKey#" : fakeVal };
					scribe        = createMock( object = getInstance( "scribe@cfscribe" ) );
				} );
				it( "If the  itemsubmitted is a closure, it should evaluate it and return the result", function(){
					var fakeRet = mockData( $type = "words;1", $num = 1 )[ 1 ];
					var yoyo    = function(){
						return fakeRet;
					}
					testme = scribe.processNextValue( yoyo, {} );
					expect( testme ).tobe( fakeRet );
				} );
				it( "If the  itemsubmitted is an inline closure, it should evaluate it and return the result", function(){
					var fakeRet = mockData( $type = "words;1", $num = 1 )[ 1 ];
					testme      = scribe.processNextValue( function(){
						return fakeRet;
					}, {} );
					expect( testme ).tobe( fakeRet );
				} );

				it( "If the first item of the key submitted is `env`, it should return the value from getEnv() for the second item of that key if it exists (env:blah should return environmental variable blah) ", function(){
					scribe.setenvVars( wholeSettings );
					testme = scribe.processNextValue( "env:#fakeKey#", {} );
					expect( testme ).tobe( fakeVal );
				} );
				it( "If the first item of the key submitted is `env`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribe.setenvVars( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribe.processNextValue( "env:#badkey#", {} );
					expect( testme.len() ).tobe( 0 );
				} );


				it( "If the first item of the key submitted is `coldbox`, it should return the value from getColdbox() for the second item of that key if it exists (env:blah should return coldbox variable blah) ", function(){
					scribe.setcoldboxSettings( wholeSettings );
					testme = scribe.processNextValue( "coldbox:#fakeKey#", {} );
					expect( testme ).tobe( fakeVal );
				} );
				it( "If the first item of the key submitted is `coldbox`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribe.setcoldboxSettings( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribe.processNextValue( "coldbox:#badkey#", {} );
					expect( testme.len() ).tobe( 0 );
				} );

				it( "If the first item of the key submitted is `config`, it should return the value from configSettings for the second item of that key if it exists (env:blah should return config variable blah) ", function(){
					scribe.setConfigSettings( wholeSettings );
					testme = scribe.processNextValue( "config:#fakeKey#", {} );
					expect( testme ).tobe( fakeVal );
				} );
				it( "If the first item of the key submitted is `config`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribe.setConfigSettings( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribe.processNextValue( "config:#badkey#", {} );
					expect( testme.len() ).tobe( 0 );
				} );


				it( "If the first item of the key submitted is `moduleConfig`, it should return the value from configSettings for the second item of that key if it exists (env:blah should return config variable blah) ", function(){
					var modName       = mockData( $type = "words:1", $num = 1 )[ 1 ];
					var modVar        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					var modVal        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					var wholeSettings = { "#modName#" : { "#modVar#" : modVal } };
					scribe.setModuleSettings( wholeSettings );
					testme = scribe.processNextValue( "moduleConfig:#modvar#@#modName#", {} );
					expect( testme ).tobe( modVal );
				} );
				it( "If the first item of the key submitted is `moduleConfig`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribe.setModuleSettings( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribe.processNextValue( "moduleConfig:#badkey#", {} );
					expect( testme.len() ).tobe( 0 );
				} );

				it( "If the first item of the key submitted is `header`,run obtainHeaderValue 1x, pass in the name of the header and return what it returns", function(){
					var fakeHeaderName = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var fakeret        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribe.$(
						method   = "obtainHeaderValue",
						callBack = function(){
							expect( arguments[ 1 ] ).tobe( fakeHeaderName );
							return fakeret;
						}
					);
					testme = scribe.processNextValue( "header:#fakeHeaderName#", {} );
					expect( scribe.$count( "obtainHeaderValue" ) ).tobe( 1 );
					expect( testme ).tobe( fakeret );
				} );

				it( "If the first item of the key submitted is `header`,run obtainHeaderValue 1x, pass in the name of the header and return what it returns", function(){
					var fakeHeaderName = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var fakeret        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribe.$(
						method   = "obtainHeaderTF",
						callBack = function(){
							expect( arguments[ 1 ] ).tobe( fakeHeaderName );
							return fakeret.len() > 0;
						}
					);
					testme = scribe.processNextValue( "headerTrueFalse:#fakeHeaderName#", {} );
					expect( scribe.$count( "obtainHeaderTF" ) ).tobe( 1 );
					expect( testme ).tobe( fakeret.len() > 0 );
				} );

				it( "If the first item of the key submitted is `severity`,run transformSeverity 1x, pass in the name and  return what it returns", function(){
					var fakeHeaderName = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var fakeret        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribe.$(
						method   = "transformSeverity",
						callBack = function(){
							expect( arguments[ 1 ] ).tobe( fakeHeaderName );
							return fakeret;
						}
					);
					testme = scribe.processNextValue( "severity:#fakeHeaderName#", {} );
					expect( scribe.$count( "transformSeverity" ) ).tobe( 1 );
					expect( testme ).tobe( fakeret );
				} );

				it( "If the first item of the key submitted is `argument`,return that value from the passed in arguments if it exists", function(){
					var fakeHeaderName = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var fakeret        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme             = scribe.processNextValue(
						"argument:#fakeHeaderName#",
						{ "#fakeHeaderName#" : fakeret }
					);
					expect( testme ).tobe( fakeret );
				} );
			}
		);
	}

}
