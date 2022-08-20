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
				it( "If the  itemsubmitted is a closure, it should evaluate it and return the result", function(){
					var fakeRet = mockData( $type = "words;1", $num = 1 )[ 1 ];
					var yoyo    = function(){
						return fakeRet;
					}
					testme = scribeAppender.processNextValue( yoyo );
					expect( testme ).tobe( fakeRet );
				} );
				it( "If the  itemsubmitted is an inline closure, it should evaluate it and return the result", function(){
					var fakeRet = mockData( $type = "words;1", $num = 1 )[ 1 ];
					testme      = scribeAppender.processNextValue( function(){
						return fakeRet;
					} );
					expect( testme ).tobe( fakeRet );
				} );

				it( "If the first item of the key submitted is `env`, it should return the value from getEnv() for the second item of that key if it exists (env:blah should return environmental variable blah) ", function(){
					scribeAppender.setenvVars( wholeSettings );
					testme = scribeAppender.processNextValue( "env:#fakeKey#" );
					expect( testme ).tobe( fakeVal );
				} );
				it( "If the first item of the key submitted is `env`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribeAppender.setenvVars( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.processNextValue( "env:#badkey#" );
					expect( testme.len() ).tobe( 0 );
				} );


				it( "If the first item of the key submitted is `coldbox`, it should return the value from getColdbox() for the second item of that key if it exists (env:blah should return coldbox variable blah) ", function(){
					scribeAppender.setcoldboxSettings( wholeSettings );
					testme = scribeAppender.processNextValue( "coldbox:#fakeKey#" );
					expect( testme ).tobe( fakeVal );
				} );
				it( "If the first item of the key submitted is `coldbox`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribeAppender.setcoldboxSettings( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.processNextValue( "coldbox:#badkey#" );
					expect( testme.len() ).tobe( 0 );
				} );

				it( "If the first item of the key submitted is `config`, it should return the value from configSettings for the second item of that key if it exists (env:blah should return config variable blah) ", function(){
					scribeAppender.setConfigSettings( wholeSettings );
					testme = scribeAppender.processNextValue( "config:#fakeKey#" );
					expect( testme ).tobe( fakeVal );
				} );
				it( "If the first item of the key submitted is `config`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribeAppender.setConfigSettings( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.processNextValue( "config:#badkey#" );
					expect( testme.len() ).tobe( 0 );
				} );


				it( "If the first item of the key submitted is `moduleConfig`, it should return the value from configSettings for the second item of that key if it exists (env:blah should return config variable blah) ", function(){
					var modName       = mockData( $type = "words:1", $num = 1 )[ 1 ];
					var modVar        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					var modVal        = mockData( $type = "words:1", $num = 1 )[ 1 ];
					var wholeSettings = { "#modName#" : { "#modVar#" : modVal } };
					scribeAppender.setModuleSettings( wholeSettings );
					testme = scribeAppender.processNextValue( "moduleConfig:#modvar#@#modName#" );
					expect( testme ).tobe( modVal );
				} );
				it( "If the first item of the key submitted is `moduleConfig`, it should return an empty string if there is no corresponding value for the second item in the key ", function(){
					scribeAppender.setModuleSettings( wholeSettings );
					var badkey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.processNextValue( "moduleConfig:#badkey#" );
					expect( testme.len() ).tobe( 0 );
				} );

				it( "If the first item of the key submitted is `header`,run obtainHeaderValue 1x, pass in the name of the header and return what it returns", function(){
					var fakeHeaderName = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var fakeret        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribeAppender.$(
						method   = "obtainHeaderValue",
						callBack = function(){
							expect( arguments[ 1 ] ).tobe( fakeHeaderName );
							return fakeret;
						}
					);
					testme = scribeAppender.processNextValue( "header:#fakeHeaderName#" );
					expect( scribeAppender.$count( "obtainHeaderValue" ) ).tobe( 1 );
					expect( testme ).tobe( fakeret );
				} );

				it( "If the first item of the key submitted is `header`,run obtainHeaderValue 1x, pass in the name of the header and return what it returns", function(){
					var fakeHeaderName = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var fakeret        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribeAppender.$(
						method   = "obtainHeaderTF",
						callBack = function(){
							expect( arguments[ 1 ] ).tobe( fakeHeaderName );
							return fakeret.len() > 0;
						}
					);
					testme = scribeAppender.processNextValue( "headerTrueFalse:#fakeHeaderName#" );
					expect( scribeAppender.$count( "obtainHeaderTF" ) ).tobe( 1 );
					expect( testme ).tobe( fakeret.len() > 0 );
				} );

				it( "If the first item of the key submitted is `severity`,run transformSeverity 1x, pass in the name and  return what it returns", function(){
					var fakeHeaderName = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var fakeret        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribeAppender.$(
						method   = "transformSeverity",
						callBack = function(){
							expect( arguments[ 1 ] ).tobe( fakeHeaderName );
							return fakeret;
						}
					);
					testme = scribeAppender.processNextValue( "severity:#fakeHeaderName#" );
					expect( scribeAppender.$count( "transformSeverity" ) ).tobe( 1 );
					expect( testme ).tobe( fakeret );
				} );
			}
		);
	}

}
