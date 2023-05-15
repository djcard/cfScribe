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
			title  = "Init should",
			labels = "automated",
			body   = function(){
				beforeEach( function(){
					namer        = mockData( $num = 1, $type = "words:1" )[ 1 ];
					fakeSettings = {
						appId     : mockData( $num = 1, $type = "words:1" )[ 1 ],
						cluster   : mockData( $num = 1, $type = "words:1" )[ 1 ],
						apiSecret : mockData( $num = 1, $type = "words:1" )[ 1 ],
						key       : mockData( $num = 1, $type = "words:1" )[ 1 ]
					};
					scribe = createMock( object = getInstance( "Pusher@cfscribe" ) );
					scribe.$( method = "initPusher" );
					scribe.init( namer, fakeSettings );
				} );
				it( "Should return an instance of pusher", function(){
					testme = scribe.init();
					expect( testme ).tobeInstanceOf( "pusher" );
				} );
				it( "if no name is submitted, set the name property to pusher.", function(){
					scribe.init();
					expect( scribe.getName() ).tobe( "pusher" );
				} );
				it( "if a name is submitted, set the name property with that.", function(){
					expect( scribe.getName() ).tobe( namer.replace( "-", "", "all" ) );
				} );
				it( "if an appid is submitted as part of the property struct, set the appid property to that.", function(){
					expect( scribe.getAppId() ).tobe( fakeSettings.appId );
				} );
				it( "if an cluster is submitted as part of the property struct, set the cluster property to that.", function(){
					expect( scribe.getcluster() ).tobe( fakeSettings.cluster );
				} );
				it( "if an apiSecret is submitted as part of the property struct, set the apiSecret property to that.", function(){
					expect( scribe.getapiSecret() ).tobe( fakeSettings.apiSecret );
				} );
				it( "if an key is submitted as part of the property struct, set the key property to that.", function(){
					expect( scribe.getkey() ).tobe( fakeSettings.key );
				} );
				it( "If the application.pusher key does not exist, run initPusher 1x", function(){
					application.delete( "pusher" );
					expect( application.keyExists( "pusher" ) ).tobeFalse();
					scribe.init( namer, fakeSettings );
					expect( scribe.$count( "initPusher" ) ).tobe( 2 );
				} );
				it( "If the application.pusher key is a simple value, run initPusher 1x", function(){
					application.pusher = "";
					expect( application.pusher.len() ).tobe( 0 );
					scribe.init( namer, fakeSettings );
					expect( scribe.$count( "initPusher" ) ).tobe( 2 );
				} );
			}
		);
	}

}
