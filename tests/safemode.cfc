component extends="org.lucee.cfml.test.LuceeTestCase" labels="markdown" {

	/*
	 * LDEV-3027 / CVE-2026-29519
	 *
	 * safeMode=true must escape raw HTML and sanitize link/image URLs the same way
	 * Lucee 7.1 core does (commonmark escapeHtml + sanitizeUrls). Default stays unchanged.
	 */

	function run( testResults, testBox ){
		describe( title="Testcase for markdownToHTML() safeMode", body=function() {

			it( title = "Checking markdownToHTML safeMode=false", body=function( currentSpec ) {
				var md = [
					"<b>safeMode</b>"
				].toList( chr( 10 ) );
				var html = markdownToHtml( md, false );
				expect( html ).toInclude( "<b>safeMode</b>" );
			});

			it( title = "Checking markdownToHTML safeMode=true", body=function( currentSpec ) {
				var md = [
					"<span>safeMode</span>"
				].toList( chr( 10 ) );
				var html = markdownToHtml( md, true );
				expect( html ).toInclude( "&lt;span&gt;safeMode&lt;/span&gt;" );
			});

			it( title = "safeMode=true escapes raw HTML", body=function( currentSpec ) {
				var html = markdownToHTML( "File not found: /a/<img src=x onerror=alert(1)>/b.cfm", true );
				expect( html ).notToInclude( "<img" );
				expect( html ).toInclude( "&lt;img" );

				html = markdownToHTML( "<script>alert(1)</script>", true );
				expect( html ).notToInclude( "<script" );
			});

			it( title = "safeMode=true drops javascript: links", body=function( currentSpec ) {
				var html = markdownToHTML( "[click](javascript:alert(1))", true );
				expect( html ).notToInclude( "javascript:" );
				expect( html ).toInclude( "click" );
			});

			it( title = "safeMode=true drops javascript: images and other unsafe schemes", body=function( currentSpec ) {
				var schemes = [ "javascript:alert(1)", "JavaScript:alert(1)", "vbscript:msgbox(1)", "data:text/html,hi", "file:///etc/passwd" ];
				loop array=schemes item="destination" {
					var link = markdownToHTML( "[click](#destination#)", true );
					expect( link ).notToInclude( listFirst( destination, ":" ) & ":" );
					var image = markdownToHTML( "![alt](#destination#)", true );
					expect( image ).notToInclude( listFirst( destination, ":" ) & ":" );
				}
			});

			it( title = "safeMode=true still renders markdown and safe URLs", body=function( currentSpec ) {
				var html = markdownToHTML( "**bold** and `a<b`", true );
				expect( html ).toInclude( "<strong>bold</strong>" );
				expect( html ).toInclude( "<code>a&lt;b</code>" );

				html = markdownToHTML( "[site](https://example.com/path) and ![pic](https://example.com/a.png)", true );
				expect( html ).toInclude( "https://example.com/path" );
				expect( html ).toInclude( "https://example.com/a.png" );

				html = markdownToHTML( "[mail](mailto:a@b.example)", true );
				expect( html ).toInclude( "mailto:a@b.example" );

				html = markdownToHTML( "[home](/relative/path)", true );
				expect( html ).toInclude( "/relative/path" );
			});

			it( title = "safeMode works as a member function and via the safe alias", body=function( currentSpec ) {
				expect( "<b>x</b>".markdownToHTML( true ) ).notToInclude( "<b>" );
				expect( markdownToHTML( markdown = "[click](javascript:alert(1))", safe = true ) ).notToInclude( "javascript:" );
				expect( markdownToHTML( string = "[click](javascript:alert(1))", safeMode = true ) ).notToInclude( "javascript:" );
			});

			it( title = "default (safeMode=false) is unchanged", body=function( currentSpec ) {
				expect( markdownToHTML( "<b>x</b>" ) ).toInclude( "<b>x</b>" );
				expect( markdownToHTML( "<b>x</b>", false ) ).toInclude( "<b>x</b>" );
				expect( markdownToHTML( "[click](javascript:alert(1))" ) ).toInclude( "javascript:alert(1)" );
				expect( markdownToHTML( "[click](javascript:alert(1))", false ) ).toInclude( "javascript:alert(1)" );
				expect( markdownToHTML( "![alt](javascript:alert(1))", false ) ).toInclude( "javascript:alert(1)" );
			});

		});
	}

}
