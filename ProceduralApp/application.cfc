component output='false' {

    this.name = hash( GetBaseTemplatePath() );
    this.applicationTimeout = CreateTimeSpan( 1, 0, 0, 0 );
    this.sessionManagement = true;
    this.sessionTimeout = CreateTimeSpan( 0, 1, 0, 0 );
    

    public boolean function OnApplicationStart() {
        return true;
    }

    public void function OnSessionStart() {
        return;
    }

    public boolean function OnRequestStart( required string targetpage ) {
        if( lcase( right( targetpage, 3 ) ) == 'cfc') {
            structDelete( this, 'OnRequest' );
        }

        return true;
    }

    public void function OnRequest( required string targetpage ) {
        // set some application-wide settings, if not previously set or if url.reload='true'
        if ( !structKeyExists( application, 'settings' ) ||
            ( structKeyExists( url, 'reload' ) && URL.reload == 'true' ) ) {
            application.settings = {};
            application.settings.webroot = '/LegacyApp/';
        }

        // merge the form and url scopes together into form scope for convenience
        structAppend( form, URL );

        // include the requested page 
        cfinclude( template=arguments.targetpage );
    }
}