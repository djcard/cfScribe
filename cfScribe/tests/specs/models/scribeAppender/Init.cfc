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
			title  = "Init should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					mockName       = mockData( $type = "words:1", $num = 1 )[ 1 ];
					scribeAppender = createMock( object = createObject( "scribe.models.scribeAppender" ) );
					scribeAppender.$( method = "initDI" );
					scribeAppender.$( method = "initAppenders" );
				} );
				it( "Return the ScribeAppender Component", function(){
					testme = scribeAppender.init( mockName );
					expect( testme ).toBeInstanceOf( "ScribeAppender" );
				} );
				it( "Should run initDI 1x", function(){
					testme = scribeAppender.init( mockName );
					expect( scribeAppender.$count( "initDI" ) ).tobe( 1 );
				} );
				it( "Should run initAppenders 1x", function(){
					testme = scribeAppender.init( mockName );
					expect( scribeAppender.$count( "initAppenders" ) ).tobe( 1 );
				} );
				it( "getEnvVars() should be a struct", function(){
					testme = scribeAppender.init( mockName );
					expect( testme.getEnvVars() ).toBeTypeOf( "struct" );
				} );

				it( "If no arguments.properties.rules are passed, getRules should be the return from defaultRules()", function(){
					mockReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribeAppender.$( method = "defaultRules", returns = mockReturn );
					testme = scribeAppender.init( mockName );
					expect( testme.getRules() ).tobe( mockReturn );
				} );
				it( "If arguments.properties.rules are passed, getRules should be the passed in rules", function(){
					mockKey    = mockData( $num = 1, $type = "words:1" )[ 1 ];
					mockReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.init( mockname, { rules : { "#mockKey#" : mockReturn } } );
					expect( testme.getRules() ).tohavekey( mockKey );
					expect( testme.getRules()[ mockKey ] ).tobe( mockReturn );
				} );


				it( "If no arguments.properties.ruleDefinitions are passed, getRulesDefinitions should be the return from defaultVariablesList()", function(){
					mockReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribeAppender.$( method = "defaultRules", returns = mockReturn );
					testme = scribeAppender.init( mockname );
					expect( testme.getRuleDefinitions() ).toBeTypeOf( "array" );
					expect( testme.getRuleDefinitions()[ 1 ] ).tobe( "env:environment" );
				} );
				it( "If arguments.properties.ruleDefinitions are passed, getRulesDefinitions should be the passed properties.ruleDefinitions", function(){
					mockReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.init( mockName, { ruleDefinitions : [ "#mockKey#:#mockReturn#" ] } );
					expect( testme.getRuleDefinitions() ).toBeTypeOf( "array" );
					expect( testme.getRuleDefinitions()[ 1 ] ).tobe( "#mockKey#:#mockReturn#" );
				} );

				it( "If no arguments.properties.CleanErrors are passed, getCleanErrors should be False", function(){
					mockReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					scribeAppender.$( method = "defaultRules", returns = mockReturn );
					testme = scribeAppender.init( mockName );
					expect( testme.getCleanErrors() ).tobeFalse();
				} );

				it( "If arguments.properties.CleanErrors are passed, getCleanErrors should be the passed in value", function(){
					mockReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.init( mockName, { cleanErrors : mockReturn } );
					expect( testme.getCleanErrors() ).tobe( mockReturn );
				} );

				it( "If no arguments.properties. passed, getScribeSettings should be an empty Struct", function(){
					testme = scribeAppender.init( mockName );
					expect(
						testme
							.getScribeSettings()
							.keyArray()
							.len()
					).tobe( 0 );
				} );
				it( "If arguments.properties. passed, getScribeSettings should be be that whole struct", function(){
					mockReturn = mockData( $num = 1, $type = "words:1" )[ 1 ];
					testme     = scribeAppender.init( mockName, { cleanErrors : mockReturn } );
					expect( testme.getScribeSettings() ).tohavekey( "cleanErrors" );
					expect( testme.getScribeSettings().cleanErrors ).tobe( mockreturn );
				} );



				it( "getAppenders() should be an empty struct", function(){
					testme = scribeAppender.init( mockName );
					expect(
						testme
							.getAppenders()
							.keyArray()
							.len()
					).tobe( 0 );
				} );

				it( "If no arguments.properties.appenders are passed, getAppenderSettings should be the return from defaultAppenders()", function(){
					var mockKey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var mockVal = mockData( $num = 1, $type = "words:1" )[ 1 ];

					scribeAppender.$( method = "defaultAppenders", returns = { "#mockKey#" : mockVal } );
					testme = scribeAppender.init( mockName );

					expect( testme.getAppenderSettings() ).toBeTypeOf( "struct" );
					expect( testme.getAppenderSettings() ).tohavekey( mockKey );
					expect( testme.getAppenderSettings()[ mockKey ] ).tobe( mockVal );
				} );

				it( "If arguments.properties.appenders is passed, getAppenderSettings should be value submitted", function(){
					var mockKey = mockData( $num = 1, $type = "words:1" )[ 1 ];
					var mockVal = mockData( $num = 1, $type = "words:1" )[ 1 ];

					testme = scribeAppender.init( mockName, { appenders : { "#mockKey#" : mockVal } } );
					expect( testme.getAppenderSettings() ).toBeTypeOf( "struct" );
					expect( testme.getAppenderSettings() ).tohavekey( mockKey );
					expect( testme.getAppenderSettings()[ mockKey ] ).tobe( mockVal );
				} );
			}
		);
	}

}
