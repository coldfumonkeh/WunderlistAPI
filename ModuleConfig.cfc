/**
* Matt Gifford, Monkeh Works
* www.monkehworks.com
* ---
* This module connects your application to the Wunderlist API
**/
component {

	// Module Properties
	this.title 				= "Wunderlist API";
	this.author 			= "Matt Gifford";
	this.webURL 			= "https://www.monkehworks.com";
	this.description 		= "This SDK will provide you with connectivity to the Wunderlist API for any ColdFusion (CFML) application.";
	this.version			= "@version.number@+@build.number@";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	this.entryPoint			= 'wunderlist';
	this.modelNamespace		= 'wunderlist';
	this.cfmapping			= 'wunderlist';
	this.autoMapModels 		= false;

	/**
	 * Configure
	 */
	function configure(){

		// Settings
		settings = {
			appID = '',
			appKey = ''
		};
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		parseParentSettings();
		var wunderlistSettings = controller.getConfigSettings().wunderlist;

		// Map Library
		binder.map( "wunderlist@wunderlist" )
			.to( "#moduleMapping#.wunderlist" )
			.initArg( name="clientId",		value=wunderlistSettings.clientId )
			.initArg( name="clientSecret",	value=wunderlistSettings.clientSecret )
			.initArg( name="accessToken",	value=wunderlistSettings.accessToken );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var odDSL 		= oConfig.getPropertyMixin( "wunderlist", "variables", structnew() );

		//defaults
		configStruct.wunderlist = variables.settings;

		// incorporate settings
		structAppend( configStruct.wunderlist, odDSL, true );
	}

}
